# Image::Tileify

Welcome to your friendly neighbourhood new image-tileify gem! :) 

# Directory structure

```

  |-> bin
      |-> console 
      |-> setup
      |-> tilefy (binary which generates tiles)

  |-> lib
      |-> tileify.rb (Gateway to the core functionality of the gem)
      |-> tileify
          |-> version.rb (Gem versioning file)
          |-> constants.rb (Constants used in the gem)
          |-> parser.rb (bin/tileify argument parsers)
          |-> perform.rb ( Main file which crops and writes the files)
  |-> tiles
      |-> Output directory where all the tiles will be placed based on zoom level

```


## Pre requisites and notes

- Install imagemagick. use brew install imagemgick
  - Note: i had high sierra in my imac and latest version didn't work. so had to install imagemagick@6 version.
  - Reference: https://blog.francium.tech/installing-rmagick-on-osx-high-sierra-7ea71f57390d

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'image-tileify'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install image-tileify

## Usage

```

Utility helper

$ bin/tileify -h
Usage: Image tileify utility

Specific options:
    -i, --input=filename             Mandatory input file.
    -p, --prefix=prefix              Prefix to add to generated output files.
    -w, --width=width                Width of the tile to be generated. default: 256
    -l, --height=height              Height of the tile to be generated. default: 256
    -z, --zoom-level=zoom_level      scale input image N times, must be a number
    -o, --output=ouput               Output directory (will be created if it doesn't exist).
        --verbose                    Enable verbose logging.

Common options:
    -h, --help                       You're looking at it.
    -v, --versionv                   Version information (v0.1.0)


```

Generate tiles for a given image for zoom levels 2. From the gem directory, run the below command.

```
bin/tileify -i /Users/pranava/Downloads/713669080a3eff059c320c925250f6f1.jpg -z 2
```

## Test an image with custom width and height

Added a pokemon image of 2800 x 1800 size. It has 28 columns and 18 Rows. If we have to tile individual pokemon from large image

```
  rows =  2800/28 (100)
  columns = 1800/18 (100)

  So tile size should be 100 x 100. Ran the below command which generates tiles of indivudal pokemons from large image.

  bin/tileify -i images/sugimori.png -w 100 -l 100

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/image-tileify. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/image-tileify/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Image::Tileify project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/image-tileify/blob/master/CODE_OF_CONDUCT.md).
