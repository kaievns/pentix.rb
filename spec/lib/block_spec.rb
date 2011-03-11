require File.dirname(__FILE__) + "/../spec_helper"

describe Block do
  before :all do
    @window = $test_window
    @i_args = [@window, 'media/block.png', true]
    @image  = Image.new(*@i_args)
  end

  it "should instance only one image" do
    Image.should_receive(:new).with(*@i_args).once.and_return(@image)

    @block1 = Block.new(@window, Color::WHITE)
    @block2 = Block.new(@window, Color::WHITE)
    @block3 = Block.new(@window, Color::WHITE)
  end

  it "should allow access to the block color" do
    Block.new(@window, Color::WHITE).color.should == Color::WHITE
    Block.new(@window, Color::GREEN).color.should == Color::GREEN
  end

  it "should draw the block in the given position with assigned color" do
    @color = Color::BLUE
    @pos_x = 10
    @pos_y = 20

    @image.should_receive(:draw).with(@pos_x * Block::SIZE, @pos_y * Block::SIZE, 0, 1.0, 1.0, @color)

    Block.new(@window, @color).draw(@pos_x, @pos_y)
  end
end