# abbreviato

[![Build Status](https://travis-ci.org/zendesk/abbreviato.svg?branch=master)](https://travis-ci.org/zendesk/abbreviato)
[![Gem Version](https://img.shields.io/gem/v/abbreviato.svg)](https://rubygems.org/gems/abbreviato)

*abbreviato* is a Ruby library for truncating HTML strings keeping the markup valid. It is a fork of [jorgemanrubia/truncato](https://github.com/jorgemanrubia/truncato) but focused on truncating to a bytesize, not on a per-character basis.

## Installing

In your `Gemfile`

```ruby
gem 'abbreviato'
```

## Usage

```ruby
truncated_string, was_truncated = Abbreviato.truncate("<p>some text</p>", max_length: 4)
# => ["<p>s...</p>", true]
```

The configuration options are:

* `max_length`: The size, in bytes, to truncate (`30` by default)
* `tail`: The string to append when the truncation occurs ('&hellip;' by default).
* `fragment`: Indicates whether the document to be truncated is an HTML fragment or an entire document (with `HTML`, `HEAD` & `BODY` tags). Setting to true prevents automatic
addition of these tags if they are missing. Defaults to `true`.

## Performance

Abbreviato was designed with performance in mind. Its main motivation was that existing libs couldn't truncate a multiple-MB document into a few-KB one in a reasonable time. It uses the [Nokogiri](http://nokogiri.org/) SAX parser.

## Running the tests

```ruby
bundle exec rake
```

## Running all checks

```ruby
bundle exec wwtd
```

## Contribute

Follow our [contribution guidelines](CONTRIBUTING.md).
