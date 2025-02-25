# How to contribute

Pull requests are welcome on GitHub at https://github.com/zendesk/abbreviato

## Pull Requests

- You need at least one review approval before merging.
- Always include specs, and please make sure our CI is green.
- Send GitHub's review request if you need specific reviewers.
- Assign yourself in the PRs.
- Keep your branch up-to-date with the default branch.

## Gem release

After merging your changes into master, cut a tag and push it immediately:

1. Update the version in `lib/abbreviato/version.rb`.
1. Run `git tag -a vX.X.X -m "Describe the changes"` (replace with your tag).
1. Update the repository `git push --tags`
1. Run `gem build abbreviato.gemspec`
1. Run `gem push abbreviato-x.y.z.gem`

Note: you need proper credientials from http://rubygems.org. You can follow the guide at [api-authorization](https://guides.rubygems.org/rubygems-org-api/#api-authorization).

## Coding conventions

- Ruby styleguide: https://github.com/bbatsov/ruby-style-guide
- Specs styleguide: http://betterspecs.org/
