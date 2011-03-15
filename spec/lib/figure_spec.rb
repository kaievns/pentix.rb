require File.dirname(__FILE__) + "/../spec_helper"

class DummyWindow
  def show_next_figure
  end
end

describe Figure do
  before :all do
    @window = DummyWindow.new

    @window.glass  = @glass  = Glass.new(@window,   1, 2)
    @window.status = @status = Status.new(@window, 20, 2)
  end

  describe "initialization" do

    describe "by name" do
      before do
        @name   = :stairs
        @color  = Figure::COLORS[Figure::FIGURES[@name].split('|').last.to_sym]
        @figure = Figure.new(@window, @name)
      end

      it "should assign the figure name" do
        @figure.name.should == @name
      end

      it "should set the right color" do
        @figure.color.should == @color
      end

      it "should assign a correct matrix" do
        @figure.should have_matrix(%Q{
          |x. . |
          |x.x. |
          | .x.x|
        })
      end

      it "should preset initial position 0:0" do
        @figure.pos_x.should == 0
        @figure.pos_y.should == 0
      end

      it "should preset the figure sizes" do
        @figure.size_x.should == 3
        @figure.size_y.should == 3
      end
    end

    it "should instance random figures if called without a name" do
      [
        Figure.new(@window),
        Figure.new(@window),
        Figure.new(@window),
        Figure.new(@window),
        Figure.new(@window)
      ].map(&:name).uniq.size.should > 1
    end

  end

  describe "#draw" do

    it "should correctly render the cross figure" do
      Figure.new(@window, :cross).should render_blocks(%Q{
        | .x. |
        |x.x.x|
        | .x. |
      })
    end

    it "should correctly render the stairs figure" do
      Figure.new(@window, :stairs).should render_blocks(%Q{
        |x. . |
        |x.x. |
        | .x.x|
      })
    end
  end

  describe "manipulations" do
    before do
      @pos_x    = @glass.pos_x + 4
      @pos_y    = @glass.pos_y

      @figure   = Figure.new(@window, :l_crutch)
      @figure.move_to(@pos_x, @pos_y)

      @distance = 10
      @glass.stub!(:spaces_below).and_return(@distance)
    end

    describe "#move_to" do
      before do
        @figure.move_to(10, 20)
      end

      it "should set the x-position" do
        @figure.pos_x.should == 10
      end

      it "should set the y-position" do
        @figure.pos_y.should == 20
      end

      it "should recalc the distance" do
        @figure.distance.should == @distance
      end
    end

    describe "#move_left" do
      before do
        @figure.move_left
      end

      it "should decrease the x-position by 1" do
        @figure.pos_x.should == @pos_x - 1
      end

      it "should set the figure's distance" do
        @figure.distance.should == @distance
      end

      it "should not move the figure beyond the left border" do
        @pos_x = @figure.pos_x = @glass.pos_x + 1
        @figure.move_left
        @figure.pos_x.should == @pos_x
      end
    end

    describe "#move_right" do
      before do
        @figure.move_right
      end

      it "should increase the x-position by 1" do
        @figure.pos_x.should == @pos_x + 1
      end

      it "should set the figure's distance" do
        @figure.distance.should == @distance
      end

      it "should not move the figure beyond the right border" do
        @pos_x = @figure.pos_x = @glass.pos_x + Glass::WIDTH + 2 - @figure.size_x
        @figure.move_right
        @figure.pos_x.should == @pos_x
      end
    end

    describe "#rotate_left" do
      before do
        @figure.turn_left
      end

      it "should rotate the matrix contr-clockwise" do
        @figure.should have_matrix(%Q{
          | .x. . |
          |x.x.x.x|
        })
        @figure.turn_left
        @figure.should have_matrix(%Q{
          | .x|
          | .x|
          |x.x|
          | .x|
        })
        @figure.turn_left
        @figure.should have_matrix(%Q{
          |x.x.x.x|
          | . .x. |
        })
        @figure.turn_left
        @figure.should have_matrix(%Q{
          |x. |
          |x.x|
          |x. |
          |x. |
        })
      end

      it "should recalculate the matrix size" do
        @figure.size_x.should == 4
        @figure.size_y.should == 2

        @figure.turn_left
        @figure.size_x.should == 2
        @figure.size_y.should == 4
      end

      it "should adjust figure's position to make it look centered" do
        @figure.pos_x.should == @pos_x - 1
        @figure.turn_left #making it vertical again
        @figure.pos_x.should == @pos_x
      end

      it "should set the figure's distance" do
        @figure.distance.should == @distance
      end

      it "should not turn the figure if there is no space for that" do
        figure = Figure.new(@window, :h_stick)

        # setting it vertically
        figure.move_to(@glass.pos_x + 1, @glass.pos_y)
        figure.turn_left
        figure.should have_matrix(%Q{
          |x|
          |x|
          |x|
          |x|
          |x|
        })

        # moving it to the left border
        figure.move_to(@glass.pos_x + 1, @glass.pos_y)
        figure.turn_left
        figure.should have_matrix(%Q{
          |x|
          |x|
          |x|
          |x|
          |x|
        })
      end
    end

    describe "#rotate_right" do
      before do
        @figure.turn_right
      end

      it "should rotate the matrix clockwise" do
        @figure.should have_matrix(%Q{
          |x.x.x.x|
          | . .x. |
        })
        @figure.turn_right
        @figure.should have_matrix(%Q{
          | .x|
          | .x|
          |x.x|
          | .x|
        })
        @figure.turn_right
        @figure.should have_matrix(%Q{
          | .x. . |
          |x.x.x.x|
        })
        @figure.turn_right
        @figure.should have_matrix(%Q{
          |x. |
          |x.x|
          |x. |
          |x. |
        })
      end

      it "should recalculate the matrix size" do
        @figure.size_x.should == 4
        @figure.size_y.should == 2

        @figure.turn_right
        @figure.size_x.should == 2
        @figure.size_y.should == 4
      end

      it "should adjust figure's position to make it look centered" do
        @figure.pos_x.should == @pos_x - 1
        @figure.turn_left #making it vertical again
        @figure.pos_x.should == @pos_x
      end

      it "should set the figure's distance" do
        @figure.distance.should == @distance
      end

      it "should not turn the figure if there is no space for that" do
        figure = Figure.new(@window, :h_stick)

        # setting it vertically
        figure.move_to(@glass.pos_x + 1, @glass.pos_y)
        figure.turn_right

        # moving it to the left border
        figure.move_to(@glass.pos_x + 1, @glass.pos_y)
        figure.turn_right

        figure.should have_matrix(%Q{
          |x|
          |x|
          |x|
          |x|
          |x|
        })
      end
    end
  end

  describe "#drop" do
    before do
      @figure = Figure.new(@window)
      @figure.move_to(@glass.pos_x + 1, @glass.pos_y)
    end

    it "should call the glass to #glue_in the figure" do
      @glass.should_receive(:glue_in).with(@figure)
      @figure.drop
    end

    it "should call the @window to #show_next_figure" do
      @window.should_receive(:show_next_figure)
      @figure.drop
    end
  end
end
