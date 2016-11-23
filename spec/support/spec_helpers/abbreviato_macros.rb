module AbbreviatoMacros
  def it_should_truncate(example_description, should_truncate, options)
    it "should truncate #{example_description}" do
      expected_options = Abbreviato::DEFAULT_OPTIONS.merge(options[:with])
      result, truncated = Abbreviato.truncate(options[:source], expected_options)
      expect(result).to eq options[:expected]
      expect(result.bytesize).to be <= expected_options[:max_length]
      expect(result).to be_valid_html
      expect(truncated).to eq should_truncate
    end
  end
end
