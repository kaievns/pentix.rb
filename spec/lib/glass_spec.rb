require File.dirname(__FILE__) + "/../spec_helper"

describe Glass do

  before :all do
    @window = DummyWindow.new
    @glass  = Glass.new(@window, 1, 2)
    @window.glass = @glass
  end

  describe "initialization" do
    it "should use correct blocks color" do
      @glass.instance_variable_get('@block').color.should == Glass::COLOR
    end

    it "should assign the initial position" do
      @glass.pos_x.should == 1
      @glass.pos_y.should == 2
    end

    it "should render the glass walls correctly" do
      @glass.should render_blocks(%Q{
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x. . . . . . . . . . . . .x|
        |x.x.x.x.x.x.x.x.x.x.x.x.x.x|
      })
    end

    it "should have an empty matrix" do
      @glass.should have_matrix(%Q{
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
        | . . . . . . . . . . . |
      })
    end
  end

  describe "#spaces_below" do
    before do
      @glass  = Glass.new(@window, 1, 2)
      @figure = Figure.new(@window, :l_crutch)
      @figure.pos_x = 8
      @figure.pos_y = 2
    end

    it "should calculate the distance correctly when the figure is vertical" do
      @figure.rotate_left if @figure.size_x > @figure.size_y
      @glass.spaces_below(@figure).should == Glass::HEIGHT - @figure.size_y
    end

    it "should calculate the distance correctly when the figure is vertical" do
      @figure.rotate_left if @figure.size_y > @figure.size_y
      @glass.spaces_below(@figure).should == Glass::HEIGHT - @figure.size_y
    end

    it "should calculate the distance correctly when a figure is hanging in the middle" do
      @offset = Glass::HEIGHT / 2
      @figure.pos_y = @glass.pos_y + @offset

      @glass.spaces_below(@figure).should == Glass::HEIGHT - @figure.size_y - @offset
    end

    describe "with some blocks in the glass" do
      before do
        @stack_height = 3

        @stack_height.times do |y|
          3.times do |x|
            @glass.matrix[Glass::HEIGHT - 1 - y][x] = Color::WHITE
          end
        end
      end

      it "should subtract the blocks height when the figure is above them" do
        @figure.pos_x = @glass.pos_x + 1
        @glass.spaces_below(@figure).should == Glass::HEIGHT - @figure.size_y - @stack_height
      end

      it "should not calculate the blocks height when the figure is not above them" do
        @figure.pos_x = @glass.pos_x + 6
        @glass.spaces_below(@figure).should == Glass::HEIGHT - @figure.size_y
      end
    end
  end

end