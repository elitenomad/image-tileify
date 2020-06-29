require 'optparse'
require 'ostruct'
require 'pp'

module Image
  module Tileify
    class Parser
      class Error < StandardError; end   
      #
      # Return a structure describing the options.
      #
      def self.parse(args = {})
        # The options specified on the command line will be collected in *options*.
        # We set default values here.
        options = OpenStruct.new
        options.width = Image::Tileify::Constants::TILE_WIDTH
        options.height = Image::Tileify::Constants::TILE_HEIGHT
        options.prefix = Image::Tileify::Constants::TILE_PREFIX
        options.output_dir = Image::Tileify::Constants::OUTPUT_DIR
        options.auto_zoom_levels = nil
        options.input_filename = nil
        options.verbose = false

      
        opt_parser = OptionParser.new do |opts|
            opts.banner = "Usage: Image tileify utility"
            opts.separator ""
            opts.separator "Specific options:"
            
            opts.on("-i=filename", "--input=filename", "Mandatory input file.") do |input|
              options[:input_filename] = input
            end

          
            opts.on("-p=prefix", "--prefix=prefix", "Prefix to add to generated output files.") do |prefix|
              options[:prefix] = prefix
            end

            opts.on("-w=width", "--width=width", Integer, "Width of the tile to be generated. default: 256") do |width|
              options[:width] = width
            end

            opts.on("-l=height", "--height=height", Integer, "Height of the tile to be generated. default: 256") do |height|
              options[:height] = height
            end

            opts.on("-z=zoom_level", "--zoom-level=zoom_level", Integer, "scale input image N times, must be a number") do |zoom_level|
              options[:auto_zoom_levels] = zoom_level
            end

            opts.on("-o=output", '--output=ouput', String, "Output directory (will be created if it doesn't exist).") do |output|
              options[:output_dir] = output 
            end

            opts.on('-v', '--verbose', "Enable verbose logging.") do |verbose|
              options[:verbose] = true 
            end

            opts.separator ""
            opts.separator "Common options:"

            # Print the Opts object until this point. Exit when user enters -h option to the utility
            opts.on('-h', '--help', "You're looking at it.") { puts opts; exit }

            # Fetch the version from Image::Tileify::VERSION file from the gem and exit
            opts.on('-vv', '--version', "Version information (v#{Image::Tileify::VERSION})") { puts Image::Tileify::VERSION; exit }

            # opts.on('--dont-extend-incomplete-tiles',
            #      "Do not extend edge tiles if they do not fill an entire tile_width x tile_height. " +
            #      "By default tileup will extend tiles to tile_width x tile_height if required.") {|e|options[:extend_incomplete_tiles] = false}
        end

        begin
          opt_parser.parse!(args)
        rescue SystemExit => e
          exit
        rescue Exception => e
          #TODO: Raise error here
          puts e.class
          puts "Argument error, #{e.message}. Try running '#{File.basename($PROGRAM_NAME)} -h'"
          exit
        end  
    
        options
      end
    end
  end
end