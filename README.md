# abbreviato

*abbreviato* is a Ruby library for truncating HTML strings keeping the markup valid. It is a fork of github.com/jorgemanrubia/truncato but focused on truncating to a bytesize, not on a per-character basis.

## Installing

In your `Gemfile`

```ruby
gem 'abbreviato'
```

## Usage

```ruby
truncated_string, was_truncated = Abbreviato.truncate("<p>some text</p>", max_length: 4) #=> ["<p>s...</p>", true]
```

The configuration options are:

* `max_length`: The size, in bytes, to truncate (`30` by default)
* `tail`: The string to append when the truncation occurs ('...' by default). Supports HTML entities such as '&hellip;'

## Performance

Abbreviato was designed with performance in mind. Its main motivation was that existing libs couldn't truncate a multiple-MB document into a few-KB one in a reasonable time. It uses the [Nokogiri](http://nokogiri.org/) SAX parser.

There is a benchmark included that generates a synthetic XML of 4MB and truncates it to 400 KB. You can run the benchmark using

```ruby
rake abbreviato:benchmark
```

There is a also a comparison benchmark that tests the previous data with other alternatives

```ruby
rake abbreviato:vendor_compare
```

The results comparing abbreviato with other libs:

<table>
  <tr>
    <th></th>
    <th>Abbreviato</th>
    <th><a href="https://github.com/ianwhite/truncate_html">truncate_html</a></th>
    <th><a href="https://github.com/nono/HTML-Abbreviator">HTML Abbreviator</a></th>
    <th><a href="https://github.com/wadewest/peppercorn">peppercorn</a></th>
  </tr>
  <tr>
    <th>Time for truncating a 4MB XML document to 4KB</th>
    <td>1.5 s</td>
    <td>20 s</td>
    <td>220 s</td>
    <td>232 s</td>
  </tr>
</table>

## Running the tests

```ruby
rspec
```


