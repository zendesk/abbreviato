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

## Running the tests

```ruby
rspec
```


