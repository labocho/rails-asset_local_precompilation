# Rails::AssetLocalPrecompilation

Set of capistrano task and initializer for local asset precompilation with asset_sync, ckeditor.

## Usage

```ruby
rails g asset_local_precompilation
```

Edit `Capfile`

```ruby
require "capistrano/asset_local_precompilation"
```

Edit `config/initializers/asset_local_precompilation.rb` to configure.

If you use asset_sync, create `shares/config/asset_sync.yml` on server and edit `config/deploy/production.rb`

```ruby
append :linked_files, "config/asset_sync.yml"
set :use_asset_sync, true
set :fog_directory, "bucket-name"
set :fog_region, "ap-northeast-1"
```


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rails-asset_local_precompilation', require: 'rails/asset_local_precompilation'
```

And then execute:
```bash
$ bundle
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
