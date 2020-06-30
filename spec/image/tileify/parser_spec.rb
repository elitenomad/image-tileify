require "image/tileify"

module Image
    module Tileify
        RSpec.describe Image::Tileify::Parser do
            subject { described_class }
         
            context "with no arguments" do
                let(:arguments) { [] }
           
                it "displays usage information" do
                  expect{subject.parse({})}.to output(/Input file must be provided. Try running 'tileify -h'/).to_stdout
                end
            end

            context "default arguments" do
                let(:arguments) { ["-i", "images/sugimori.png"] }
                let(:expected) { {:width=>256, :height=>256, :output_dir=>"./tiles", :auto_zoom_levels=>nil, :input_filename=> nil} }

                it "returns right hash information" do
                    expect(subject.parse(arguments).to_h).to include(expected)
                end
            end
        end
    end
  end