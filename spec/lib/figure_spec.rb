require File.dirname(__FILE__) + "/../spec_helper"

describe Figure do
  before :all do
    @window = DummyWindow.new
    @glass  = Glass.new(@window, 1, 2)
    @window.glass = @glass
  end

  describe "initialization" do

    describe "by name" do
      before do
        @distance = 22
        @glass.should_receive(:spaces_below).and_return(@distance)

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

      it "should preset the figure distance" do
        @figure.distance.should == @distance
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
      @figure   = Figure.new(@window, :l_crutch)
      @distance = 10
      @glass.stub!(:spaces_below).and_return(@distance)
    end

    describe "#move" do
      before do
        @figure.move(10, 20)
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
        @figure.pos_x = 10
        @figure.move_left
      end

      it "should decrease the x-position by 1" do
        @figure.pos_x.should == 9
      end

      it "should set the figure's distance" do
        @figure.distance.should == @distance
      end
    end

    describe "#move_right" do
      before do
        @figure.pos_x = 10
        @figure.move_right
      end

      it "should increase the x-position by 1" do
        @figure.pos_x.should == 11
      end

      it "should set the figure's distance" do
        @figure.distance.should == @distance
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

      it "should set the figure's distance" do
        @figure.distance.should == @distance
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

      it "should set the figure's distance" do
        @figure.distance.should == @distance
      end
    end
  end

  describe "#drop" do
    before do
      @figure = Figure.new(@window)
      @result = @figure.drop
    end

    it "should return the @figure itself back" do
      @result.should == @figure
    end

    it "should increase the vertical position by the glass height" do
      @figure.pos_y.should == Glass::HEIGHT
    end
  end
end
