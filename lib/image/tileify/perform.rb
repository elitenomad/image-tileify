require 'RMagick'
require 'fileutils'
require 'ostruct'

module Image
    module Tileify
        class Perform
            class FileNotReadableError < StandardError; end
            class ImageNotScalableError < StandardError; end
            attr_accessor :image, :options, :extension

            # Read the image file.
            def read_image(file)
                begin
                    Magick::Image::read(file).first
                rescue Magick::ImageMagickError => e
                    raise FileNotReadableError.new('Issue in reading file')
                end
            end

            # correct zoom levels input
            def zoom_levels_correction!
                zoom_levels = options.auto_zoom_levels

                # If provided value is > 10 
                if zoom_levels && zoom_levels > 10
                    options.auto_zoom_levels = 10
                end

                if zoom_levels && zoom_levels <= 0
                    options.auto_zoom_levels = nil
                end
            end

            def tasks
                t = []
                if options.auto_zoom_levels.nil?
                    # if we have no auto zoom request, then dont scale
                    # save it directly to the output directory (default ./tiles)
                    t << {
                      output_dir: options.output_dir,
                      scale: 1.0 # dont scale
                    }
                else
                    # do have zoom levels, so construct those tasks
                    previous_zoom_level = options.auto_zoom_levels
                    scale = 1.0
                    t << {
                      output_dir: File.join(options.output_dir, previous_zoom_level.to_s),
                      scale: scale,
                    }

                    (options.auto_zoom_levels).times do |level|
                      scale = scale / 2.0
                      previous_zoom_level = previous_zoom_level - 1
                      t << {
                        output_dir: File.join(options.output_dir, previous_zoom_level.to_s),
                        scale: scale
                      }
                    end
                end

                return t
            end

            def run!
                tasks.each do |task|
                    image = @image
                    
                    # if scale required, scale image (rMagick scale utility)
                    if task[:scale] != 1.0
                      begin
                        image = @image.scale(task[:scale])
                      rescue RuntimeError => e
                        raise ImageNotScalableError.new('Failed to scale image')
                      end
                    end

                    # create output dir
                    create_path(task[:output_dir])

                    # Generate tiles
                    self.generate_tiles(image, task[:output_dir], @options.width, @options.height)
                    image = nil
                end
                
                true
            end

            def create_path(directory_path)
                FileUtils.mkdir_p directory_path
            end

            # Use image width and height
            # then find out how many tiles we'll get out of
            # the image, then use that for the xy offset in crop.
            def calculate_rows_columns(image, tile_width, tile_height)
                [
                    (image.rows/tile_height.to_f).ceil,
                    (image.columns/tile_width.to_f).ceil
                ]
            end

            # crops array
            # contains x, y coordinates.
            def crops_x_y(rows, columns, tile_width, tile_height)
              crops = []
              x,y,column,row = 0,0,0,0
                while true
                  x = column * tile_width
                  y = row * tile_height
                  crops << {
                    x: x,
                    y: y,
                    row: row,
                    column: column
                  }
                  column = column + 1

                  if column >= columns
                    column = 0
                    row = row + 1
                  end

                  if row >= rows
                    break
                  end
                end

                crops
            end

            def generate_tiles(image, filename_prefix, tile_width, tile_height)
                rows, columns = calculate_rows_columns(image, tile_width, tile_height)

                crops = crops_x_y(rows, columns, tile_width, tile_height)
          
                crops.each do |c|
                  # crop the image with given x, y , w and h
                  cropped_image = image.crop(c[:x], c[:y], tile_width, tile_height, true)
          
                  # write the file cropped to the directory created
                  cropped_image.write("#{filename_prefix}/#{c[:x]}_#{c[:y]}.#{extension}")
          
                  # remove the reference to the image
                  cropped_image = nil
                end
              end

            def initialize(options)
              @options = OpenStruct.new(options)
              @image = read_image(options[:input_filename])
              @extension = options[:input_filename].split(".").last

              # out of bounds zoom levels will be corrected
              zoom_levels_correction! 
            end
          end
    end
end
