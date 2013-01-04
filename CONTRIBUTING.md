# Contributing to Mina

Want to get involved? Thanks! There are plenty of ways to help!

## Reporting issues

A bug is a _demonstrable problem_ that is caused by the code in the
repository.

Please read the following guidelines before you [report an issue][issues]:

1. **Use the GitHub issue search** &mdash; check if the issue has already been
   reported. If it has been, please comment on the existing issue.

2. **Check if the issue has been fixed** &mdash; the latest `master` or
   development branch may already contain a fix.

3. **Isolate the demonstrable problem** &mdash; make sure that the code in the
   project's repository is _definitely_ responsible for the issue. Create a
   [reduced test case](http://css-tricks.com/6263-reduced-test-cases/) - an
   extremely simple and immediately viewable example of the issue.

Please try to be as detailed as possible in your report too. What is your
environment? What steps will reproduce the issue? What would you expect to be 
the outcome? All these details will help people to assess and fix any potential 
bugs.

### Example of a good bug report:

> Short and descriptive title
>
> A summary of the issue and the OS environment in which it occurs. If
> suitable, include the steps required to reproduce the bug.
>
> 1. This is the first step
> 2. This is the second step
> 3. Further steps, etc.
>
> `<url>` (a link to the reduced test case)
>
> Any other information you want to share that is relevant to the issue being
> reported. This might include the lines of code that you have identified as
> causing the bug, and potential solutions (and your opinions on their
> merits).

A good bug report shouldn't leave people needing to chase you up to get further
information that is required to assess or fix the bug.

**[File a bug report][issues]**

## Responding to issues

Feel free to respond to other people's issues! Some people may be reporting 
issues that can easily be solved even without modification to the project's 
code.

You can also help by verifying issues reported.

**[View issues][issues]**

## The 'help wanted' tag

Some [issues] are tagged with the 'help wanted' tag. These issues often:

 - are missing an actual implementation, or
 - need people's help in verifying and replicating the issue, or
 - need test cases.

If you would like to contribute code and don't have any specific issue you want 
to fix, this would be a good place to start looking at!

**[View issues][issues]**

## Pull requests

Good pull requests — patches, improvements, new features — are a fantastic
help. They should remain focused in scope and avoid containing unrelated
commits.

If your contribution involves a significant amount of work or substantial
changes to any part of the project, please open an issue to discuss it first.

Please follow this process; it's the best way to get your work included in the
project:

1. [Fork](http://help.github.com/fork-a-repo/) the project.

2. Clone your fork (`git clone
   https://github.com/<your-username>/html5-boilerplate.git`).

3. Add an `upstream` remote (`git remote add upstream
   https://github.com/nadarei/mina.git`).

4. Get the latest changes from upstream (e.g. `git pull upstream
   <dev-branch>`).

5. Create a new topic branch to contain your feature, change, or fix (`git
   checkout -b <topic-branch-name>`).

6. Make sure that your changes adhere to the current coding conventions used
   throughout the project - indentation, accurate comments, etc. Please update
   any documentation that is relevant to the change you are making.

7. Commit your changes in logical chunks; use git's [interactive
   rebase](https://help.github.com/articles/interactive-rebase) feature to tidy
   up your commits before making them public. Please adhere to these [git commit
   message
   guidelines](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
   or your pull request is unlikely be merged into the main project.

8. Locally merge (or rebase) the upstream branch into your topic branch.

9. Push your topic branch up to your fork (`git push origin
   <topic-branch-name>`).

10. [Open a Pull Request](http://help.github.com/send-pull-requests/) with a
    clear title and description. Please mention which browsers you tested in.

## Acknowledgements

This contributing guide has been adapted from [HTML5 boilerplate's guide][g].

[g]: https://github.com/h5bp/html5-boilerplate/blob/master/CONTRIBUTING.md
[issues]: https://github.com/nadarei/mina/issues/
