# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2023-06-14

* Adds support for Ruby 3.0, 3.1, and 3.2
* Drops support for Ruby 2.6
* Invalid HTML with unpaired opening brackets is now truncated to a non-HTML string, e.g., `"<<p>hello there</p>"` will be truncated to `"&lt;<p></p>"`.  Previously, it was truncated to a valid HTML string `"<p>&hellip;</p>"`. If your inputs can be invalid HTML strings, you should check them before abbreviating (for example, using Nokogiri).
