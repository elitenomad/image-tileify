RSpec.describe Image::Tileify do
  it "has a version number" do
    expect(Image::Tileify::VERSION).not_to be nil
  end

  context 'Constants' do
    it "has a default tile width" do
      expect(Image::Tileify::Constants::TILE_WIDTH).to equal(256)
    end

    it "has a default tile height" do
      expect(Image::Tileify::Constants::TILE_WIDTH).to equal(256)
    end
    
    it "has a default tile output directory" do
      expect(Image::Tileify::Constants::OUTPUT_DIR).not_to be_nil
    end
  end
end
