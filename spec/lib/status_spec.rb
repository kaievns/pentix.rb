require File.dirname(__FILE__) + "/../spec_helper"

describe Status do
  before :all do
    @window = DummyWindow.new
    @window.glass = Glass.new(@window, 1, 1)

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

    it "should set first level" do
      @status.level.should == 1
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

    it "should set the first level" do
      @status.level.should == 1
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

  describe "scoring" do
    before do
      @figure = Figure.new(@window)

      @status.score = 0
      @status.level = 1
      @status.lines = 0
      @status.figures = 0
    end

    it "should calculate correctly a figure drop score" do
      @figure.distance = 8

      @status.count_drop @figure

      @status.score.should == 8
      @status.figures.should == 1
    end

    it "should multiply the drop score by the current level" do
      @figure.distance = 9
      @status.level = 3

      @status.count_drop @figure

      @status.score.should == 27
      @status.figures.should == 1
    end

    it "should score lines kill according to the scoring system" do
      Status::SCORING_SYSTEM.each do |lines_num, score|
        @status.score = 0
        @status.lines = 0

        @status.count_kill Array.new(lines_num)

        @status.score.should == score
        @status.lines.should == lines_num
      end
    end

    it "should multiply the lines kill score by the current level" do
      Status::SCORING_SYSTEM.each do |lines_num, score|
        @status.score = 0
        @status.lines = 0
        @status.level = 4

        @status.count_kill Array.new(lines_num)

        @status.score.should == score * 4
        @status.lines.should == lines_num
      end
    end
  end

  describe "levelups" do
    before do
      @status.reset!
    end

    it "should not levelup until the user scores a minimum amount of lines" do
      (Status::LEVELUP - 1).times do
        @status.count_kill [1]
      end

      @status.level.should == 1
    end

    it "should levelup right after the user scores the needed amount of lines" do
      Status::LEVELUP.times do
        @status.count_kill [1]
      end

      @status.level.should == 2
    end

    it "should keep excessive lines count after each levelup" do
      (Status::LEVELUP - 1).times do
        @status.count_kill [1]
      end

      @status.level.should == 1

      @status.count_kill [1,2,3]

      @status.level.should == 2

      (Status::LEVELUP - 3).times do
        @status.count_kill [1]
      end

      @status.level.should == 2

      @status.count_kill [1]

      @status.level.should == 3
    end
  end

end