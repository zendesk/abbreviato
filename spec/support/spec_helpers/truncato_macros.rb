module TruncatoMacros
  def it_should_truncate(example_description, options)
    it "should truncate #{example_description}" do
      count_bytes = options[:count_bytes]
      expected_options = count_bytes ? Truncato::DEFAULT_BYTESIZE_OPTIONS.merge(options[:with]) : Truncato::DEFAULT_CHARACTER_OPTIONS.merge(options[:with])
      result = Truncato.truncate(options[:source], expected_options)
      expect(result).to eq options[:expected]

      if count_bytes
        expect(result.bytesize).to be <= expected_options[:max_length]
      elsif expected_options[:count_tags] && expected_options[:count_tail]
        # Only realistic to check length if we're counting tags and tail
        expect(result.length).to be <= expected_options[:max_length]
      end
      expect(result).to be_valid_html
    end
  end
end
