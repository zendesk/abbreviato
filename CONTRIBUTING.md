# How to contribute

Pull requests are welcome on GitHub at https://github.com/zendesk/abbreviato

## Pull Requests

- You need at least one review approval before merging.
- Always include specs, and please make sure our CI is green.
- Send GitHub's review request if you need specific reviewers.
- Assign yourself in the PRs.
- Keep your branch up-to-date with the default branch.

### Releasing a new version
A new version is published to RubyGems.org every time a change to `version.rb` is pushed to the `main` branch.
In short, follow these steps:
1. Update `version.rb`,
2. run `bundle lock` to update `Gemfile.lock`,
3. merge this change into `main`, and
4. look at [the action](https://github.com/zendesk/abbreviato/actions/workflows/publish.yml) for output.

To create a pre-release from a non-main branch:
1. change the version in `version.rb` to something like `1.2.0.pre.1` or `2.0.0.beta.2`,
2. push this change to your branch,
3. go to [Actions → “Publish to RubyGems.org” on GitHub](https://github.com/zendesk/abbreviato/actions/workflows/publish.yml),
4. click the “Run workflow” button,
5. pick your branch from a dropdown.

## Coding conventions

- Ruby styleguide: https://github.com/bbatsov/ruby-style-guide
- Specs styleguide: http://betterspecs.org/
