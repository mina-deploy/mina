# Change Log

## [v0.3.8](https://github.com/mina-deploy/mina/tree/v0.3.8) (2016-01-04)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.3.7...v0.3.8)

**Merged pull requests:**

- Fixed bug where domain was not set yet when whenever_name was being called (set_default) causing multiple crontab entries [\#335](https://github.com/mina-deploy/mina/pull/335)

- Fix missing shell repo variable in setup [\#329](https://github.com/mina-deploy/mina/pull/329)

- Add license to gemspec [\#343](https://github.com/mina-deploy/mina/pull/343)

- Fix for starting server path [\#349](https://github.com/mina-deploy/mina/pull/349)

- Add mina-laravel to 3rd party modules [\#352](https://github.com/mina-deploy/mina/pull/352)


## [v0.3.7](https://github.com/mina-deploy/mina/tree/v0.3.7) (2015-07-08)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.3.6...v0.3.7)

**Closed issues:**

- New setup project cannot deploy, "Failed with status 1 \(1\)" [\#328](https://github.com/mina-deploy/mina/issues/328)

- How to do mina rake task invocation if rake task has arguments? [\#325](https://github.com/mina-deploy/mina/issues/325)

- Git commit is lost after checkout [\#308](https://github.com/mina-deploy/mina/issues/308)

- Trust foreman binary [\#144](https://github.com/mina-deploy/mina/issues/144)

## [v0.3.6](https://github.com/mina-deploy/mina/tree/v0.3.6) (2015-07-05)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.3.4...v0.3.6)

**Closed issues:**

- master failed to start, check stderr log for details [\#322](https://github.com/mina-deploy/mina/issues/322)

- can not connect to VPS [\#319](https://github.com/mina-deploy/mina/issues/319)

- Integrate with sitemap generator. [\#313](https://github.com/mina-deploy/mina/issues/313)

- Mina ssh doesn't load bash\_profile? [\#311](https://github.com/mina-deploy/mina/issues/311)

- Mina::LocalHelpers::Local.invoke is broken for non-pretty term modes [\#309](https://github.com/mina-deploy/mina/issues/309)

- sudo command in configuration [\#302](https://github.com/mina-deploy/mina/issues/302)

- Why does rails:db\_migrate run on the previous release? [\#300](https://github.com/mina-deploy/mina/issues/300)

- secrets.yml in shared\_paths by default [\#298](https://github.com/mina-deploy/mina/issues/298)

- mina don't support deployment by tag [\#296](https://github.com/mina-deploy/mina/issues/296)

- when Skipping asset precompilation, it copied assets to wrong path [\#293](https://github.com/mina-deploy/mina/issues/293)

- Mina chokes handling STDIN [\#286](https://github.com/mina-deploy/mina/issues/286)

- invoke does not work after a to block [\#285](https://github.com/mina-deploy/mina/issues/285)

- Deploy locked without deploy.lock file [\#283](https://github.com/mina-deploy/mina/issues/283)

- mina setup improperly documented [\#280](https://github.com/mina-deploy/mina/issues/280)

- Hangs on confirming host key phase. [\#277](https://github.com/mina-deploy/mina/issues/277)

- Whenever tasks do not dependent :environment [\#267](https://github.com/mina-deploy/mina/issues/267)

- Can I safely embed `.env` in the Mina deploy script? [\#265](https://github.com/mina-deploy/mina/issues/265)

- to :launch ... [\#261](https://github.com/mina-deploy/mina/issues/261)

- Mina - Foreman - Bundle problem [\#257](https://github.com/mina-deploy/mina/issues/257)

- :preapre stage to happen before creating a new temp build [\#256](https://github.com/mina-deploy/mina/issues/256)

- How can i deploy thinking\_sphinx [\#250](https://github.com/mina-deploy/mina/issues/250)

- logfile on server? [\#242](https://github.com/mina-deploy/mina/issues/242)

- Starting a resque worker [\#223](https://github.com/mina-deploy/mina/issues/223)

- Multiple Server Support / Timestamp Release Support [\#217](https://github.com/mina-deploy/mina/issues/217)

- Installing gems on JRuby [\#211](https://github.com/mina-deploy/mina/issues/211)

- Deploy fails with 'cannot create directory' [\#205](https://github.com/mina-deploy/mina/issues/205)

- Checkout to HEAD? [\#203](https://github.com/mina-deploy/mina/issues/203)

- Alter the setup task [\#202](https://github.com/mina-deploy/mina/issues/202)

- "invoke :task, reenable: true" doesn't work in certain configurations [\#201](https://github.com/mina-deploy/mina/issues/201)

- Simple `mina git:clone` fails on step "Using git branch 'master'" [\#200](https://github.com/mina-deploy/mina/issues/200)

- ssh command assumes the user's shell on the server is bashish [\#199](https://github.com/mina-deploy/mina/issues/199)

- Mina support mercurial? [\#192](https://github.com/mina-deploy/mina/issues/192)

- git clone '.' path already exists [\#190](https://github.com/mina-deploy/mina/issues/190)

- mina deploy error [\#187](https://github.com/mina-deploy/mina/issues/187)

- current\_path up one directory breaks current symlink [\#180](https://github.com/mina-deploy/mina/issues/180)

- Why don't you also read the `.bash\_profile`? [\#176](https://github.com/mina-deploy/mina/issues/176)

- deploy\_to does not expand path [\#174](https://github.com/mina-deploy/mina/issues/174)

- shared bundle path not symlinked [\#156](https://github.com/mina-deploy/mina/issues/156)

- How to select project folder under git control [\#155](https://github.com/mina-deploy/mina/issues/155)

- Add support for ssh proxies [\#151](https://github.com/mina-deploy/mina/issues/151)

- Broken JRuby support [\#147](https://github.com/mina-deploy/mina/issues/147)

- Changes of assets under lib/assets does not trigger assets\_precompile  [\#143](https://github.com/mina-deploy/mina/issues/143)

- can't convert Fixnum into String [\#142](https://github.com/mina-deploy/mina/issues/142)

- mina console with dvm [\#141](https://github.com/mina-deploy/mina/issues/141)

- Enable wiki to list plugins/gems [\#140](https://github.com/mina-deploy/mina/issues/140)

- rvm is sourced, which just prints the help message [\#131](https://github.com/mina-deploy/mina/issues/131)

- When config.assets.prefix was setting, the assets was precompiled every deploy [\#125](https://github.com/mina-deploy/mina/issues/125)

- rvm\_path setting not picking up [\#124](https://github.com/mina-deploy/mina/issues/124)

- Whenever support: fix 'bundle exec' [\#114](https://github.com/mina-deploy/mina/issues/114)

- Why my rvm gemset is empty? [\#108](https://github.com/mina-deploy/mina/issues/108)

- when using verbose strict encoding conversion is required [\#107](https://github.com/mina-deploy/mina/issues/107)

- Export RBENV\_ROOT before rbenv init for system-wide install [\#106](https://github.com/mina-deploy/mina/issues/106)

- Do some tasks after deploy [\#98](https://github.com/mina-deploy/mina/issues/98)

- trying to fix permission for tmp directory [\#92](https://github.com/mina-deploy/mina/issues/92)

- how to run mina deploy with sudo? [\#86](https://github.com/mina-deploy/mina/issues/86)

- Early Deletion of .git repo [\#80](https://github.com/mina-deploy/mina/issues/80)

- symlink to current is broken [\#79](https://github.com/mina-deploy/mina/issues/79)

- Asset precompilation skip issue [\#60](https://github.com/mina-deploy/mina/issues/60)

- ln -sfn is NOT atomic [\#16](https://github.com/mina-deploy/mina/issues/16)

**Merged pull requests:**

- Suggest force\_unlock when deploy.lock file exists [\#327](https://github.com/mina-deploy/mina/pull/327) ([stevendaniels](https://github.com/stevendaniels))

- added support for ry [\#315](https://github.com/mina-deploy/mina/pull/315) ([kmmndr](https://github.com/kmmndr))

- Fix for \#309 [\#310](https://github.com/mina-deploy/mina/pull/310) ([13k](https://github.com/13k))

- Save deployed git sha in deploy/current/.mina\_git\_revision [\#306](https://github.com/mina-deploy/mina/pull/306) ([gaizka](https://github.com/gaizka))

- Reorder die parameters [\#281](https://github.com/mina-deploy/mina/pull/281) ([Bilge](https://github.com/Bilge))

- Allow you to optionally set an alternate procfile name [\#275](https://github.com/mina-deploy/mina/pull/275) ([henare](https://github.com/henare))

- Ability to customise Rails' public assets path [\#266](https://github.com/mina-deploy/mina/pull/266) ([dwfait](https://github.com/dwfait))

- Fix host verification error at first deploy if repo is not included to the list of known hosts [\#263](https://github.com/mina-deploy/mina/pull/263) ([flowerett](https://github.com/flowerett))

- Treat absent files as empty when changes script [\#230](https://github.com/mina-deploy/mina/pull/230) ([rodolfospalenza](https://github.com/rodolfospalenza))

- Allow for a build step [\#178](https://github.com/mina-deploy/mina/pull/178) ([dchancogne](https://github.com/dchancogne))

- Use `set -e` to fail fast [\#111](https://github.com/mina-deploy/mina/pull/111) ([5long](https://github.com/5long))

## [v0.3.4](https://github.com/mina-deploy/mina/tree/v0.3.4) (2015-03-27)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.3.3...v0.3.4)

**Closed issues:**

- More control on command verbosity [\#294](https://github.com/mina-deploy/mina/issues/294)

- db\_migrate not migrating [\#292](https://github.com/mina-deploy/mina/issues/292)

- Best way to reload nginx.conf [\#291](https://github.com/mina-deploy/mina/issues/291)

- bash : bundle: command not found [\#290](https://github.com/mina-deploy/mina/issues/290)

- Mina deploy: I have set up SSH, but can't connect to git@github.com [\#288](https://github.com/mina-deploy/mina/issues/288)

- Issue on loading an ENV variables in \*.yml files [\#269](https://github.com/mina-deploy/mina/issues/269)

## [v0.3.3](https://github.com/mina-deploy/mina/tree/v0.3.3) (2015-03-10)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.3.2...v0.3.3)

**Closed issues:**

- Error while precompiling assets \*\*bash: line 232: 21006 Killed\*\* [\#282](https://github.com/mina-deploy/mina/issues/282)

- unable to run rails console [\#279](https://github.com/mina-deploy/mina/issues/279)

- Setup task should not be trying to chown or chmod [\#278](https://github.com/mina-deploy/mina/issues/278)

- Unicorn not starting when using mina [\#272](https://github.com/mina-deploy/mina/issues/272)

- Prevent queue method to display output [\#268](https://github.com/mina-deploy/mina/issues/268)

- RVM is not a function [\#262](https://github.com/mina-deploy/mina/issues/262)

- Rolling back to previous release [\#9](https://github.com/mina-deploy/mina/issues/9)

**Merged pull requests:**

- Fix up formatting of code block in readme [\#274](https://github.com/mina-deploy/mina/pull/274) ([henare](https://github.com/henare))

- Fix link typo in readme [\#273](https://github.com/mina-deploy/mina/pull/273) ([henare](https://github.com/henare))

## [v0.3.2](https://github.com/mina-deploy/mina/tree/v0.3.2) (2015-01-24)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.3.1...v0.3.2)

**Closed issues:**

- Didn't get the current folder after mina setup [\#264](https://github.com/mina-deploy/mina/issues/264)

- git pull instead of git clone [\#259](https://github.com/mina-deploy/mina/issues/259)

- How do I run rake tasks before the current symlink is created? [\#255](https://github.com/mina-deploy/mina/issues/255)

- rbenv system-wide install [\#253](https://github.com/mina-deploy/mina/issues/253)

- link\_shared\_paths links to user folder [\#248](https://github.com/mina-deploy/mina/issues/248)

- Deploy failed 'no tty present', but no sudo? [\#247](https://github.com/mina-deploy/mina/issues/247)

- Skipping asset precompilation: wrong copy paths [\#246](https://github.com/mina-deploy/mina/issues/246)

- problems with restarting puma [\#245](https://github.com/mina-deploy/mina/issues/245)

- mina/foreman does not work due to sudo [\#233](https://github.com/mina-deploy/mina/issues/233)

- \[solved\] Initial deploy after installing 'whenever' gem: "...whenever is not part of the bundle. Add it to Gemfile." [\#231](https://github.com/mina-deploy/mina/issues/231)

- During launch stage, current symlink points to previous release [\#224](https://github.com/mina-deploy/mina/issues/224)

- link\_shared\_paths don't execute [\#210](https://github.com/mina-deploy/mina/issues/210)

- Is there a plan to release a new version? [\#206](https://github.com/mina-deploy/mina/issues/206)

- Update shared paths [\#188](https://github.com/mina-deploy/mina/issues/188)

- Deployment with Github WebHook URLs.. [\#165](https://github.com/mina-deploy/mina/issues/165)

**Merged pull requests:**

- 3rd party modules [\#258](https://github.com/mina-deploy/mina/pull/258) ([stereodenis](https://github.com/stereodenis))

- Fix link in the support guide [\#254](https://github.com/mina-deploy/mina/pull/254) ([jartek](https://github.com/jartek))

- mention  .ruby-version for rbenv comment [\#249](https://github.com/mina-deploy/mina/pull/249) ([equivalent](https://github.com/equivalent))

- Add npm support with a simple npm:install task [\#227](https://github.com/mina-deploy/mina/pull/227) ([paulRbr](https://github.com/paulRbr))

- Make rails console task dependent on the environment [\#220](https://github.com/mina-deploy/mina/pull/220) ([lucapette](https://github.com/lucapette))

- Adding support for server environment variables in deploy.rb, \(:env\_vars\) [\#161](https://github.com/mina-deploy/mina/pull/161) ([pricees](https://github.com/pricees))

- Added `mina ssh` command to connect to server [\#139](https://github.com/mina-deploy/mina/pull/139) ([adie](https://github.com/adie))

## [v0.3.1](https://github.com/mina-deploy/mina/tree/v0.3.1) (2014-10-17)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.3.0...v0.3.1)

**Fixed bugs:**

- Rails schema\_format = :sql makes Mina never migrate the database [\#74](https://github.com/mina-deploy/mina/issues/74)

**Closed issues:**

- mina deploy --help should not cause a deploy [\#238](https://github.com/mina-deploy/mina/issues/238)

- migrations aren't being run [\#236](https://github.com/mina-deploy/mina/issues/236)

- mina/foreman should not call sudo to start/stop/restart foreman [\#234](https://github.com/mina-deploy/mina/issues/234)

- Cleanup not run after deploy [\#218](https://github.com/mina-deploy/mina/issues/218)

- git:clone on win7 x64 had error [\#216](https://github.com/mina-deploy/mina/issues/216)

- Integration with Rollbar? [\#215](https://github.com/mina-deploy/mina/issues/215)

- Carrierwave: how to share public/uploads path? [\#214](https://github.com/mina-deploy/mina/issues/214)

- Should tmp dir be shared? [\#213](https://github.com/mina-deploy/mina/issues/213)

- How to display logs when I call the mina system command continuously in my sinatra app? [\#209](https://github.com/mina-deploy/mina/issues/209)

- mistypen exit\_status in bin/mina  [\#198](https://github.com/mina-deploy/mina/issues/198)

- set :keep\_releases does not work [\#196](https://github.com/mina-deploy/mina/issues/196)

- Wrong assets path when precompilation i skipped [\#193](https://github.com/mina-deploy/mina/issues/193)

- rake db:migrate fails to run on first deploy [\#191](https://github.com/mina-deploy/mina/issues/191)

- Installing Mina on Debian [\#186](https://github.com/mina-deploy/mina/issues/186)

- Dead project? [\#181](https://github.com/mina-deploy/mina/issues/181)

- "to :launch" creates restart.txt in the wrong directory [\#175](https://github.com/mina-deploy/mina/issues/175)

- Nothing happens when running "mina setup" [\#172](https://github.com/mina-deploy/mina/issues/172)

- launch block don't works [\#170](https://github.com/mina-deploy/mina/issues/170)

- AWS EC2 .pem file [\#164](https://github.com/mina-deploy/mina/issues/164)

- mina setup freezes at password [\#163](https://github.com/mina-deploy/mina/issues/163)

- Rails 4 and binstubs [\#162](https://github.com/mina-deploy/mina/issues/162)

- Migrating database fail  [\#160](https://github.com/mina-deploy/mina/issues/160)

- sudo: no tty present and no askpass program specified  [\#157](https://github.com/mina-deploy/mina/issues/157)

- Zero downtime deploys [\#152](https://github.com/mina-deploy/mina/issues/152)

- Question: Mina Deploy Precompile Error [\#146](https://github.com/mina-deploy/mina/issues/146)

- How to refactor \(?\) a long deploy.rb [\#145](https://github.com/mina-deploy/mina/issues/145)

- foreman module exports using the development environment [\#135](https://github.com/mina-deploy/mina/issues/135)

- `mina deploy` hangs [\#134](https://github.com/mina-deploy/mina/issues/134)

- How to restart nginx without enter password like you [\#129](https://github.com/mina-deploy/mina/issues/129)

- Release new gem version [\#122](https://github.com/mina-deploy/mina/issues/122)

- Problem with rake db:migrate [\#121](https://github.com/mina-deploy/mina/issues/121)

- Mina hangs after entering SSH password [\#88](https://github.com/mina-deploy/mina/issues/88)

- \[Bug\] Precompile Assets with JRuby [\#29](https://github.com/mina-deploy/mina/issues/29)

**Merged pull requests:**

- Prevent foreman export from expanding the current/ symlink [\#241](https://github.com/mina-deploy/mina/pull/241) ([postmodern](https://github.com/postmodern))

- Ruby 1.8.7 doesn't support empty symbols [\#240](https://github.com/mina-deploy/mina/pull/240) ([PChambino](https://github.com/PChambino))

- Add foreman\_location and foreman\_sudo configs [\#239](https://github.com/mina-deploy/mina/pull/239) ([PChambino](https://github.com/PChambino))

- Support pretty\_system on Ruby 1.8.7 [\#237](https://github.com/mina-deploy/mina/pull/237) ([PChambino](https://github.com/PChambino))

- Updated deploy.rb template to use shared\_path [\#235](https://github.com/mina-deploy/mina/pull/235) ([postmodern](https://github.com/postmodern))

- Allow the foreman export format to be configurable. [\#232](https://github.com/mina-deploy/mina/pull/232) ([postmodern](https://github.com/postmodern))

- Make tmp directory if it doesn't exist [\#229](https://github.com/mina-deploy/mina/pull/229) ([dvdhsu](https://github.com/dvdhsu))

- Update doc on \#invoke helper [\#226](https://github.com/mina-deploy/mina/pull/226) ([paulRbr](https://github.com/paulRbr))

- Revert "fix tmp/restart.txt path" [\#225](https://github.com/mina-deploy/mina/pull/225) ([gabskoro](https://github.com/gabskoro))

- Remove binstubs options from defaults [\#219](https://github.com/mina-deploy/mina/pull/219) ([lucapette](https://github.com/lucapette))

- fix: bin/mina exit\_status -\> exitstatus [\#212](https://github.com/mina-deploy/mina/pull/212) ([Zhomart](https://github.com/Zhomart))

- fix tmp/restart.txt path [\#208](https://github.com/mina-deploy/mina/pull/208) ([zigomir](https://github.com/zigomir))

- add rescue for rubinius SignalException [\#204](https://github.com/mina-deploy/mina/pull/204) ([qen](https://github.com/qen))

- Update .travis.yml [\#197](https://github.com/mina-deploy/mina/pull/197) ([lucianosousa](https://github.com/lucianosousa))

- Using `bundle\_bin` instead `bundle` in whenever tasks. [\#195](https://github.com/mina-deploy/mina/pull/195) ([mdorfin](https://github.com/mdorfin))

- Convert specs to RSpec expect syntax with transpec [\#194](https://github.com/mina-deploy/mina/pull/194) ([loganhasson](https://github.com/loganhasson))

- Parse task string to reenable task [\#189](https://github.com/mina-deploy/mina/pull/189) ([PChambino](https://github.com/PChambino))

- tense fix [\#184](https://github.com/mina-deploy/mina/pull/184) ([brandondrew](https://github.com/brandondrew))

- Check db/migrate/ instead of schema.rb [\#177](https://github.com/mina-deploy/mina/pull/177) ([chuckd](https://github.com/chuckd))

- Fix typo [\#173](https://github.com/mina-deploy/mina/pull/173) ([Bounga](https://github.com/Bounga))

- Fix typo in Rake url [\#168](https://github.com/mina-deploy/mina/pull/168) ([jfcartkeep](https://github.com/jfcartkeep))

- Fix copy command for assets [\#150](https://github.com/mina-deploy/mina/pull/150) ([joshdover](https://github.com/joshdover))

- stop using fork, which means JRuby support [\#148](https://github.com/mina-deploy/mina/pull/148) ([mrbrdo](https://github.com/mrbrdo))

- Fix directory-structure anchor [\#137](https://github.com/mina-deploy/mina/pull/137) ([christophermanning](https://github.com/christophermanning))

- Set RBENV\_ROOT [\#136](https://github.com/mina-deploy/mina/pull/136) ([trkoch](https://github.com/trkoch))

- Use consistent precision for time measurements. [\#133](https://github.com/mina-deploy/mina/pull/133) ([alloy-d](https://github.com/alloy-d))

- fixed 404 to foreman, changed link [\#132](https://github.com/mina-deploy/mina/pull/132) ([taxaos](https://github.com/taxaos))

- Update Readme.md [\#130](https://github.com/mina-deploy/mina/pull/130) ([vredniy](https://github.com/vredniy))

- Include full path in edit message [\#128](https://github.com/mina-deploy/mina/pull/128) ([nathanbertram](https://github.com/nathanbertram))

- Using rails env in whenever [\#127](https://github.com/mina-deploy/mina/pull/127) ([Reprazent](https://github.com/Reprazent))

- Bundler: Allow configuration of groups to be skipped during installation [\#123](https://github.com/mina-deploy/mina/pull/123) ([luislavena](https://github.com/luislavena))

- Correct Ruby 1.9 Hash syntax [\#116](https://github.com/mina-deploy/mina/pull/116) ([luislavena](https://github.com/luislavena))

- Support for chruby [\#115](https://github.com/mina-deploy/mina/pull/115) ([zaiste](https://github.com/zaiste))

- Add comment for system-wide RVM install. [\#112](https://github.com/mina-deploy/mina/pull/112) ([samqiu](https://github.com/samqiu))

- \[✔\] Fixed “print\_error”. [\#105](https://github.com/mina-deploy/mina/pull/105) ([mkempe](https://github.com/mkempe))

- Incorrect exit status if deploy fails [\#95](https://github.com/mina-deploy/mina/pull/95) ([borovsky](https://github.com/borovsky))

- Properly fixed tmp/restart issue [\#93](https://github.com/mina-deploy/mina/pull/93) ([ineu](https://github.com/ineu))

## [v0.3.0](https://github.com/mina-deploy/mina/tree/v0.3.0) (2013-07-10)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.2.1...v0.3.0)

**Closed issues:**

- Identity file \[/home/candidosg/.ec2/mirafloris.pem\] not accessible: No such file or directory. [\#120](https://github.com/mina-deploy/mina/issues/120)

- Still maintained? [\#118](https://github.com/mina-deploy/mina/issues/118)

- mina/foreman is not wokring [\#100](https://github.com/mina-deploy/mina/issues/100)

- Password prompt in mina doesn't work [\#99](https://github.com/mina-deploy/mina/issues/99)

- invoke "whenever" tasks [\#97](https://github.com/mina-deploy/mina/issues/97)

- link to current doesn't work if someboyd has the current as working directory [\#96](https://github.com/mina-deploy/mina/issues/96)

- Deploy to a Vagrant box locally [\#94](https://github.com/mina-deploy/mina/issues/94)

- Mina aborts during setup [\#91](https://github.com/mina-deploy/mina/issues/91)

- First deploy to a server fails if repo is not included to the list of known hosts  [\#90](https://github.com/mina-deploy/mina/issues/90)

- Command runs during deploy, but not when called independently [\#82](https://github.com/mina-deploy/mina/issues/82)

- Could not location Gemfile for rails tasks [\#73](https://github.com/mina-deploy/mina/issues/73)

- Testing against rake 10 [\#70](https://github.com/mina-deploy/mina/issues/70)

- Local shell commands [\#69](https://github.com/mina-deploy/mina/issues/69)

- Git commit message with non ASCII character raises error [\#68](https://github.com/mina-deploy/mina/issues/68)

- Delayed Job [\#66](https://github.com/mina-deploy/mina/issues/66)

- How to ENV variables [\#65](https://github.com/mina-deploy/mina/issues/65)

- Support for multi-stage deployment [\#62](https://github.com/mina-deploy/mina/issues/62)

- Can not access Rails from within Mina tasks [\#61](https://github.com/mina-deploy/mina/issues/61)

- Mina does not work on windows due to open4 gem [\#58](https://github.com/mina-deploy/mina/issues/58)

- Locally cached git repository [\#28](https://github.com/mina-deploy/mina/issues/28)

- Support for SVN [\#12](https://github.com/mina-deploy/mina/issues/12)

- working with rbenv/rvm etc? [\#5](https://github.com/mina-deploy/mina/issues/5)

**Merged pull requests:**

- Add helper method "capture", to get the output of ssh commands simply. [\#113](https://github.com/mina-deploy/mina/pull/113) ([ainoya](https://github.com/ainoya))

- Fix keep\_releases bug  [\#103](https://github.com/mina-deploy/mina/pull/103) ([rex79](https://github.com/rex79))

- Fix "can't modify frozen String" occurred in \#ssh\_command [\#102](https://github.com/mina-deploy/mina/pull/102) ([sonots](https://github.com/sonots))

- Fix \#84 command not found [\#89](https://github.com/mina-deploy/mina/pull/89) ([grigio](https://github.com/grigio))

- Fix git commit message encoding issue [\#85](https://github.com/mina-deploy/mina/pull/85) ([fuadsaud](https://github.com/fuadsaud))

- Foreman's stop task should stop [\#84](https://github.com/mina-deploy/mina/pull/84) ([andrewhr](https://github.com/andrewhr))

- Added '--create' to rvm:use and a new task to create rvm wrappers [\#81](https://github.com/mina-deploy/mina/pull/81) ([marcosbeirigo](https://github.com/marcosbeirigo))

- Full path to tmp/restart.txt [\#77](https://github.com/mina-deploy/mina/pull/77) ([ineu](https://github.com/ineu))

- Add :reenable option to Mina::Helper\#invoke [\#67](https://github.com/mina-deploy/mina/pull/67) ([uneco](https://github.com/uneco))

- add echo to last command of :setup task [\#64](https://github.com/mina-deploy/mina/pull/64) ([muxcmux](https://github.com/muxcmux))

## [v0.2.1](https://github.com/mina-deploy/mina/tree/v0.2.1) (2012-09-08)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.2.0...v0.2.1)

**Closed issues:**

- Deploying local repositories? [\#54](https://github.com/mina-deploy/mina/issues/54)

- which -s doesn't work on Debain [\#44](https://github.com/mina-deploy/mina/issues/44)

- Git password prompt does not work with "mina deploy" [\#41](https://github.com/mina-deploy/mina/issues/41)

- \[Feature\] Agent Forwarding [\#23](https://github.com/mina-deploy/mina/issues/23)

-  warning: --depth is ignored in local clones; use file:// instead. [\#56](https://github.com/mina-deploy/mina/issues/56)

**Merged pull requests:**

- Fix check for arguments in make\_run\_task lambda [\#43](https://github.com/mina-deploy/mina/pull/43) ([tmak](https://github.com/tmak))

## [v0.2.0](https://github.com/mina-deploy/mina/tree/v0.2.0) (2012-09-08)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.2.0.pre2...v0.2.0)

**Closed issues:**

- FATAL:  Ident authentication failed for user "name" [\#52](https://github.com/mina-deploy/mina/issues/52)

- Even faster asset compilation [\#32](https://github.com/mina-deploy/mina/issues/32)

**Merged pull requests:**

- fix ssh method when { :return =\> true } [\#53](https://github.com/mina-deploy/mina/pull/53) ([jpascal](https://github.com/jpascal))

- Allow changing :term\_mode for setup task [\#51](https://github.com/mina-deploy/mina/pull/51) ([alfuken](https://github.com/alfuken))

- Rewrote deploy:cleanup task to put it all in the same queue. [\#50](https://github.com/mina-deploy/mina/pull/50) ([dariocravero](https://github.com/dariocravero))

- added support whenever and fix exit from console [\#47](https://github.com/mina-deploy/mina/pull/47) ([jpascal](https://github.com/jpascal))

- Cleanup fails to cd releases\_path [\#45](https://github.com/mina-deploy/mina/pull/45) ([dariocravero](https://github.com/dariocravero))

- Prevent git log from using a pager [\#42](https://github.com/mina-deploy/mina/pull/42) ([tmak](https://github.com/tmak))

- Add helpful error message when there is a problem with deploy.rb or a custom Rakefile [\#37](https://github.com/mina-deploy/mina/pull/37) ([jesse-sge](https://github.com/jesse-sge))

## [v0.2.0.pre2](https://github.com/mina-deploy/mina/tree/v0.2.0.pre2) (2012-08-02)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.1.3.pre1...v0.2.0.pre2)

**Closed issues:**

- Task Argument Error [\#36](https://github.com/mina-deploy/mina/issues/36)

- Rename domain as host? [\#33](https://github.com/mina-deploy/mina/issues/33)

- Skip database migrations [\#18](https://github.com/mina-deploy/mina/issues/18)

- Optimize Git clone/checkout [\#10](https://github.com/mina-deploy/mina/issues/10)

**Merged pull requests:**

- Add in\_directory directory, to execute commands within a particular path [\#35](https://github.com/mina-deploy/mina/pull/35) ([jmibanez](https://github.com/jmibanez))

- bundle\_path can't be nil [\#31](https://github.com/mina-deploy/mina/pull/31) ([sfate](https://github.com/sfate))

## [v0.1.3.pre1](https://github.com/mina-deploy/mina/tree/v0.1.3.pre1) (2012-07-13)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.1.2...v0.1.3.pre1)

**Closed issues:**

- prompt for command-line input [\#30](https://github.com/mina-deploy/mina/issues/30)

- Assets compiling on redeploy [\#25](https://github.com/mina-deploy/mina/issues/25)

## [v0.1.2](https://github.com/mina-deploy/mina/tree/v0.1.2) (2012-07-06)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.1.2.pre2...v0.1.2)

**Closed issues:**

- deploy:link\_shared\_paths is broken [\#27](https://github.com/mina-deploy/mina/issues/27)

## [v0.1.2.pre2](https://github.com/mina-deploy/mina/tree/v0.1.2.pre2) (2012-07-03)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.1.2.pre1...v0.1.2.pre2)

**Closed issues:**

- Ability to overwrite the default tasks [\#26](https://github.com/mina-deploy/mina/issues/26)

- clean up old releases [\#24](https://github.com/mina-deploy/mina/issues/24)

- Specifying an environment [\#21](https://github.com/mina-deploy/mina/issues/21)

- Error when checking out to current\_revision [\#19](https://github.com/mina-deploy/mina/issues/19)

- branching [\#13](https://github.com/mina-deploy/mina/issues/13)

- Invoked tasks don't pick up ENV variables [\#11](https://github.com/mina-deploy/mina/issues/11)

**Merged pull requests:**

- Fix string interpolation in :init task output [\#15](https://github.com/mina-deploy/mina/pull/15) ([soulim](https://github.com/soulim))

- Added support for an ssh port [\#14](https://github.com/mina-deploy/mina/pull/14) ([chip](https://github.com/chip))

- link\_shared\_paths task was creating relative links instead of absolute ones [\#7](https://github.com/mina-deploy/mina/pull/7) ([Flink](https://github.com/Flink))

- add bundle\_bin option [\#6](https://github.com/mina-deploy/mina/pull/6) ([Arcath](https://github.com/Arcath))

## [v0.1.2.pre1](https://github.com/mina-deploy/mina/tree/v0.1.2.pre1) (2012-06-11)

[Full Changelog](https://github.com/mina-deploy/mina/compare/show...v0.1.2.pre1)

## [show](https://github.com/mina-deploy/mina/tree/show) (2012-06-11)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.1.1...show)

**Closed issues:**

- Run deploy outside of app directory [\#3](https://github.com/mina-deploy/mina/issues/3)

## [v0.1.1](https://github.com/mina-deploy/mina/tree/v0.1.1) (2012-06-07)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.1.0...v0.1.1)

**Merged pull requests:**

- Test git [\#2](https://github.com/mina-deploy/mina/pull/2) ([sosedoff](https://github.com/sosedoff))

## [v0.1.0](https://github.com/mina-deploy/mina/tree/v0.1.0) (2012-06-06)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.0.1.pre7...v0.1.0)

## [v0.0.1.pre7](https://github.com/mina-deploy/mina/tree/v0.0.1.pre7) (2012-06-06)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.0.1.pre6...v0.0.1.pre7)

## [v0.0.1.pre6](https://github.com/mina-deploy/mina/tree/v0.0.1.pre6) (2012-06-06)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.0.1.pre5...v0.0.1.pre6)

**Merged pull requests:**

- Gem tasks [\#1](https://github.com/mina-deploy/mina/pull/1) ([sosedoff](https://github.com/sosedoff))

## [v0.0.1.pre5](https://github.com/mina-deploy/mina/tree/v0.0.1.pre5) (2012-06-04)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.0.1.pre4...v0.0.1.pre5)

## [v0.0.1.pre4](https://github.com/mina-deploy/mina/tree/v0.0.1.pre4) (2012-06-04)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.0.1.pre3...v0.0.1.pre4)

## [v0.0.1.pre3](https://github.com/mina-deploy/mina/tree/v0.0.1.pre3) (2012-06-03)

[Full Changelog](https://github.com/mina-deploy/mina/compare/release/2012-06-03-180648...v0.0.1.pre3)

## [release/2012-06-03-180648](https://github.com/mina-deploy/mina/tree/release/2012-06-03-180648) (2012-06-03)

[Full Changelog](https://github.com/mina-deploy/mina/compare/release/2012-06-03-180617...release/2012-06-03-180648)

## [release/2012-06-03-180617](https://github.com/mina-deploy/mina/tree/release/2012-06-03-180617) (2012-06-03)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.0.1.pre2...release/2012-06-03-180617)

## [v0.0.1.pre2](https://github.com/mina-deploy/mina/tree/v0.0.1.pre2) (2012-06-02)

[Full Changelog](https://github.com/mina-deploy/mina/compare/v0.0.1.pre1...v0.0.1.pre2)

## [v0.0.1.pre1](https://github.com/mina-deploy/mina/tree/v0.0.1.pre1) (2012-06-02)

[Full Changelog](https://github.com/mina-deploy/mina/compare/release/2012-06-02--00-06-53...v0.0.1.pre1)

## [release/2012-06-02--00-06-53](https://github.com/mina-deploy/mina/tree/release/2012-06-02--00-06-53) (2012-06-01)

[Full Changelog](https://github.com/mina-deploy/mina/compare/release/2012-06-01--21-06-08...release/2012-06-02--00-06-53)

## [release/2012-06-01--21-06-08](https://github.com/mina-deploy/mina/tree/release/2012-06-01--21-06-08) (2012-06-01)

[Full Changelog](https://github.com/mina-deploy/mina/compare/release/2012-06-01--21-06-49...release/2012-06-01--21-06-08)

## [release/2012-06-01--21-06-49](https://github.com/mina-deploy/mina/tree/release/2012-06-01--21-06-49) (2012-06-01)

[Full Changelog](https://github.com/mina-deploy/mina/compare/release/2012-06-01--21-06-10...release/2012-06-01--21-06-49)

## [release/2012-06-01--21-06-10](https://github.com/mina-deploy/mina/tree/release/2012-06-01--21-06-10) (2012-06-01)

[Full Changelog](https://github.com/mina-deploy/mina/compare/release/2012-06-01--21-06-45...release/2012-06-01--21-06-10)

## [release/2012-06-01--21-06-45](https://github.com/mina-deploy/mina/tree/release/2012-06-01--21-06-45) (2012-06-01)

[Full Changelog](https://github.com/mina-deploy/mina/compare/release/2012-06-01--21-06-01...release/2012-06-01--21-06-45)

## [release/2012-06-01--21-06-01](https://github.com/mina-deploy/mina/tree/release/2012-06-01--21-06-01) (2012-06-01)



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
