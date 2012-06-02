Bundler
=======

To manage Bundler installations, add this to your `deploy.rb`:

``` ruby
require 'van_helsing/bundler'
```

Settings
--------

This introduces the following settings:

* __bundle_path__  
The path where bundles are going to be installed. Defaults to
`./vendor/bundler`.

* __bundle_options__  
Options that will be passed onto `bundle install`.  Defaults to
`--without development:test --path "#{bundle_path}" --binstubs bin/
--deployment"`.

Tasks
-----

This also provides the following tasks:

### bundle:install

Invokes `bundle:install` on the current directory, creating the bundle
path (specified in `bundle_path`), and invoking `bundle install`.

The `bundle_path` is only created if `bundle_path` is set (which is on
by default).
