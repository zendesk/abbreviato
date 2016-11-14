# Adapter for comparing https://github.com/nono/HTML-Abbreviator
module Abbreviato
  class VendorHtmlAbbreviatorAdapter
    def self.truncate(string, options)
      HTML_Abbreviator.truncate string, options[:max_length], ellipsis: "..."
    end
  end
end

# [{Abbreviato::VendorHtmlAbbreviatorAdapter=>{:truncated_length=>3584682, :time=>223.36}}]
