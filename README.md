# flickr-store

Store arbitrary data with your 1TB Flickr cloud drive by encoding any file as a PNG. This is mostly a proof of concept right now. Don't do anything beyond tinkering with it yet.

## Installation

```
$ gem install flickr-store
```

## Usage

First, you will need to register a Flickr application [through their dev site](http://www.flickr.com/services/apps/create/). Once that is done, you can login by running:

```
flickr-authenticate
```

Once you complete authentication, you can now use flickr-store:

```
flickr-store put [file]
flickr-store get [file or photo ID] [output path]
flickr-store list
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
