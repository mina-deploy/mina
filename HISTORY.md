Latest version - Mar 27, 2015
-----------------------------

### Fixed:
  * invoke does not work after a to block (#285)

### Added:
  * before and after hooks


Latest version - Mar 10, 2015
-----------------------------

### Fixed:
  * link typo in readme (#273) [Henare Degan]
  * up formatting of code block in readme (#274) [Henare Degan]
  * Rolling back to previous release (#9) [Tyler Mandry]
  * ruby 1.8.7 and rake 0.9 issue with invoke

### Changed:
  * update 3rd party list
  * update docs, added db_rollback rails command

[Tyler Mandry]: https://github.com/tmandry
[Henare Degan]: https://github.com/henare


v0.3.2 - January 24, 2015
-----------------------------

* 3rd party modules (#258) [Denis]
* Adding support for environment variables, env_var (#161) [Ted Price]
* Make rails console task dependent on the environment (#220) [lucapette]
* mention  .ruby-version for rbenv comment (#249) [Tomi]
* update emails for travis
* npm support with a simple npm:install task (#227) [Paul B.]
* `mina ssh` command to connect to server (#249) [Anton Dieterle]
* link in the support guide (#254) [Aaditya S]

[Denis]: https://github.com/stereodenis
[Aaditya S]: https://github.com/jartek
[Tomi]: https://github.com/equivalent
[lucapette]: https://github.com/lucapette
[Ted Price]: https://github.com/pricees
[Anton Dieterle]: https://github.com/adie
[Paul B.]: https://github.com/paulRbr


v0.3.1 - October 17, 2014
-------------------------

* Fix copy command for assets. (#150) [Joshua Dover]
* Add comment for system-wide RVM install. (#112) [Sam Qiu]
* Incorrect exit status if deploy fails (#95) [Alexander Borovsky]
* Bundler: Allow configuration of groups to be skipped during installation (#123) [Luis Lavena]
* Parse task string to reenable task (#189) [Pedro Chambino]
* Update Travis CI to test via Ruby 2.1.2. (#197) [Luciano Sousa]
* Add jRuby support by using threads instead of fork. (#147, #148) [Jan Berdajs]
* Add rescue for rubinius SignalException. (#204) [Qen]
* Using `bundle_bin` instead `bundle` in whenever tasks. (#195) [Maxim Dorofienko]
* Convert specs to RSpec expect syntax with transpec (#194) [Logan Hasson]
* Remove binstubs options from defaults (#219) [lucapette]
* Updated deploy.rb template to use shared_path (#235) [postmodern]
* Allow the foreman export format to be configurable (#232) [postmodern]
* fix: bin/mina exit_status -> exitstatus (#212) [Zhomart Mukhamejanov]
* Add foreman_location and foreman_sudo configs (#239) [Pedro Chambino]
* Check db/migrate/ instead of schema.rb (#177) [Charles Dale]
* Fix mina deploy --help, should not cause a deploy (#238)
* Fix git:clone on win7 x64 had error (#216)
* Add deploy:cleanup after deploy
* Prevent foreman export from expanding the current/ symlink (#241)
* Support pretty_system on ruby 1.8.7 (#237)
* Ruby 1.8.7 doesn't support empty symbols (#240)


[Joshua Dover]: https://github.com/gerfuls
[Sam Qiu]: https://github.com/samqiu
[Alexander Borovsky]: https://github.com/borovsky
[Luis Lavena]: https://github.com/luislavena
[Pedro Chambino]: https://github.com/PChambino
[Luciano Sousa]: https://github.com/lucianosousa
[Jan Berdajs]: https://github.com/mrbrdo
[Qen]: https://github.com/qen
[Maxim Dorofienko]: https://github.com/mdorfin
[Logan Hasson]: https://github.com/loganhasson
[lucapette]: https://github.com/lucapette
[postmodern]: https://github.com/postmodern
[Zhomart Mukhamejanov]: https://github.com/Zhomart
[Charles Dale]: https://github.com/chuckd

v0.3.0 - July 10, 2013
----------------------

 * **Stdin is now being passed, thereby making git prompts work.**
 * Foreman: Add foreman support. (#71) [Dan Sosedoff]
 * Foreman: Fix 'command not found' error. (#89, #101)
 * Foreman: Fix forman stop. [Andrew Rosa]
 * Fix `mina setup` showing an error. (#64) [Anthony Hristov]
 * Fix "broken pipe" error after deploying. (#64) [Tomas Varneckas]
 * Fix error regarding "open4" in Windows environments. (#58)
 * Fix the default script's "touch tmp/restart.txt" to work for reliably. (#77) 
 [Eugene Diachkin]
 * Fix errors that happen when the host string is frozen. [sonots]
 * RVM: use 'rvm use --create'. (#81) [Marcos Beirigo]
 * RVM: Add 'rvm:wrapper' task to create wrappers. (#81) [Marcos Beirigo]
 * New helper method called 'capture' to capture SSH output. (#113) [Naoki 
  Ainoya]
 * Fix encoding errors. (#68) [Faud Saud]

Special thanks to all the contributors who made this release happen.

https://github.com/mina-deploy/mina/compare/v0.2.1...v0.3.0

[sonots]: https://github.com/sonots
[Tomas Varneckas]: https://github.com/tomasv
[Anthony Hristov]: https://github.com/muxcmux
[Dan Sosedoff]: https://github.com/sosedoff
[Eugene Diachkin]: https://github.com/ineu
[Marcos Beirigo]: https://github.com/marcosbeirigo
[Andrew Rosa]: https://github.com/andrewhr
[Naoki Ainoya]: https://github.com/saketoba
[Faud Saud]: https://github.com/faudsaud

v0.2.1 - Sep 08, 2012
---------------------

This release is to fix some issues that should've been cleaned up in the
previous release, but wasn't.

### Fixed:
  * **Fix SSH helpers giving a 'class required' error.**
  * **Send stdout even in term_mode = :pretty mode.**
  * Rbenv: Fix compatibility with Debian, Arch, Fedora. (#44)
  * Supress the "--depth is ignored in local clones" warning. (#56)

### Added:
  * Add the `:ssh_options` setting. (#23)
  * Add the `:forward_agent` setting. (#23)

### Changed:
  * Make the `:term_mode` setting accept strings, not just symbols. (eg: `set
    :term_mode, 'exec'`)

v0.2.0 - Sep 08, 2012
---------------------

This release had two pre releases:

  * v0.2.0.pre2 (Aug 2, 2012)
  * v0.1.3.pre1 (Jul 13, 2012)

### Fixed:
  * Allow changing `:term_mode` in the setup task. (#51, @alfuken)
  * Prevent `git log` from using a pager. (#42, @tmak)
  * `deploy:cleanup` can now be called in a deploy script. (#50, @dariocravero)
  * Don't invoke bash anymore (!), assume that bash is the shell for the user.
    Fixes Ubuntu 12, and many other things.
  * Fixed `ssh(cmd, return: true)` that used to exit. (#53 from @jpascal)
  * [pre2] Call ssh with no double use `-t` parameter.
  * [pre2] Fix Ruby 1.8 compatibility.
  * [pre2] Fix the "undefined method > for Process::Status" error.
  * [pre2] Using `force_migrate=1` and `force_assets=1` to `rails:db_migrate`
    and `rails:assets_precompile` now works well.
  * [pre1] Respect the `bundle_bin` setting when doing `bundle exec` in Rails commands. (#29)
  * [pre1] Doing `rails:assets_precompile` now properly skips asset compilation if not needed. (#25)

### Added:
  * __Added the 'queue!' helper.__
  * Add support for __Whenever__. (#47, @jpascal)
  * Add a new `:environment` task that gets loaded on setup/deploy.
  * __Add explicit support for rbenv/rvm.__ (#5, #39)
    * Implement :'rvm:use[...]'. (#5, #39)
    * Implement :'rbenv:load'. (#5, #39)
  * Revert `rails:optimize_for_3.2` from the pre2 release. (#32)
  * [pre2] __Optimize git:clone by caching the repository.__ This way, updates are
    faster because not the entire repo is cloned everytime. (#10)
  * [pre2] __Show elapsed time that a deploy takes.__
  * [pre2] __Display the git commit nicely when deploying.__
  * [pre2] __Force quit when 2 `^C`s are pressed.__
  * [pre2] New `die` helper.
  * [pre2] New `report_time` helper.
  * [pre2] New `to_directory` helper. (#35)
  * [pre2] Put optional optimizations for Rails 3.2 asset pipeline. (#32) -- reverted
  * Update sample deploy script:
    - [pre2] Update default deploy.rb to note :branch.
    - [pre2] Add `link_shared_paths` to the sample deploy script.
  * [pre1] Doing `rails:db_migrate` now skips doing migrations if they're not needed. (#18)
  * [pre1] Added the `mina console` command for Rails.
  * [pre1] Make asset paths configurable using the `asset_paths` setting.

### Changed:
  * Force removal of shared path destinations before linking with
    `deploy:link_shared_paths`. Fixes symlinking of `log/` in Rails projects.
  * __Rails: speed up default asset compilation a bit by invoking
    `assets:precompile` with `RAILS_GROUPS=assets`.__
  * Add helpful error message when there is a problem with
    deploy.rb or a custom Rakefile. (#37, @sge-jesse-adams)
  * Update the default deploy.rb to add notes about 'mina setup' customizations.
  * Make `mina run`, `mina rake`, `mina console` use the new `:environment` task.
  * Allow calling `die` without arguments.
  * [pre2] __Improve output of `mina init`.__
  * [pre2] Prettier output for `mina setup`. Also, show a better error message for it.
  * [pre1] Refactor pretty printing to be simpler, cleaner, and extensible.
  * [pre1] Show prettier abort messages when ^C'd.

v0.1.2 - Jul 06, 2012
---------------------

This release had two prereleases: v0.1.2.pre1 and v0.1.2.pre2.

### Fixed:
  * __Show stdout output properly on deploy.__
  * 'mina rake' now works.
  * [.pre2] __Fix `deploy:link_shared_paths` to use absolute paths.__
  * [.pre2] Fix console logs for task init.
  * [.pre1] __Fixed JRuby support.__
  * [.pre1] __Respect .bashrc.__ (#5)

### Added:
  * [.pre2] Add `:bundle_bin` option.
  * [.pre2] Add `:ssh` port option.

### Changed: (v0.1.2)
  * Refactor pretty printing to be simpler, cleaner, and extensible.
  * Show prettier abort messages when ^C'd.
  * Use the new error message format. (See lib/mina/output_helpers.rb)
  * [.pre1] Implement `ssh("..", return: true)`.
  * [.pre1] Rename `simulate_mode` to `simulate_mode?`. Same with `verbose_mode?`.
  * [.pre1] Show the SSH command in the simulation output.

v0.1.1 - Jun 07, 2012
---------------------

### Added:
  * Check for releases_path directory in deploy script.
  * mina deploy:cleanup
  * Support for -f option.

### Changed:
  * Gem description.

### Fixed:
  * deploy.rb template (domain, user, git:clone).
  * Handle empty Git repository.
  * Add pkg to gitignore.

v0.1.0 - Jun 06, 2012
---------------------

Renamed to Mina from Van Helsing.


v0.0.1.pre7 - Jun 06, 2012
--------------------------

### Added:
  * __`vh rails[command]` and `vh rake[command]` tasks.__
  * __Add `vh run`.__
  * `-S` as an alias for `--simulate`.
  * the `#set_default` helper.
  * the `bundle_prefix` setting.
  * New `term_mode` setting.

### Changed:
  * `--simulate` show things without the `ssh` command or shellescaping.

v0.0.1.pre6 - Jun 06, 2012
--------------------------

Thanks to @sosedoff for his contributions that made it to this release.

### Added:
  * __Rubinius support.__
  * __Ruby 1.8 support.__
  * Prelimenary JRuby support.
  * MIT license.
  * Highlight errors as red in deploy.
  * Use popen4 instead of popen3. Support JRuby via IO.popen4.

### Changed:
  * __Rename `to :restart` to `to :launch`.__
  * __Make deploys fail if renaming the build (eg, not setup properly) fails.__

### Tests:
  * Added `rake spec` (aliased as just `rake`) task. It tests with Rake 0.8 and 0.9 both.
  * Integrate with [Travis CI](http://travis-ci.org).
  * Make the SSH test more portable.
  * Removed `rake spec:verbose`.

v0.0.1.pre5 - Jun 05, 2012
--------------------------

### Added:
  * Add `--trace` to the `vh help` screen.
  * Rake 0.8 compatibility.
  * Ruby 1.8.7 compatibility.

### Changed:
  * Use `:domain` instead of `:host`.

### Misc:
  * Allow rake 0.8 testing using `rake=0.8 rspec`.
  * Add more README examples.

v0.0.1.pre4 - Jun 05, 2012
--------------------------

### Added:
  * `--simulate` switch.
  * `--verbose` switch.
  * The help screen now shows command line switches (like `--verbose`).
  * Build in `tmp/` instead of in `releases/`.
  * Use `verbose_mode` and `simulate_mode` instead. Using 'verbose' causes
    problems.
  * New `#deploy_script` helper, to make things more transparent.

### Misc:
  * Added a test for an actual deployment.
  * Make the `test_env` runnable even without a net connection.
  * New tests for actual deployment. Just do `rspec -t ssh`.
  * Cleanup `git:clone` code.
  * A buncha code cleanups.

v0.0.1.pre3 - Jun 04, 2012
--------------------------

### Added:
  * A help screen. You can see it with `vh --help`, `vh -h` or just plain `vh`.
  * Implemented `vh --version`.
  * Sequential release versions. Yay!
  * Added the `build_path` setting, which supercedes the now-removed `release_path`.

### Removed:
  * `release_path` has been deprecated.

### Fixed:
  * Stupid critical bug fix: fix `vh:setup` giving the world access to deploy_to.
  * Ensure that SSH stderr output is shown properly.
  * Make `#invoke` work with tasks with arguments (eg, :'site:scrape[ensogo]')

### Changed:
  * Edit the default deploy.rb to have a description for the deploy task.
  * Make `vh -T` show `vh` instead of `rake`.
  * Make `vh setup` ensure ownership of the `deploy_to` path.
  * Make deploy steps more explicit by echoing more statuses.
  * When deploys fail, you now don't see the default Ruby backtrace. It now
    behaves like Rake where you need to add `--trace` to see the trace.

### Misc:
  * Fixed the error that sometimes happens when invoking `vh` without a deploy.rb.
  * Update the sample deploy.rb file to be more readable.
  * The *test_env/* project can now be deployed without problems, so you can try
    things out.
  * Lots of new tests.
  * rspec test order is now randomized.
  * rspec output is colored (thanks to .rspec).
  * Better script indentation when running in simulation mode.
  * In symlinking `./current/`, use `ln -nfs` instead of `rm -f && ln -s`.

v0.0.1.pre2 - Jun 03, 2012
--------------------------

### Added:
  * Implement `vh init` which creates a sample *deploy.rb*.
  * Implement 'vh setup'.
  * Added the configurable `:releases_path` setting, so you may change where to keep releases.
  * Added documentation via Reacco.
  * Allow settings to throw errors on missing settings by adding a bang (e.g.,
    `bundle_path!` or `settings.bundle_path!`)

### Changed:
  * Allow `bundle:install` to skip having shared bundle paths if `:bundle_path` is set to nil.
  * Rename `force_unlock` to `deploy:force_unlock`.
  * Rename `vh:link_shared_paths` to `deploy:link_shared_paths`.
  * Invoking `deploy:force_unlock` now shows the command it uses.

### Fixed:
  * The `bundle:install` task now honors the `bundle_path` setting.
  * Fixed `deploy:force_unlock` always throwing an error.
  * The `deploy:force_unlock` task now honors the `lock_file`
    setting, so the user may change the location of the lock file.
  * Fixed `rails:assets_precompile` not compiling if no older assets found.

### Removed:
  * Deprecate `#validate_set`.

### Other things:
  * Move deploy settings to deploy.rb.
  * Rename the `default` addon to `deploy`.

v0.0.1.pre1 - Jun 02, 2012
--------------------------

Initial version.
