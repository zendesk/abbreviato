# How to contribute ⛑

Pull requests are welcome on GitHub at https://github.com/zendesk/abbreviato

## Pull Requests

- /CC **@zendesk/strongbad** team and your team when the PR is ready for code review.
- You need at least one review approval or a 👍 comment before merging.
- Always include specs, and please make sure our CI is green 🍏.
- Send GitHub's review request if you need specific reviewers 👀.
- Use GitHub's tags/labels to describe the current status of the PR (e.g. WIP, On-Hold).
- Assign yourself in the PRs.
- Keep your branch up-to-date with Master.

## Gem release

- After merging your changes into master, cut a tag and push it immediately:

    1. Update the version by `bundle exec rake bump:patch` or `bundle exec rake bump:minor`.
    2. Update the repository `git push --tags`
    3. Run `gem build abbreviato.gemspec`
    4. Run `gem push abbreviato-x.y.z.gem`

## Coding conventions

- Ruby styleguide: https://github.com/bbatsov/ruby-style-guide
- Specs styleguide: http://betterspecs.org/
