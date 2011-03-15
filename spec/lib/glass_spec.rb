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
      @figure.move_to(@glass.pos_x + 3, @glass.pos_y)
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
        figure.move_to(@glass.pos_x + 2, @glass.pos_y)
        @glass.glue_in(figure)
      end

      it "should glue figures next to each other" do
        @figure.move_to(@glass.pos_x + 7, @glass.pos_y + 6)
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
        @figure.move_to(@glass.pos_x + 3, @glass.pos_y)
        @glass.glue_in(@figure)

        @figure.move_to(@glass.pos_x + 2, @glass.pos_y)
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
          | .x. . . . . . . . . . |
          | .x.x. . . . . . . . . |
          | . .x.x. . . . . . . . |
          | . .x. . . . . . . . . |
          | .x.x.x. . . . . . . . |
          | .x.x.x.x. . . . . . . |
          | .x. . . . . . . . . . |
          | .x. . . . . . . . . . |
        })
      end
    end
  end

  describe "#has_space_for?" do
    before do
      @figure = Figure.new(@window, :cross)
    end

    describe "in an empty glass" do
      it "should say 'yes' when the figure is in the middle" do
        @glass.should have_space_for(
          @figure.matrix, @glass.pos_x + 4, @glass.pos_y + 4
        )
      end

      it "should say 'nope' when the figure is out of the left border" do
        @glass.should_not have_space_for(
          @figure.matrix, @glass.pos_x, @glass.pos_y
        )
      end

      it "should say 'nope' if a figure is out of the right border" do
        @glass.should_not have_space_for(
          @figure.matrix, @glass.pos_x + Glass::WIDTH + 2 - @figure.size_x, @glass.pos_y
        )
      end

      it "should say 'nope' if a figure is below the bottom line" do
        @glass.should_not have_space_for(
          @figure.matrix, @glass.pos_x + 4, @glass.pos_y + Glass::HEIGHT - @figure.size_y + 1
        )
      end

      it "should say 'yup' for a figure next to the left border" do
        @glass.should have_space_for(
          @figure.matrix, @glass.pos_x + 1, @glass.pos_y
        )
      end

      it "should say 'yup' for a figure next to the right border" do
        @glass.should have_space_for(
          @figure.matrix, @glass.pos_x + Glass::WIDTH + 1 - @figure.size_x, @glass.pos_y
        )
      end

      it "should say 'yup' for a figure next to the bottom border" do
        @glass.should have_space_for(
          @figure.matrix, @glass.pos_x + 4, @glass.pos_y + Glass::HEIGHT - @figure.size_y
        )
      end
    end

    describe "with some blocks in the glass" do
      before do
        10.times do |i|
          @glass.matrix[i][i] = Color::GRAY
        end
      end

      it "should say 'yup' for figures that are away from the blocks" do
        @glass.should have_space_for(
          @figure.matrix, @glass.pos_x + 8, @glass.pos_y
        )
      end

      it "should say 'yup' for figures that fit the landscape" do
        @glass.should have_space_for(
          @figure.matrix, @glass.pos_x + 3, @glass.pos_y
        )
      end

      it "should say 'nope' for figures that intersect with the landscape" do
        @glass.should_not have_space_for(
          @figure.matrix, @glass.pos_x + 1, @glass.pos_y
        )
      end
    end
  end

  describe "#remove_full_lines" do

    before do
      10.times do |y|
        @glass.matrix[y].each_with_index do |cell, x|
          @glass.matrix[Glass::HEIGHT - y - 1][x] =
            y % 2 == 0 || x % 2 == 0 ? 0xFFFFFFFF : nil
        end
      end

      @glass.remove_full_lines
    end

    it "should have matrix like that" do
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
        |x. .x. .x. .x. .x. .x. |
        |x. .x. .x. .x. .x. .x. |
        |x. .x. .x. .x. .x. .x. |
        |x. .x. .x. .x. .x. .x. |
        |x. .x. .x. .x. .x. .x. |
      })
    end
  end

end