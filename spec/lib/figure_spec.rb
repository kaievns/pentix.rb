require File.dirname(__FILE__) + "/../spec_helper"

describe Figure do
  before :all do
    @window = $test_window
    @block  = Block.new(@window, Color::WHITE)
  end

  describe "constructor" do

    before :all do
      @name  = :stairs
      @color = Figure::COLORS[Figure::FIGURES[@name].split('|').last.to_sym]

      Block.should_receive(:new).with(@window, @color).and_return(@block)

      @figure = Figure.new(@window, @name)
    end

    it "should assign the figure name" do
      @figure.name.should == @name
    end

    it "should assign a correct matrix" do
      @figure.should have_matrix(%Q{
        | .x. . . |
        | .x.x. . |
        | . .x.x. |
        | . . . . |
        | . . . . |
      })
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
        | . .x. . |
        | .x.x.x. |
        | . .x. . |
        | . . . . |
        | . . . . |
      })
    end

    it "should correctly render the stairs figure" do
      Figure.new(@window, :stairs).should render_blocks(%Q{
        | .x. . . |
        | .x.x. . |
        | . .x.x. |
        | . . . . |
        | . . . . |
      })
    end
  end

  describe "manipulations" do
    before :all do
      @figure = Figure.new(@window)
    end

    describe "move left" do
      it "should decrease the x-position by 1" do
        @figure.pos_x = 10
        @figure.move_left
        @figure.pos_x.should == 9
      end
    end

    describe "move right" do
      it "should increase the x-position by 1" do
        @figure.pos_x = 10
        @figure.move_right
        @figure.pos_x.should == 11
      end
    end

    describe "rotate left" do
      before :all do
        @figure = Figure.new(@window, :stairs)
      end

      it "should rotate the matrix contr-clockwise" do
        @figure.turn_left
        @figure.should have_matrix(%Q{
          | . . .x. |
          | . .x.x. |
          | .x.x. . |
          | . . . . |
          | . . . . |
        })
        @figure.turn_left
        @figure.should have_matrix(%Q{
          | .x.x. . |
          | . .x.x. |
          | . . .x. |
          | . . . . |
          | . . . . |
        })
        @figure.turn_left
        @figure.should have_matrix(%Q{
          | . .x.x. |
          | .x.x. . |
          | .x. . . |
          | . . . . |
          | . . . . |
        })
        @figure.turn_left
        @figure.should have_matrix(%Q{
          | .x. . . |
          | .x.x. . |
          | . .x.x. |
          | . . . . |
          | . . . . |
        })
      end
    end

    describe "rotate right" do
      before :all do
        @figure = Figure.new(@window, :stairs)
      end

      it "should rotate the matrix clockwise" do
        @figure.turn_right
        @figure.should have_matrix(%Q{
          | . .x.x. |
          | .x.x. . |
          | .x. . . |
          | . . . . |
          | . . . . |
        })
        @figure.turn_right
        @figure.should have_matrix(%Q{
          | .x.x. . |
          | . .x.x. |
          | . . .x. |
          | . . . . |
          | . . . . |
        })
        @figure.turn_right
        @figure.should have_matrix(%Q{
          | . . .x. |
          | . .x.x. |
          | .x.x. . |
          | . . . . |
          | . . . . |
        })
        @figure.turn_right
        @figure.should have_matrix(%Q{
          | .x. . . |
          | .x.x. . |
          | . .x.x. |
          | . . . . |
          | . . . . |
        })
      end
    end
  end
end
