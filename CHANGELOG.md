# Change Log

## [v1.2.3](https://github.com/mina-deploy/mina/tree/v1.2.3) (2017-11-22)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.2.2...v1.2.3)

**Closed issues:**

- Task :environment not valid any longer [\#583](https://github.com/mina-deploy/mina/issues/583)

**Merged pull requests:**

- Fix empty stage queue [\#592](https://github.com/mina-deploy/mina/pull/592) ([Narayanan170](https://github.com/Narayanan170))
- fix typo [\#584](https://github.com/mina-deploy/mina/pull/584) ([MatzFan](https://github.com/MatzFan))

## [v1.2.2](https://github.com/mina-deploy/mina/tree/v1.2.2) (2017-10-13)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.2.1...v1.2.2)

**Implemented enhancements:**

- Add shared folders validations [\#559](https://github.com/mina-deploy/mina/issues/559)

**Fixed bugs:**

- Add shared folders validations [\#559](https://github.com/mina-deploy/mina/issues/559)

**Closed issues:**

- prepend environments when run outside run block [\#576](https://github.com/mina-deploy/mina/issues/576)
- rails:assets\_precompile from cache [\#494](https://github.com/mina-deploy/mina/issues/494)

**Merged pull requests:**

- Remove spec for now, unitl \#579 [\#580](https://github.com/mina-deploy/mina/pull/580) ([d4be4st](https://github.com/d4be4st))
- Add folder validation for symlinking [\#578](https://github.com/mina-deploy/mina/pull/578) ([d4be4st](https://github.com/d4be4st))
- Resolves \#576 [\#577](https://github.com/mina-deploy/mina/pull/577) ([d4be4st](https://github.com/d4be4st))
- Remote environment in deploy example [\#573](https://github.com/mina-deploy/mina/pull/573) ([ozgg](https://github.com/ozgg))

## [v1.2.1](https://github.com/mina-deploy/mina/tree/v1.2.1) (2017-10-02)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.2.0...v1.2.1)

**Closed issues:**

- Deploy does not work since version 1.2.0 [\#572](https://github.com/mina-deploy/mina/issues/572)

## [v1.2.0](https://github.com/mina-deploy/mina/tree/v1.2.0) (2017-09-29)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.1.1...v1.2.0)

**Fixed bugs:**

- Fix keyscan\_domain task [\#570](https://github.com/mina-deploy/mina/issues/570)

## [v1.1.1](https://github.com/mina-deploy/mina/tree/v1.1.1) (2017-09-29)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.1.0...v1.1.1)

## [v1.1.0](https://github.com/mina-deploy/mina/tree/v1.1.0) (2017-09-29)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.0.7...v1.1.0)

**Implemented enhancements:**

- Separate environment to local and backend environment tasks [\#569](https://github.com/mina-deploy/mina/issues/569)
- Add warning when using rails:\* tasks [\#567](https://github.com/mina-deploy/mina/issues/567)
- Provide --no-report-time [\#540](https://github.com/mina-deploy/mina/issues/540)

**Fixed bugs:**

- disable running `run` blocks inside another `run` block [\#565](https://github.com/mina-deploy/mina/issues/565)

**Closed issues:**

- rails:assets\_precompile not working although working locally or via SSH [\#566](https://github.com/mina-deploy/mina/issues/566)
- py-mina [\#564](https://github.com/mina-deploy/mina/issues/564)
- Is it possible to deploy static websites with mina ? [\#562](https://github.com/mina-deploy/mina/issues/562)
- Add directory structure doc [\#558](https://github.com/mina-deploy/mina/issues/558)
- Update command line options docs [\#557](https://github.com/mina-deploy/mina/issues/557)
- How Mina work? [\#546](https://github.com/mina-deploy/mina/issues/546)
- Log of mina deploy command [\#529](https://github.com/mina-deploy/mina/issues/529)
- Fix 'No Rakefile found' for rails:{db\_create, db\_migrate, db\_rollback, assetts\_precompile} commands [\#524](https://github.com/mina-deploy/mina/issues/524)
- The old "force\_assets=1" option is mentioned on the "rails:assets\_precompile" doc webpage rather than the new "force\_asset\_precompile=true" one [\#520](https://github.com/mina-deploy/mina/issues/520)
- Skipping assets:precompile doesn't copy assets folder to new current\_path [\#518](https://github.com/mina-deploy/mina/issues/518)
- `remote` command doesn't find my executable \(after upgrade from 0.3 to 1.0\) [\#513](https://github.com/mina-deploy/mina/issues/513)
- Add hint about creating `shared/database.yml` in README [\#503](https://github.com/mina-deploy/mina/issues/503)
- Provide meaningful default shared folders [\#501](https://github.com/mina-deploy/mina/issues/501)
- Managing environment variables file application.yml  [\#497](https://github.com/mina-deploy/mina/issues/497)
- mina setup or mina init, don't know how to build task [\#488](https://github.com/mina-deploy/mina/issues/488)

**Merged pull requests:**

- added a recipe for deploying static websites [\#563](https://github.com/mina-deploy/mina/pull/563) ([alexwebgr](https://github.com/alexwebgr))
- Fix typo: space between "\]" and "\(" [\#561](https://github.com/mina-deploy/mina/pull/561) ([lorenzosinisi](https://github.com/lorenzosinisi))
- Fixed typo [\#560](https://github.com/mina-deploy/mina/pull/560) ([pborreli](https://github.com/pborreli))
- Add skip-existing option to example rbenv install [\#527](https://github.com/mina-deploy/mina/pull/527) ([sunny](https://github.com/sunny))

## [v1.0.7](https://github.com/mina-deploy/mina/tree/v1.0.7) (2017-09-08)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.0.6...v1.0.7)

**Closed issues:**

- Set command in task to use at another task [\#556](https://github.com/mina-deploy/mina/issues/556)
- rvm:use not working in Mina 1.0.6 [\#555](https://github.com/mina-deploy/mina/issues/555)
- Why mina default link shared directory to public/assets? [\#550](https://github.com/mina-deploy/mina/issues/550)
- bash: line 50: cd: /home/deploy/app/current: No such file or directory [\#549](https://github.com/mina-deploy/mina/issues/549)
- Is the project dead? [\#541](https://github.com/mina-deploy/mina/issues/541)
- I am simply trying to restart my nginx server [\#539](https://github.com/mina-deploy/mina/issues/539)
- why mina setup  new a file use makdir -p  [\#538](https://github.com/mina-deploy/mina/issues/538)
- Don't know how to build task 'rake:db\_migrate' [\#536](https://github.com/mina-deploy/mina/issues/536)
- Could not install to path `vendor/bundle` because of an invalid symlink [\#535](https://github.com/mina-deploy/mina/issues/535)
- Failed with status 1 [\#530](https://github.com/mina-deploy/mina/issues/530)
- bash: bundle: command not found [\#528](https://github.com/mina-deploy/mina/issues/528)
- NoMethodError: undefined method `to' for main:Object [\#522](https://github.com/mina-deploy/mina/issues/522)
- Add rake after\_party:run [\#517](https://github.com/mina-deploy/mina/issues/517)
- Rails doesn't recognize my project [\#514](https://github.com/mina-deploy/mina/issues/514)
-  Install nginx as module [\#512](https://github.com/mina-deploy/mina/issues/512)
- Mina console 'bash: bundle: command not found' [\#510](https://github.com/mina-deploy/mina/issues/510)
- Execution mode / Don't know how to build task [\#508](https://github.com/mina-deploy/mina/issues/508)
- Mina setup and migrations: Files /home/base/rails/current/db/migrate/xxx.rb and ./db/migrate/xxx.rb differ [\#502](https://github.com/mina-deploy/mina/issues/502)
- mina 1.0.6 problem on migration  [\#499](https://github.com/mina-deploy/mina/issues/499)
- mina 1.0.6  Identity file [\#498](https://github.com/mina-deploy/mina/issues/498)
- Integrate puma and its configuration as default in mina [\#493](https://github.com/mina-deploy/mina/issues/493)

**Merged pull requests:**

- Allow use of Minafile or deploy.rb outside of config directory [\#554](https://github.com/mina-deploy/mina/pull/554) ([coreyworrell](https://github.com/coreyworrell))
- rails commands - assets:clean and schema:load  [\#545](https://github.com/mina-deploy/mina/pull/545) ([coderhs](https://github.com/coderhs))
- DOCS: Adds mina-supervisord [\#543](https://github.com/mina-deploy/mina/pull/543) ([hovancik](https://github.com/hovancik))
- Fix chruby invocation example [\#532](https://github.com/mina-deploy/mina/pull/532) ([aptinio](https://github.com/aptinio))
- Documentation: Migrating shared paths example [\#526](https://github.com/mina-deploy/mina/pull/526) ([sunny](https://github.com/sunny))
- Update 3rd\_party\_plugins.md [\#509](https://github.com/mina-deploy/mina/pull/509) ([lorenzosinisi](https://github.com/lorenzosinisi))
- Add mina-hanami [\#495](https://github.com/mina-deploy/mina/pull/495) ([mgrachev](https://github.com/mgrachev))

## [v1.0.6](https://github.com/mina-deploy/mina/tree/v1.0.6) (2016-12-15)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.0.5...v1.0.6)

## [v1.0.5](https://github.com/mina-deploy/mina/tree/v1.0.5) (2016-12-15)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.0.4...v1.0.5)

## [v1.0.4](https://github.com/mina-deploy/mina/tree/v1.0.4) (2016-12-15)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.0.3...v1.0.4)

**Implemented enhancements:**

- Add application\_name [\#480](https://github.com/mina-deploy/mina/issues/480)

**Fixed bugs:**

- Mina 1.0.2+ error "bash: bundle: command not found" when using `mina console` [\#476](https://github.com/mina-deploy/mina/issues/476)

**Closed issues:**

- mkdir: cannot create directory ‘config’: File exists [\#491](https://github.com/mina-deploy/mina/issues/491)
- Mina fails to deploy release folders [\#490](https://github.com/mina-deploy/mina/issues/490)
- run :local deletes local files and directories [\#489](https://github.com/mina-deploy/mina/issues/489)
- Test ticket from Code Climate [\#486](https://github.com/mina-deploy/mina/issues/486)
- Can't get SSH agent forwarding to work [\#484](https://github.com/mina-deploy/mina/issues/484)
- undefined local variable or method current\_path [\#483](https://github.com/mina-deploy/mina/issues/483)
- Rails console is not interactive [\#482](https://github.com/mina-deploy/mina/issues/482)
- WordPress current symlink [\#481](https://github.com/mina-deploy/mina/issues/481)
- mina deploy [\#479](https://github.com/mina-deploy/mina/issues/479)
- Issue when change the directory before git:clone [\#477](https://github.com/mina-deploy/mina/issues/477)
- NameError: undefined local variable or method `deploy\_to' for main:Object [\#475](https://github.com/mina-deploy/mina/issues/475)
- Requiring ruby 2+ from version 1 [\#474](https://github.com/mina-deploy/mina/issues/474)

**Merged pull requests:**

- mina-systemd [\#487](https://github.com/mina-deploy/mina/pull/487) ([stereodenis](https://github.com/stereodenis))
- fix ruby syntax in deploy.rb comment [\#485](https://github.com/mina-deploy/mina/pull/485) ([kuboon](https://github.com/kuboon))
- Restore previous path after in\_path block [\#478](https://github.com/mina-deploy/mina/pull/478) ([sobrinho](https://github.com/sobrinho))

## [v1.0.3](https://github.com/mina-deploy/mina/tree/v1.0.3) (2016-11-08)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.0.2...v1.0.3)

**Closed issues:**

- Less obscure behaviour while copying the assets [\#473](https://github.com/mina-deploy/mina/issues/473)
- Set variables via command line is not captured in method set? [\#470](https://github.com/mina-deploy/mina/issues/470)
- Shared paths can not take effect [\#469](https://github.com/mina-deploy/mina/issues/469)
- Fall back to last commit on fail [\#466](https://github.com/mina-deploy/mina/issues/466)
- How can I append options to "rake db:migrate"? [\#464](https://github.com/mina-deploy/mina/issues/464)
- Mina fails on git clone [\#461](https://github.com/mina-deploy/mina/issues/461)
- How to prevent delete uploaded images\(by paperclip\) when depoly? [\#460](https://github.com/mina-deploy/mina/issues/460)
- Changing git host [\#458](https://github.com/mina-deploy/mina/issues/458)
- Get deploy error [\#431](https://github.com/mina-deploy/mina/issues/431)

**Merged pull requests:**

- Configuration\#set?\(key\) also checks ENV [\#471](https://github.com/mina-deploy/mina/pull/471) ([Zhomart](https://github.com/Zhomart))
- Add a note about new invoke syntax [\#465](https://github.com/mina-deploy/mina/pull/465) ([scarfacedeb](https://github.com/scarfacedeb))
- fix mina deploy link [\#463](https://github.com/mina-deploy/mina/pull/463) ([hendricius](https://github.com/hendricius))
- Show lock file modify time [\#459](https://github.com/mina-deploy/mina/pull/459) ([SG5](https://github.com/SG5))
- corrected typo [\#457](https://github.com/mina-deploy/mina/pull/457) ([janhoffmann](https://github.com/janhoffmann))
- Improved shared\_dirs example + Fix typo in deploy.rb [\#456](https://github.com/mina-deploy/mina/pull/456) ([ralfebert](https://github.com/ralfebert))
- Allow to overwrite existing :shared\_files with the symlink to shared \(fixes \#452\) [\#455](https://github.com/mina-deploy/mina/pull/455) ([ralfebert](https://github.com/ralfebert))

## [v1.0.2](https://github.com/mina-deploy/mina/tree/v1.0.2) (2016-10-12)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.0.0...v1.0.2)

**Fixed bugs:**

- mina 1.0.0 and local repository [\#443](https://github.com/mina-deploy/mina/issues/443)

**Closed issues:**

- Undefined method 'to'  for main:Object [\#454](https://github.com/mina-deploy/mina/issues/454)
- rvm:use not working as intended [\#453](https://github.com/mina-deploy/mina/issues/453)
- failed to create symbolic link ‘./config/database.yml’: File exists [\#452](https://github.com/mina-deploy/mina/issues/452)
- going back to 0.3.8 [\#451](https://github.com/mina-deploy/mina/issues/451)
- Prompts Are not displayed - or displayed after killing process [\#449](https://github.com/mina-deploy/mina/issues/449)
- deploy:link\_shared\_paths Fails！   Too many levels of symbolic links [\#448](https://github.com/mina-deploy/mina/issues/448)
- Mina not loading prompt to ask for Git password [\#446](https://github.com/mina-deploy/mina/issues/446)
- Mina::Error: Setting :shared\_paths is not set [\#445](https://github.com/mina-deploy/mina/issues/445)
- rvm:use doesn't actually switch rubies. [\#442](https://github.com/mina-deploy/mina/issues/442)
- Problem deploying since commit d547ea10 [\#439](https://github.com/mina-deploy/mina/issues/439)

**Merged pull requests:**

- Fix FAQ doc typo [\#447](https://github.com/mina-deploy/mina/pull/447) ([gabskoro](https://github.com/gabskoro))
- Fix rvm:use task [\#444](https://github.com/mina-deploy/mina/pull/444) ([devvmh](https://github.com/devvmh))

## [v1.0.0](https://github.com/mina-deploy/mina/tree/v1.0.0) (2016-09-27)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.0.0.rc2...v1.0.0)

**Closed issues:**

- No cache for bundler [\#441](https://github.com/mina-deploy/mina/issues/441)
- Support for nvm [\#440](https://github.com/mina-deploy/mina/issues/440)

## [v1.0.0.rc2](https://github.com/mina-deploy/mina/tree/v1.0.0.rc2) (2016-09-19)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.0.0.rc1...v1.0.0.rc2)

## [v1.0.0.rc1](https://github.com/mina-deploy/mina/tree/v1.0.0.rc1) (2016-09-19)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.0.0.beta5...v1.0.0.rc1)

**Implemented enhancements:**

- Change output precompiling asset color [\#434](https://github.com/mina-deploy/mina/issues/434)

**Fixed bugs:**

- open4 error if run :local do block does not contain any commands [\#424](https://github.com/mina-deploy/mina/issues/424)
- can't set rvm\_path in 1.x [\#414](https://github.com/mina-deploy/mina/issues/414)

**Closed issues:**

- Default tasks? [\#436](https://github.com/mina-deploy/mina/issues/436)
- Can't open rails console when doing ssh through mina [\#435](https://github.com/mina-deploy/mina/issues/435)
- Restart doesn't work [\#432](https://github.com/mina-deploy/mina/issues/432)
- mina 1.0 not picking up rvm [\#430](https://github.com/mina-deploy/mina/issues/430)
- run `mina deploy` failed,because of activesupport [\#429](https://github.com/mina-deploy/mina/issues/429)
- Cant 'mina setup' but can 'mina ssh' [\#423](https://github.com/mina-deploy/mina/issues/423)

**Merged pull requests:**

- rvm\_path replace with rvm\_use\_path [\#438](https://github.com/mina-deploy/mina/pull/438) ([devvmh](https://github.com/devvmh))
- fix mina rake bug [\#428](https://github.com/mina-deploy/mina/pull/428) ([devvmh](https://github.com/devvmh))
- strip whitespace from commands by default [\#427](https://github.com/mina-deploy/mina/pull/427) ([devvmh](https://github.com/devvmh))

## [v1.0.0.beta5](https://github.com/mina-deploy/mina/tree/v1.0.0.beta5) (2016-08-30)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.0.0.beta4...v1.0.0.beta5)

**Closed issues:**

- How to do a proper finish hook? [\#425](https://github.com/mina-deploy/mina/issues/425)

## [v1.0.0.beta4](https://github.com/mina-deploy/mina/tree/v1.0.0.beta4) (2016-08-28)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.0.0.beta3...v1.0.0.beta4)

## [v1.0.0.beta3](https://github.com/mina-deploy/mina/tree/v1.0.0.beta3) (2016-08-28)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.0.0.beta2...v1.0.0.beta3)

**Implemented enhancements:**

- Spring cleaning [\#380](https://github.com/mina-deploy/mina/issues/380)
- Git helper for pending push [\#295](https://github.com/mina-deploy/mina/issues/295)

**Closed issues:**

- No error when  Host key verification failed. [\#422](https://github.com/mina-deploy/mina/issues/422)
- Broken link in documentation [\#421](https://github.com/mina-deploy/mina/issues/421)
- Mina beta2 bugs with mina-unicorn [\#420](https://github.com/mina-deploy/mina/issues/420)
- How do I prevent mina from removing images uploaded on production server? [\#419](https://github.com/mina-deploy/mina/issues/419)
- rbenv support is broken on 1.x [\#418](https://github.com/mina-deploy/mina/issues/418)
- Mina doesn't enclose commands in parenthesis. [\#417](https://github.com/mina-deploy/mina/issues/417)
- Undefined method queue with mina v1.0.0-beta2 [\#408](https://github.com/mina-deploy/mina/issues/408)
- mina init error message in 1.0.0.beta2 [\#407](https://github.com/mina-deploy/mina/issues/407)

**Merged pull requests:**

- change docs about invoking rvm:use with arguments [\#413](https://github.com/mina-deploy/mina/pull/413) ([devvmh](https://github.com/devvmh))
- add Rbenv and RVM notes [\#412](https://github.com/mina-deploy/mina/pull/412) ([pinewong](https://github.com/pinewong))
- fix issues with rbenv:load [\#411](https://github.com/mina-deploy/mina/pull/411) ([devvmh](https://github.com/devvmh))
- ensure git pushed function - code props to @fgarcia [\#410](https://github.com/mina-deploy/mina/pull/410) ([devvmh](https://github.com/devvmh))
- fix infinite loop in suggested default config [\#409](https://github.com/mina-deploy/mina/pull/409) ([devvmh](https://github.com/devvmh))

## [v1.0.0.beta2](https://github.com/mina-deploy/mina/tree/v1.0.0.beta2) (2016-07-30)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v1.0.0.beta1...v1.0.0.beta2)

**Implemented enhancements:**

- Add support for tagging releases [\#326](https://github.com/mina-deploy/mina/issues/326)
- automatically use local rvm version [\#182](https://github.com/mina-deploy/mina/issues/182)
- Help wanted: Windows mingw32 shell \(git bash\) - CRLF [\#83](https://github.com/mina-deploy/mina/issues/83)

**Fixed bugs:**

- Whenever override crontab config when multiple applications be deployed to one domain [\#305](https://github.com/mina-deploy/mina/issues/305)
- Queue echo command with long string causes output error [\#299](https://github.com/mina-deploy/mina/issues/299)
- Mina not working on windows [\#169](https://github.com/mina-deploy/mina/issues/169)

**Closed issues:**

- 1.0.0.beta1 requires 'pry' but it's a development dependency [\#405](https://github.com/mina-deploy/mina/issues/405)
- LoadError: cannot load such file -- mina/bundler [\#404](https://github.com/mina-deploy/mina/issues/404)
- Code not Deploying Sometimes [\#403](https://github.com/mina-deploy/mina/issues/403)
- Losing the public/uploads directory after deploy [\#402](https://github.com/mina-deploy/mina/issues/402)
- Rollback to specific version [\#401](https://github.com/mina-deploy/mina/issues/401)
- Deploy Sinatra and Puma \(w/ mina-puma\) [\#400](https://github.com/mina-deploy/mina/issues/400)
- rbenv/mina Permission denied @ rb\_sysopen - /etc/init/app.conf \(Errno::EACCES\) [\#399](https://github.com/mina-deploy/mina/issues/399)
- sudo: bundle: command not found [\#397](https://github.com/mina-deploy/mina/issues/397)
- Incompatibility with zsh? [\#395](https://github.com/mina-deploy/mina/issues/395)
- More intelligent asset precompilation [\#394](https://github.com/mina-deploy/mina/issues/394)
- Unaccessible variable [\#385](https://github.com/mina-deploy/mina/issues/385)
- /bin/bash: Argument list too long [\#383](https://github.com/mina-deploy/mina/issues/383)
- Mina doesnt report elapsed time after a run \(Windows\) [\#381](https://github.com/mina-deploy/mina/issues/381)
- Is there a good way to tag deployed git sha with the current release version? [\#378](https://github.com/mina-deploy/mina/issues/378)
- How to invoke the script as bash even the default shell on server is fishshell? [\#374](https://github.com/mina-deploy/mina/issues/374)
- Mina Operation timed out 65280 [\#373](https://github.com/mina-deploy/mina/issues/373)
- Failed with status 1 \(4864\) since version 0.3.7 [\#370](https://github.com/mina-deploy/mina/issues/370)
- Asset precompilation when changes only occur in included gems [\#369](https://github.com/mina-deploy/mina/issues/369)
- Error running on Ruby 2.3.0 [\#368](https://github.com/mina-deploy/mina/issues/368)
- sed: RE error: repetition-operator operand invalid [\#367](https://github.com/mina-deploy/mina/issues/367)
- echoing to a file ends up with the content of the file indented by 2 spaces [\#366](https://github.com/mina-deploy/mina/issues/366)
- Mina isn't compatible with non POSIX shells [\#363](https://github.com/mina-deploy/mina/issues/363)
- Unicorn server will not restart [\#358](https://github.com/mina-deploy/mina/issues/358)
- Revert "force ssh fingerprints adding to known\_hosts" [\#356](https://github.com/mina-deploy/mina/issues/356)
- git command on server is /usr/local/cpanel/3rdparty/bin/git [\#355](https://github.com/mina-deploy/mina/issues/355)
- release\_path error deploy faild [\#346](https://github.com/mina-deploy/mina/issues/346)
- NoMethodError: undefined method `fetch' for false:FalseClass [\#341](https://github.com/mina-deploy/mina/issues/341)
- Failed on skipping asset precompilation \(after PR \#266\) [\#339](https://github.com/mina-deploy/mina/issues/339)
- Allow for files/folders to be excluded from deployments [\#337](https://github.com/mina-deploy/mina/issues/337)
- Unicorn searching gems in outdated releases [\#336](https://github.com/mina-deploy/mina/issues/336)
- How to change releases directory names from auto increment value to datetime? [\#332](https://github.com/mina-deploy/mina/issues/332)
- Port knocking [\#324](https://github.com/mina-deploy/mina/issues/324)
- Where to properly invoke rails:db\_migrate? [\#323](https://github.com/mina-deploy/mina/issues/323)
- command not found bundle [\#320](https://github.com/mina-deploy/mina/issues/320)
- install: unrecognized option '--without' [\#318](https://github.com/mina-deploy/mina/issues/318)
- mina:deploy runs tasks twice for some reason [\#316](https://github.com/mina-deploy/mina/issues/316)
- assets\_precompile will skip when i use  js.erb [\#314](https://github.com/mina-deploy/mina/issues/314)
- ails:assets\_precompile never skips precompilation [\#312](https://github.com/mina-deploy/mina/issues/312)
- Whenever tasks use old release in readme example [\#304](https://github.com/mina-deploy/mina/issues/304)
- Output twice [\#301](https://github.com/mina-deploy/mina/issues/301)
- rvm:use without environment parameter [\#297](https://github.com/mina-deploy/mina/issues/297)
- Pretty printing duplicates lines [\#276](https://github.com/mina-deploy/mina/issues/276)
- sudo for foreman [\#243](https://github.com/mina-deploy/mina/issues/243)
- Queue commands in different buckets using sub-tasks [\#228](https://github.com/mina-deploy/mina/issues/228)
- Foreman rbenv sudo problem and upstart script which point to tmp dir [\#207](https://github.com/mina-deploy/mina/issues/207)
- Foreman is creating the init scripts with the previous release [\#185](https://github.com/mina-deploy/mina/issues/185)
- Inaccurate documentation copy? [\#167](https://github.com/mina-deploy/mina/issues/167)
- Use of method\_missing doesn't raise NameError for non-existent variables [\#138](https://github.com/mina-deploy/mina/issues/138)
- Update documentation about :revision being deprecated [\#119](https://github.com/mina-deploy/mina/issues/119)
- Rethink documentation [\#76](https://github.com/mina-deploy/mina/issues/76)
- Deploy to multiple boxes simultaneously [\#8](https://github.com/mina-deploy/mina/issues/8)

**Merged pull requests:**

- Feature/configuration dsl [\#398](https://github.com/mina-deploy/mina/pull/398) ([vr4b4c](https://github.com/vr4b4c))

## [v1.0.0.beta1](https://github.com/mina-deploy/mina/tree/v1.0.0.beta1) (2016-06-30)
[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.3.8...v1.0.0.beta1)

**Closed issues:**

- foreman stop mina create current folder issue [\#396](https://github.com/mina-deploy/mina/issues/396)
- Host key verification failed [\#391](https://github.com/mina-deploy/mina/issues/391)
- mina deploy error  Cloning into '.'... [\#390](https://github.com/mina-deploy/mina/issues/390)
- Shared paths does not get updates after deploy [\#388](https://github.com/mina-deploy/mina/issues/388)
- Deploy Error: Ruby Version Not Installed [\#387](https://github.com/mina-deploy/mina/issues/387)
- Repository not found, Multiple github deploy keys for a single user on a single server [\#382](https://github.com/mina-deploy/mina/issues/382)
- RVM not found [\#379](https://github.com/mina-deploy/mina/issues/379)
- Too many \('s with FREEBSD [\#375](https://github.com/mina-deploy/mina/issues/375)

**Merged pull requests:**

- Fix syntax [\#372](https://github.com/mina-deploy/mina/pull/372) ([KamilLelonek](https://github.com/KamilLelonek))
- Update Readme.md [\#371](https://github.com/mina-deploy/mina/pull/371) ([amoludage](https://github.com/amoludage))
- update contrib guide [\#364](https://github.com/mina-deploy/mina/pull/364) ([jsimpson](https://github.com/jsimpson))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*