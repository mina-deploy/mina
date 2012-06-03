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
  * Stupid critical bug fix: fix 'vh:setup' giving the world access to deploy_to.
  * Ensure that SSH stderr output is shown properly.
  * Make #invoke work with tasks with arguments (eg, :'site:scrape[ensogo]')

### Changed:
  * Edit the default deploy.rb to have a description for the deploy task.
  * Make 'vh -T' show 'vh' instead of 'rake'.
  * Make 'vh setup' ensure ownership of the deploy_to path.
  * Make deploy steps more explicit by echoing more statuses.
  * When deploys fail, you now don't see the default Ruby backtrace. It now
    behaves like Rake where you need to add --trace to see the trace.

### Misc:
  * Fixed the error that sometimes happens when invoking 'vh' without a deploy.rb.
  * Update the sample deploy.rb file to be more readable.
  * The test_env/ project can now be deployed without problems, so you can try things out.
  * Lots of new tests.
  * rspec test order is now randomized.
  * rspec output is colored (thanks to .rspec).
  * Better script indentation when running in simulation mode.
  * In symlinking ./current/, use ln -nfs instead of rm -f && ln -s.

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
  * Rename the 'default' addon to 'deploy'.

v0.0.1.pre1 - Jun 02, 2012
--------------------------

Initial version.
