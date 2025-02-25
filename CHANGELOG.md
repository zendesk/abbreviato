# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.2.0] - 2025-02-25

* Drops support for Ruby 3.0
* Bumps nokogiri to 1.18.3
* Bumps rubocop to 1.73 to ensure we have support for ruby 3.3
* Bumps ruby to 3.3.7

## [3.1.4] - 2025-01-23

* No/OP

## [3.1.3] - 2025-01-23

* No/OP

## [3.1.2] - 2025-01-23

* Set nokogiri gem to v1.17.2
* Updates rexml from 3.2.8 to 3.3.3

## [3.1.1] - 2024-08-13

* Bump rexml from 3.2.8 to 3.3.3.

## [3.1.0] - 2024-08-13

* Bump the bundler group across 1 directory with 2 updates.

## [3.0.0] - 2024-03-06

* Drops support for Ruby 2.7
* Adds tests on Ruby 3.3

## [2.0.0] - 2023-06-14

* Adds support for Ruby 3.0, 3.1, and 3.2
* Drops support for Ruby 2.6
* Invalid HTML with unpaired opening brackets is now truncated to a non-HTML string, e.g., `"<<p>hello there</p>"` will be truncated to `"&lt;<p></p>"`.  Previously, it was truncated to a valid HTML string `"<p>&hellip;</p>"`. If your inputs can be invalid HTML strings, you should check them before abbreviating (for example, using Nokogiri).
