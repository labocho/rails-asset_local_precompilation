# v0.1.14 (2024-02-19)

* support Vite's manifest file (`public/.vite/manifest.json`).

# v0.1.12 (2023-09-12)

* support `asset_host` option to set asset_host on precompilation.

# v0.1.11 (2021-10-26)

* use use nulldb when precompile assets always

# v0.1.10 (2021-10-26)

* avoid actual db access by model class methods (e.g. `column_names`) during `rake assets:precompile`.

# v0.1.9 (2021-08-18)

* fix version number

# v0.1.8 (2021-03-24)

* avoid breaking manifest.json by 'yarn install --check-files' and clear after sync

# v0.1.7 (2021-03-24)

* avoid breaking manifest.json by 'yarn install --check-files' and clear after sync

# v0.1.6 (2021-03-24)

* clear webpacker cache before compile

# v0.1.5 (2020-04-14)

* remove `bundle exec` on local to avoid some error

# v0.1.4 (2020-03-12)

* fix error when public/assets not exists

# v0.1.3 (2019-11-15)

* support custom asset_host (eg. S3 backended CloudFront)

# v0.1.2 (2019-11-08)

* fix attachment file icon url when unuse asset-sync

# v0.1.1 (2019-11-06)

* support application does not use webpack.
* extract ckeditor file generator.

# v0.1.0 (2019-11-05)

* initial release.

