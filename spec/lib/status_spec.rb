require File.dirname(__FILE__) + "/../spec_helper"

describe Status do
  before :all do
    @window = $test_window

    @head_font_args = [@window, Status::HEAD_FONT[0], Status::HEAD_FONT[1]]
    @text_font_args = [@window, Status::TEXT_FONT[0], Status::TEXT_FONT[1]]

    @head_font = Font.new(*@head_font_args)
    @text_font = Font.new(*@text_font_args)

    @status = Status.new(@window, 10, 20)
  end

  describe "initialization" do
    it "should instantiate correct fonts" do
      Font.should_receive(:new).with(*@head_font_args).and_return(@head_font)
      Font.should_receive(:new).with(*@text_font_args).and_return(@text_font)

      @status = Status.new(@window, 10, 20)
    end

    it "should set correct positions" do
      @status.pos_x.should == 10
      @status.pos_y.should == 20
    end

    it "should set zero level" do
      @status.level.should == 0
    end

    it "should set zero lines" do
      @status.lines.should == 0
    end

    it "should set zero figures" do
      @status.figures.should == 0
    end

    it "should set zero score" do
      @status.score.should == 0
    end
  end

  describe '#reset!' do
    before :all do
      @status.level   = 8
      @status.score   = 9999
      @status.lines   = 234
      @status.figures = 1234

      @status.reset!
    end

    it "should set zero level" do
      @status.level.should == 0
    end

    it "should set zero lines" do
      @status.lines.should == 0
    end

    it "should set zero figures" do
      @status.figures.should == 0
    end

    it "should set zero score" do
      @status.score.should == 0
    end
  end

  describe "#draw" do
    it "should draw the things" do
      Font.should_receive(:new).with(*@head_font_args).and_return(@head_font)
      Font.should_receive(:new).with(*@text_font_args).and_return(@text_font)

      @figure = Figure.new(@window)
      @status = Status.new(@window, 10, 20)
      @status.figure = @figure

      @figure.should_receive(:pos_x=).with(10)
      @figure.should_receive(:pos_y=).with(22)
      @figure.should_receive(:draw)

      @head_font.should_receive(:draw).with("Next:",    200, 395, 0, 1.0, 1.0, Status::HEAD_FONT[2])
      @head_font.should_receive(:draw).with("Score:",   200, 575, 0, 1.0, 1.0, Status::HEAD_FONT[2])
      @head_font.should_receive(:draw).with("Winnars:", 200, 755, 0, 1.0, 1.0, Status::HEAD_FONT[2])

      @status.draw
    end
  end

end