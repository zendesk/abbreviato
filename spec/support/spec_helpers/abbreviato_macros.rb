module AbbreviatoMacros
  def it_should_truncate(example_description, options)
    it "should truncate #{example_description}" do
      count_bytes = options[:count_bytes]
      expected_options = count_bytes ? Abbreviato::DEFAULT_BYTESIZE_OPTIONS.merge(options[:with]) : Abbreviato::DEFAULT_OPTIONS.merge(options[:with])
      result = Abbreviato.truncate(options[:source], expected_options)
      expect(result).to eq options[:expected]
      expect(result.bytesize).to be <= expected_options[:max_length]
      expect(result).to be_valid_html
    end
  end
end
