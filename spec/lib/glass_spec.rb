require File.dirname(__FILE__) + "/../spec_helper"

describe Glass do

  before :all do
    @window = $test_window
    @glass  = Glass.new(@window, 1, 2)
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



end