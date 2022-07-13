# Versioning Schemes

When deploying with Mina, Mina creates a new folder for each deployment. The versioning scheme simply determines how this folder will be named.

The scheme used by Mina is defined by the `:version_scheme` variable. The default scheme is [`:sequence`](#sequence).

Sections below document supported schemes.

## `:sequence`

This scheme uses sequential integers to name release folders.

The folder for the first deployment will be named `1`, for the second deployment it will be named `2`, for the third `3`, and so on.

To use this scheme, set:
```ruby
# config/deploy.rb
set :version_scheme, :sequence
```

Example folder structure on the server:
```sh
releases
├── 87
├── 88
├── 89
├── 90
├── 91
└── 92
```

## `:datetime`

This scheme uses the time at which the deployment has started as its folder name.

The folder name is created by concatenating the current year, month, day, hour, minute and seconds. For example, if you deploy at exactly `2022-02-26 10:54:09`, the release folder will be named `20220226105409`.

To use this scheme, set:
```ruby
# config/deploy.rb
set :version_scheme, :datetime
```

Example folder structure on the server:
```sh
releases
├── 20170701123242
├── 20170704131253
├── 20170708032142
├── 20170710082353
└── 20170720012031
```
