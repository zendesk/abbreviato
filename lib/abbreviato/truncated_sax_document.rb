require 'nokogiri'
require 'htmlentities'

class TruncatedSaxDocument < Nokogiri::XML::SAX::Document
  IGNORABLE_TAGS = %w[html head body].freeze

  # These don't have to be closed (which also impacts ongoing length calculations)
  # http://www.456bereastreet.com/archive/201005/void_empty_elements_and_self-closing_start_tags_in_html/
  VOID_TAGS = %w[area base br col command hr img input keygen link meta param source wbr].freeze

  attr_reader :truncated_string,
    :max_length,
    :tail,
    :ignored_levels

  def initialize(options)
    @html_coder = HTMLEntities.new

    @max_length = options[:max_length]
    @tail = options[:tail]

    @truncated_string = ""
    @closing_tags = []
    @estimated_length = 0
    @ignored_levels = 0
  end

  # This method is called when the parser encounters an open tag
  def start_element(name, attributes)
    return if max_length_reached || ignorable_tag?(name)

    # If already in ignore mode, go in deeper
    if ignore_mode?
      enter_ignored_level unless single_tag_element?(name)
      return
    end

    string_to_add = opening_tag(name, attributes)

    # Abort if there is not enough space to add the combined opening tag and (potentially) the closing tag
    length_of_tags = overridden_tag_length(name, string_to_add)
    if length_of_tags > remaining_length
      enter_ignored_level unless single_tag_element?(name)
      return
    end

    # Save the tag so we can push it on at the end
    @closing_tags.push name unless single_tag_element?(name)

    append_to_truncated_string(string_to_add, length_of_tags)
  end

  # This method is called when the parser encounters characters between tags
  def characters(decoded_string)
    return if max_length_reached || ignore_mode?

    # Use encoded length, so &gt; counts as 4 bytes, not 1 (which is what '>' would give)
    encoded_string = @html_coder.encode(decoded_string, :named)
    string_to_append = if encoded_string.bytesize > remaining_length
      # This is the line which prevents HTML entities getting truncated - treat them as a single char
      str = @html_coder.encode(truncate_string(decoded_string), :named)
      str << tail if remaining_length >= tail.bytesize
      str
    else
      encoded_string
    end
    append_to_truncated_string(string_to_append)
  end

  # This method is called when the parser encounters an comment
  def comment(string)
    comment = comment_tag(string)
    append_to_truncated_string(comment) if comment.bytesize <= remaining_length
  end

  # This method is called when the parser encounters cdata. In practice, this also
  # gets called for this style of comment inside an element:
  #
  #   <style><!--
  #     /* Font Definitions */
  #     @font-face
  #       {font-family:Wingdings;
  #       panose-1:5 0 0 0 0 0 0 0 0 0;}
  #   --></style>
  #
  def cdata_block(string)
    append_to_truncated_string(string) if string.bytesize <= remaining_length
  end

  # This method is called when the parser encounters a closing tag
  def end_element(name)
    if ignore_mode?
      exit_ignored_level unless single_tag_element?(name)
      return
    end
    return if max_length_reached || ignorable_tag?(name)

    unless single_tag_element?(name)
      @closing_tags.pop
      # Don't count the length when closing a tag - it was accommodated when
      # the tag was opened
      append_to_truncated_string(closing_tag(name), 0)
    end
  end

  def end_document
    @closing_tags.reverse.each { |name| append_to_truncated_string(closing_tag(name)) }
  end

  private

  def opening_tag(name, attributes)
    attributes_string = attributes_to_string(attributes)
    if single_tag_element? name
      "<#{name}#{attributes_string}/>"
    else
      "<#{name}#{attributes_string}>"
    end
  end

  def comment_tag(comment)
    "<!--#{comment}-->"
  end

  def closing_tag(name)
    "</#{name}>"
  end

  def remaining_length
    max_length - @estimated_length
  end

  def single_tag_element?(name)
    VOID_TAGS.include? name
  end

  def append_to_truncated_string(string, overridden_length = nil)
    @truncated_string << string
    @estimated_length += (overridden_length || string.bytesize)
  end

  def attributes_to_string(attributes)
    attributes.inject(' ') do |string, attribute|
      key, value = attribute
      string << "#{key}='#{@html_coder.encode value}' "
    end.rstrip
  end

  def max_length_reached
    @estimated_length >= max_length
  end

  def truncate_string(string)
    truncate_length = remaining_length - tail.bytesize
    (string.byteslice(0, truncate_length) || '').scrub('')
  end

  def overridden_tag_length(tag_name, rendered_tag_with_attributes)
    # Start with the opening tag
    length = rendered_tag_with_attributes.bytesize

    # Add on closing tag if necessary
    length += closing_tag(tag_name).bytesize unless single_tag_element?(tag_name)
    length
  end

  def ignorable_tag?(name)
    IGNORABLE_TAGS.include?(name.downcase)
  end

  def enter_ignored_level
    @ignored_levels += 1
  end

  def exit_ignored_level
    @ignored_levels -= 1
  end

  def ignore_mode?
    @ignored_levels > 0
  end
end
