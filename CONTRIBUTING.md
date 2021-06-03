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

1. Update the version by `bundle exec rake bump:patch` or `bundle exec rake bump:minor`.
2. Update the repository `git push --tags`
3. Run `gem build abbreviato.gemspec`
4. Run `gem push abbreviato-x.y.z.gem`

Note: you need proper credientials from http://rubygems.org. You can follow the guide at [api-authorization](https://guides.rubygems.org/rubygems-org-api/#api-authorization).

## Coding conventions

- Ruby styleguide: https://github.com/bbatsov/ruby-style-guide
- Specs styleguide: http://betterspecs.org/
