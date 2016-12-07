module Abbreviato
  DEFAULT_OPTIONS = {
      max_length: 30,
      tail: '&hellip;',
      fragment: true
  }.freeze

  # Truncates the source XML string and returns the truncated XML and a boolean flag indicating
  # whether any truncation took place. It will keep a valid XML structure
  # and insert a _tail_ text indicating the position where content was removed (...).
  #
  # @param [String] source the XML source to truncate
  # @param [Hash] user_options truncation options
  # @option user_options [Integer] :max_length Maximum length
  # @option user_options [String] :tail text to append when the truncation happens
  # @return [[String] the truncated string, [boolean] whether the string was truncated]
  def self.truncate(source = '', user_options = {})
    return [nil, false] if source.nil?
    truncated_sax_document = TruncatedSaxDocument.new(DEFAULT_OPTIONS.merge(user_options))
    parser = Nokogiri::HTML::SAX::Parser.new(truncated_sax_document)
    parser.parse(source) { |context| context.replace_entities = false }
    [truncated_sax_document.truncated_string, truncated_sax_document.truncated]
  end
end
