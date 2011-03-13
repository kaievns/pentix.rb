require File.dirname(__FILE__) + "/../spec_helper"

describe Glass do

  before do
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

  describe "#glue_in" do
    before do
      @figure = Figure.new(@window, :stairs)
    end

    it "should glue the figure in when it's on top" do
      @figure.move(@glass.pos_x + 2, @glass.pos_y)
      @glass.glue_in(@figure)
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
        | . .x. . . . . . . . . |
        | . .x.x. . . . . . . . |
        | . . .x.x. . . . . . . |
      })
    end

    describe "with some blocks already in the glass" do
      before do
        figure = Figure.new(@window, :l_crutch)
        figure.move(@glass.pos_x + 1, @glass.pos_y)
        @glass.glue_in(figure)
      end

      it "should glue figures next to each other" do
        @figure.move(@glass.pos_x + 6, @glass.pos_y + 6)
        @glass.glue_in(@figure)

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
          | .x. . . . . . . . . . |
          | .x.x. . . .x. . . . . |
          | .x. . . . .x.x. . . . |
          | .x. . . . . .x.x. . . |
        })
      end

      it "should glue figures on top of each other" do
        @figure.move(@glass.pos_x + 1, @glass.pos_y)
        @glass.glue_in(@figure)

        @figure.move(@glass.pos_x, @glass.pos_y)
        @glass.glue_in(@figure)

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
          |x. . . . . . . . . . . |
          |x.x. . . . . . . . . . |
          | .x.x. . . . . . . . . |
          | .x. . . . . . . . . . |
          | .x.x. . . . . . . . . |
          | .x.x.x. . . . . . . . |
          | .x.x. . . . . . . . . |
          | .x. . . . . . . . . . |
          | .x. . . . . . . . . . |
        })
      end
    end


  end

end