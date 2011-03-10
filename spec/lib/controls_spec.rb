require File.dirname(__FILE__) + "/../spec_helper"

describe Controls do
  before :all do
    @controls = Controls.new($test_window)
  end

  Controls::BUTTONS.each do |command, button|
    it "should recognize the '#{command}' command" do
      @controls.command_for(button).should == command
    end
  end
end