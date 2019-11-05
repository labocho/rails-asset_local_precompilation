# AssetTasks
Short description and motivation.

## Usage

```ruby
rails g asset_tasks
```

Edit `Capfile`

```ruby
require "capistrano/local_compile"
```

Edit `config/initializers/asset_tasks.rb` to configure.

If you use asset_sync, create `shares/config/asset_sync.yml` on server and edit `config/deploy/production.rb`

```ruby
append :linked_files, "config/asset_sync.yml"
set :use_asset_sync, true
set :fog_directory, "bucket-name"
set :fog_region, "ap-northeast-1"
```

## Limitation

* Please configure production database settings on local environment to precompile assets.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'asset_tasks'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install asset_tasks
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
