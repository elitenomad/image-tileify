require "image/tileify"

module Image
    module Tileify
        RSpec.describe Image::Tileify::Perform do
            subject { described_class }
         
            describe "#zoom_levels_correction!" do
                context 'when zoom levels > 10' do
                    it "is expected to auto correct to 10" do
                        expect(
                            subject.new({
                                width: 256,
                                height: 256,
                                auto_zoom_levels: 40,
                                input_filename: 'spec/image/tileify/test.jpg',
                                output_dir: './tiles'
                            }).options.auto_zoom_levels
                        ).to equal(10)
                    end
                end

                context 'when zoom levels is negative' do
                    it "is expected to auto correct to nil" do
                        expect(
                            subject.new({
                                width: 256,
                                height: 256,
                                auto_zoom_levels: -40,
                                input_filename: 'spec/image/tileify/test.jpg',
                                output_dir: './tiles'
                            }).options.auto_zoom_levels
                        ).to be_nil
                    end
                end
            end

            describe "#tasks" do
                context 'when zoom levels is nil' do
                    it "is expected to return 1" do
                        expect(
                            subject.new({
                                width: 256,
                                height: 256,
                                auto_zoom_levels: nil,
                                input_filename: 'spec/image/tileify/test.jpg',
                                output_dir: './tiles'
                            }).tasks.length
                        ).to equal(1)
                    end
                end

                context 'when zoom levels has value' do

                    it "is expected to return equal to level" do
                        expect(
                            subject.new({
                                width: 256,
                                height: 256,
                                auto_zoom_levels: 3,
                                input_filename: 'spec/image/tileify/test.jpg',
                                output_dir: './tiles'
                            }).tasks.length
                        ).to eq(3)
                    end
                end
            end

            describe '#calculate_rows_columns' do
                context 'for given image, width and height values' do
                    let(:rows_columns) {
                        subject.new({
                            auto_zoom_levels: nil,
                            input_filename: 'spec/image/tileify/test.jpg',
                            output_dir: './tiles'
                        }).calculate_rows_columns(OpenStruct.new({rows: 2800, columns: 1800, depth: 16}), 100, 100)
                    }
                    it "is expected to return value rows and columns in an array" do
                       
                        expect(
                            rows_columns
                        ).to eq([28, 18])
                    end
                end
            end

            describe '#crops_x_y' do
                context 'for given rows,columns, width and height values' do
                    let(:crops) {
                        subject.new({
                            auto_zoom_levels: nil,
                            input_filename: 'spec/image/tileify/test.jpg',
                            output_dir: './tiles'
                        }).crops_x_y(2, 2, 1, 1)
                    }

                    it "is expected to return combination of cropped values to be stored" do
                        expect(
                            crops
                        ).to eq([
                            {:column=>0, :row=>0, :x=>0, :y=>0}, 
                            {:column=>1, :row=>0, :x=>1, :y=>0},
                            {:column=>0, :row=>1, :x=>0, :y=>1},
                            {:column=>1, :row=>1, :x=>1, :y=>1}
                        ])
                    end
                end
            end

            describe '#run!' do
                context 'for given rows,columns, width and height values' do
                    let(:result) {
                        subject.new({
                            width: 256,
                            height: 256,
                            auto_zoom_levels: nil,
                            input_filename: 'spec/image/tileify/test.jpg',
                            output_dir: './test_tiles'
                        }).run!
                    }

                    it "is expected to return true when no errors" do
                        expect(
                            result
                        ).to be_truthy
                    end

                    context "test_tiles" do
                        subject { "./test_tiles" }
                        it { is_expected.to  be_a_directory }

                        describe 'generated tiles' do
                            it 'is expected to have 0_0.jpg generated' do
                                expect("#{subject}/0_0.jpg").to exists
                            end

                            it 'is expected to have 0_256.jpg generated' do
                                expect("#{subject}/0_256.jpg").to exists
                            end

                            it 'is expected to have 768_0.jpg generated' do
                                expect("#{subject}/768_0.jpg").to exists
                            end

                            it 'is expected to have 768_512.jpg generated' do
                                expect("#{subject}/768_512.jpg").to exists
                            end
                        end
                    end
                end
            end
        end
    end
  end