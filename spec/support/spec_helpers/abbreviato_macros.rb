# frozen_string_literal: true

module AbbreviatoMacros
  def test_truncation(example_description, should_truncate, options)
    it "should truncate #{example_description}" do
      expected_options = Abbreviato::DEFAULT_OPTIONS.merge(options[:with])
      result, truncated = Abbreviato.truncate(options[:source], expected_options)
      expect(result).to eq options[:expected]
      expect(result.bytesize).to be <= expected_options[:max_length]
      expect(result).to be_valid_html
      expect(truncated).to eq should_truncate
    end
  end

  def it_truncates(example_description, options)
    test_truncation(example_description, true, options)
  end

  def it_does_not_truncate(example_description, options)
    test_truncation(example_description, false, options)
  end
end
