require 'optparse'
require 'ostruct'
require 'pp'

module Image
  module Tileify
    class Parser
      class Error < StandardError; end

      #
      # Return a structure describing the command line options.
      #
      def self.parse(args = {})
        options = OpenStruct.new
        options.width = Image::Tileify::Constants::TILE_WIDTH
        options.height = Image::Tileify::Constants::TILE_HEIGHT
        options.output_dir = Image::Tileify::Constants::OUTPUT_DIR
        options.auto_zoom_levels = nil
        options.input_filename = nil
      
        opt_parser = OptionParser.new do |opts|
            opts.banner = "Usage: Image tileify utility"
            opts.separator ""
            opts.separator "Specific options:"
            
            opts.on("-i=filename", "--input=filename", "Mandatory input file.") do |input|
              options[:input_filename] = input
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

            opts.separator ""
            opts.separator "Common options:"

            # Print the Opts object until this point. Exit when user enters -h option to the utility
            opts.on('-h', '--help', "You're looking at it.") { puts opts; exit }

            # Fetch the version from Image::Tileify::VERSION file from the gem and exit
            opts.on('-v', '--version', "Version information (v#{Image::Tileify::VERSION})") { puts Image::Tileify::VERSION; exit }
        end

        begin
          opt_parser.parse!

          if options[:input_filename].nil?
            puts "Input file must be provided. Try running 'tileify -h'"
          end
        rescue Error => e
          puts e.class
          puts "#{e.message}. Try running '#{File.basename($PROGRAM_NAME)} -h'"
        end  
    
        options
      end
    end
  end
end