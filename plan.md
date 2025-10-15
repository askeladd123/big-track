file based configuration

`.big-track`
  - `files.toml`: maps files
    - `key`
    - `dst`
  - `remote.toml`: maps s3 remote: this can drastically change
    - `address`
  - `lock.toml`: hash
    - `file`
      - `hash`
      - `method`
  - `.cache`: store files here so versions can be changed
    - `.gitignore`: ignores `.cache`

cache:
  - garbage collect

sync:

push:
  - authentication
  - warning: example "do you really want to push 15GB file `countries` to `blob.amazon.com/countries`?"

fetcher: create a nix fetcher
