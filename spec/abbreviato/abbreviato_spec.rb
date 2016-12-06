require "spec_helper"
require "byebug"
require "awesome_print"
require "brakecheck"

describe "Abbreviato" do
  NBSP = Nokogiri::HTML("&nbsp;").text

  describe "normal strings" do
    it_does_not_truncate "nil html text with longer length",
      with: { max_length: 99 },
      source: nil,
      expected: ""
    it_does_not_truncate "no html text with longer length",
      with: { max_length: 99 },
      source: "This is some text",
      expected: "<p>This is some text</p>"
    it_truncates "no html text with shorter length, no tail",
      with: { max_length: 12, tail: "" },
      source: "some text",
      expected: "<p>some </p>"
    it_truncates "no html text with shorter length, nil tail",
      with: { max_length: 12, tail: nil },
      source: "some text",
      expected: "<p>some </p>"
    it_truncates "no html text with shorter length, with tail",
      with: { max_length: 12 },
      source: "This is some text",
      expected: "<p>Th...</p>"
  end

  describe "multi-byte strings" do
    # These examples purposely specify a number of bytes which is not divisible by four, to ensure
    # characters don't get brokwn up part-way thorugh their multi-byte representation
    it_does_not_truncate "no html text with longer length",
      with: { max_length: 99, tail: '...' },
      source: "𠲖𠲖𠲖𠲖𠲖𠲖𠲖𠲖",
      expected: "<p>𠲖𠲖𠲖𠲖𠲖𠲖𠲖𠲖</p>"
    it_truncates "no html text with shorter length, no tail",
      with: { max_length: 11, tail: '' },
      source: "𠝹𠝹𠝹𠝹𠝹𠝹𠝹𠝹",
      expected: "<p>𠝹</p>"
    it_truncates "no html text with shorter length, with tail",
      with: { max_length: 14 },
      source: "𠝹𠝹",
      expected: "<p>𠝹...</p>"
  end

  describe "multi-byte tail" do
    # These examples purposely specify a number of bytes which is not divisible by four, to ensure
    # characters don't get brokwn up part-way thorugh their multi-byte representation
    it_does_not_truncate "html text with longer length",
      with: { max_length: 99, tail: '𠴕' },
      source: "<p>𠲖𠲖𠲖𠲖𠲖𠲖𠲖𠲖</p>",
      expected: "<p>𠲖𠲖𠲖𠲖𠲖𠲖𠲖𠲖</p>"
    it_does_not_truncate "html text with equal length",
      with: { max_length: 15, tail: "𠴕" },
      source: "<p>𠝹𠝹</p>",
      expected: "<p>𠝹𠝹</p>"
    it_truncates "html text with shorter length",
      with: { max_length: 15, tail: "𠴕" },
      source: "<p>𠝹𠝹𠝹𠝹</p>",
      expected: "<p>𠝹𠴕</p>"
    it_truncates "html text with shorter length and longer tail",
      with: { max_length: 23, tail: "𠴕𠴕𠴕" },
      source: "<p>𠝹𠝹𠝹𠝹𠝹𠝹</p>",
      expected: "<p>𠝹𠴕𠴕𠴕</p>"
  end

  describe "html entity (ellipsis) tail" do
    it_truncates "html text with ellipsis html entity tail",
      with: { max_length: 27, tail: '&hellip;' },
      source: "<p>This is some text which will be truncated</p>",
      expected: "<p>This is some&hellip;</p>"
  end

  describe "html tags structure" do
    it_truncates "html text with tag",
      with: { max_length: 14 },
      source: "<p>some text</p>",
      expected: "<p>some...</p>"

    it_truncates "html text with nested tags (first node)",
      with: { max_length: 22 },
      source: "<div><p>some text 1</p><p>some text 2</p></div>",
      expected: "<div><p>s...</p></div>"

    it_truncates "html text with nested tags (second node)",
      with: { max_length: 46 },
      source: "<div><p>some text 1</p><p>some text 2</p></div>",
      expected: "<div><p>some text 1</p><p>some te...</p></div>"

    it_truncates "html text with nested tags (empty contents)",
      with: { max_length: 13 },
      source: "<div><p>some text 1</p><p>some text 2</p></div>",
      expected: "<div></div>"

    it_truncates "html text with special html entities",
      with: { max_length: 15 },
      source: "<p>&gt;some text</p>",
      expected: "<p>&gt;s...</p>"

    it_truncates "html text with siblings tags",
      with: { max_length: 64 },
      source: "<div>some text 0</div><div><p>some text 1</p><p>some text 2</p></div>",
      expected: "<div>some text 0</div><div><p>some text 1</p><p>som...</p></div>"

    it_does_not_truncate "html with unclosed tags",
      with: { max_length: 151 },
      source: "<table><tr><td>Hi <br> there</td></tr></table>",
      expected: "<table><tr><td>Hi <br/> there</td></tr></table>"

    it_does_not_truncate "preserve html entities",
      with: { max_length: 99 },
      source: "<o:p>&nbsp;</o:p>",
      expected: "<o:p>&nbsp;</o:p>"

    it_truncates "while preserving html entities (all or nothing)",
      with: { max_length: 26 }, # Too small to bring all of &nbsp; in
      source: "<o:p>Hello there&nbsp;</o:p>",
      expected: "<o:p>Hello there...</o:p>"
  end

  describe "single html tag elements" do
    it_truncates "html text with <br /> element without adding a closing tag",
      with: { max_length: 30 },
      source: "<div><h1><br/>some text 1</h1><p>some text 2</p></div>",
      expected: "<div><h1><br/>so...</h1></div>"

    it_truncates "html text with <br /> element with a closing tag",
      with: { max_length: 30 },
      source: "<div><h1><br></br>some text 1</h1><p>some text 2</p></div>",
      expected: "<div><h1><br/>so...</h1></div>"

    it_truncates "html text with <img/> element without adding a closing tag",
      with: { max_length: 45 },
      source: "<div><p><img src='some_path'/>some text 1</p><p>some text 2</p></div>",
      expected: "<div><p><img src='some_path'/>so...</p></div>"

    it_truncates "html text with <img/> element with a closing tag",
      with: { max_length: 45 },
      source: "<div><p><img src='some_path'></img>some text 1</p><p>some text 2</p></div>",
      expected: "<div><p><img src='some_path'/>so...</p></div>"
  end

  describe "invalid html" do
    it_truncates "html text with unclosed elements 1",
      with: { max_length: 30 },
      source: "<div><h1><br/>some text 1</h1><p>some text 2",
      expected: "<div><h1><br/>so...</h1></div>"
    it_truncates "html text with unclosed elements 2",
      with: { max_length: 30 },
      source: "<div><h1><br>some text 1<p>some text 2",
      expected: "<div><h1><br/>so...</h1></div>"
    it_truncates "html text with unclosed br element",
      with: { max_length: 30 },
      source: "<div><h1><br>some text 1</h1><p>some text 2",
      expected: "<div><h1><br/>so...</h1></div>"
    it_truncates "html text with mis-matched elements",
      with: { max_length: 30 },
      source: "<div><h1><br/>some text 1</h2><p>some text 2</span></table>",
      expected: "<div><h1><br/>so...</h1></div>"
  end

  describe "comment html element" do
    it_does_not_truncate "retains comments",
      with: { max_length: 35 },
      source: "<div><!--This is a comment--></div>",
      expected: "<div><!--This is a comment--></div>"

    it_truncates "doesn't truncate comments themselves (all or nothing)",
      with: { max_length: 34 },
      source: "<div><!--This is a comment--></div>",
      expected: "<div></div>"
  end

  describe "html attributes" do
    it_truncates "html text with 1 attributes",
      with: { max_length: 23 },
      source: "<p attr1='1'>some text</p>",
      expected: "<p attr1='1'>som...</p>"

    it_truncates "html text with 2 attributes",
      with: { max_length: 33 },
      source: "<p attr1='1' attr2='2'>some text</p>",
      expected: "<p attr1='1' attr2='2'>som...</p>"

    it_truncates "html text with attributes in nested tags",
      with: { max_length: 35 },
      source: "<div><p attr1='1'>some text</p></div>",
      expected: "<div><p attr1='1'>some...</p></div>"
  end

  describe "cdata blocks" do
    # This comes from a real-world example which requires cdata support to bring in the CSS
    let(:cdata_example) { File.read('spec/fixtures/cdata_example.html') }
    it "cdata blocks are preserved" do
      text, truncated = Abbreviato.truncate(cdata_example, max_length: 65535)
      expect(text.length).to eq 3583
      expect(truncated).to be_falsey
    end
  end

  describe "edge-cases: long tags" do
    it_truncates "completely removes tags and contents if the tags will not fit",
      with: { max_length: 33 },
      source: "<really_a_very_long_tag_name>text</really_a_very_long_tag_name>",
      expected: ""
    it_truncates "does not allow closing tags to get added without opening tags",
      with: { max_length: 61 },
      source: "<really_a_very_long_tag_name>text</really_a_very_long_tag_name>",
      expected: "<really_a_very_long_tag_name></really_a_very_long_tag_name>"
    it_truncates "does not allow closing tags to get added without opening tags",
      with: { max_length: 62 },
      source: "<really_a_very_long_tag_name>text</really_a_very_long_tag_name>",
      expected: "<really_a_very_long_tag_name>...</really_a_very_long_tag_name>"
    it_does_not_truncate "does not allow closing tags to get added without opening tags",
      with: { max_length: 63 },
      source: "<really_a_very_long_tag_name>text</really_a_very_long_tag_name>",
      expected: "<really_a_very_long_tag_name>text</really_a_very_long_tag_name>"
  end

  describe "edge-cases:" do
    it_truncates "discard a single element within a longer element and use the following html (assuming it will fit)",
      with: { max_length: 9 },
      source: "<span><input/></span><p>.</p>",
      expected: "<p>.</p>"
    it_truncates "discard a single element within a longer element",
      with: { max_length: 10 },
      source: "<span><p></p></span><h1>.</h1>",
      expected: "<h1>.</h1>"
    it_truncates "some semi-random elements",
      with: { max_length: 10 },
      source: "<span><p><br/><br/><br/><p><br/></span><h1></h2>.</h3><h4><br/>",
      expected: "<h1>.</h1>"
    it_does_not_truncate "junk, including various html chars",
      with: { max_length: 10 },
      source: "<<< /  > < 0)(*&^*&^%${#}><? < /",
      expected: ""
    it_truncates "outer tags fit exactly",
      with: { max_length: 13 },
      source: "<span><p></p></span>",
      expected: "<span></span>"
    it_truncates "outer tags and opening inner tag fit exactly",
      with: { max_length: 16 },
      source: "<span><p></p></span>",
      expected: "<span></span>"
    it_truncates "void tags which do not fit",
      with: { max_length: 5 },
      source: "<command>",
      expected: ""
    it_truncates "void tags within outer tags which do not fit",
      with: { max_length: 15 },
      source: "<p><command/></p>",
      expected: "<p></p>"
    it_does_not_truncate "void tags within outer tags which fit",
      with: { max_length: 17 },
      source: "<p><command/></p>",
      expected: "<p><command/></p>"
    it_truncates "outer tags which fit perfectly within inner content",
      with: { max_length: 7 },
      source: "<p>hello</p>",
      expected: "<p></p>"
  end

  describe "void tags" do
    TruncatedSaxDocument::VOID_TAGS.each do |tag|
      it_does_not_truncate "void tag: #{tag} doesn't get closing element added",
        with: { max_length: 100 },
        source: "<#{tag}/>",
        expected: "<#{tag}/>"

      it_does_not_truncate "void tag: #{tag} has closing element stripped",
        with: { max_length: 100 },
        source: "<#{tag}></#{tag}>",
        expected: "<#{tag}/>"
    end
  end

  describe "fragment mode" do
    it_truncates "doesn't add `head` and `body` tags",
      with: { max_length: 15 },
      source: "<p>hello there</p>",
      expected: "<p>hello...</p>"
  end

  describe "document mode" do
    it_truncates "preserves `html`, `head` and `body` tags",
      with: { max_length: 54, fragment: false },
      source: "<html><head></head><body><p>hello there</p></body></html>",
      expected: "<html><head></head><body><p>hello...</p></body></html>"

    it_does_not_truncate "preserves html attributes",
      with: { max_length: 999, fragment: false },
      source: "<html xmlns:v='urn:schemas-microsoft-com:vml' xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:word' xmlns:m='http://schemas.microsoft.com/office/2004/12/omml' xmlns='http://www.w3.org/TR/REC-html40'></html>",
      expected: "<html xmlns:v='urn:schemas-microsoft-com:vml' xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:word' xmlns:m='http://schemas.microsoft.com/office/2004/12/omml' xmlns='http://www.w3.org/TR/REC-html40'></html>"

    it_does_not_truncate "preserves meta tags and their attributes",
      with: { max_length: 999, fragment: false },
      source: "<html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'></head></html>",
      expected: "<html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'/></head></html>"

    it_does_not_truncate "preserves comments in the head",
      with: { max_length: 999, fragment: false },
      source: "<html><head><!--[if !mso]><style>v\\:* {behavior:url(#default#VML);} o\\:* {behavior:url(#default#VML);} w\\:* {behavior:url(#default#VML);} .shape {behavior:url(#default#VML);} </style><![endif]--></head></html>",
      expected: "<html><head><!--[if !mso]><style>v\\:* {behavior:url(#default#VML);} o\\:* {behavior:url(#default#VML);} w\\:* {behavior:url(#default#VML);} .shape {behavior:url(#default#VML);} </style><![endif]--></head></html>"

    it_does_not_truncate "preserves styles",
      with: { max_length: 999, fragment: false },
      source: "<html><head><style><!-- /* Font Definitions */ @font-face {font-family:Wingdings; panose-1:5 0 0 0 0 0 0 0 0 0;} </style></head></html>",
      expected: "<html><head><style><!-- /* Font Definitions */ @font-face {font-family:Wingdings; panose-1:5 0 0 0 0 0 0 0 0 0;} </style></head></html>"

    it_does_not_truncate "preservers body attributes",
      with: { max_length: 999, fragment: false },
      source: "<html><body lang='EN-US' link='blue' vlink='purple'></body></html>",
      expected: "<html><body lang='EN-US' link='blue' vlink='purple'></body></html>"
  end

  describe "wbr element support" do
    it_does_not_truncate "preserves <wbr> elements",
      with: { max_length: 100 },
      source: "<p>The quick<wbr>brown fox<wbr>jumped over the lazy dog</p>",
      expected: "<p>The quick<wbr/>brown fox<wbr/>jumped over the lazy dog</p>"
  end

  let(:html_1Kb_doc) { File.read('spec/fixtures/html_1Mb.html') }
  let(:html_1Mb_doc) { File.read('spec/fixtures/html_1Mb.html') }
  let(:html_10Mb_doc) { File.read('spec/fixtures/html_1Mb.html') }
  let(:bench) { Benchmark::Perf::ExecutionTime.new(samples: 10) }

  it "speed is proportional to length of truncated string, not input" do
    mean_one_kb, = bench.run do
      Abbreviato.truncate(html_1Kb_doc, max_length: 1000)
    end
    mean_one_mb, = bench.run do
      Abbreviato.truncate(html_1Mb_doc, max_length: 1000)
    end
    mean_ten_mb, = bench.run do
      Abbreviato.truncate(html_10Mb_doc, max_length: 1000)
    end

    avg = (mean_one_kb + mean_one_mb + mean_ten_mb) / 3
    variance = Math.sqrt(((mean_one_kb - avg)**2 + (mean_one_mb - avg)**2 + (mean_ten_mb - avg)**2) / 3)

    # This was tested by increasing the max_length on the benchmarks above. If the processing time is
    # proportional to the document size, the variance is closer to 0.2
    expect(variance).to be < 0.002
  end

  it "memory usage is proportional to length of truncated string, not input" do
    # Measured memory usage is around 500K for all of these
    report = Benchmark.memory(quiet: true) do |x|
      x.report("1Kb")  { Abbreviato.truncate(html_1Kb_doc,  max_length: 1000) }
      x.report("1Mb")  { Abbreviato.truncate(html_1Mb_doc,  max_length: 1000) }
      x.report("10Mb") { Abbreviato.truncate(html_10Mb_doc, max_length: 1000) }
    end
    expect(report.entries[0].measurement.metrics[0].allocated).to be_within(1000).of report.entries[1].measurement.metrics[0].allocated
    expect(report.entries[1].measurement.metrics[0].allocated).to be_within(1000).of report.entries[2].measurement.metrics[0].allocated
  end

  # Preserve this code as an example of truncating a real-world (PII-less) example
  # let(:real_world_doc) { File.read('spec/fixtures/real_world_example.html') }
  # it "works with a real-life example" do
  #   truncated = Abbreviato.truncate(real_world_doc,  max_length: 65535)
  #   File.open('spec/fixtures/real_world_example_truncated.html', 'w') { |file| file.write(truncated) }
  # end

  describe "Brakeman" do
    it "is up to date" do
      expect("brakeman").to be_the_latest_version
    end
  end
end
