#
# And here we handle the controls
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Controls

  BUTTONS = {
    :quit       => Button::KbQ,
    :reset      => Button::KbEscape,
    :drop       => Button::KbSpace,
    :left       => Button::KbLeft,
    :right      => Button::KbRight,
    :turn_left  => Button::KbUp,
    :turn_right => Button::KbDown
  }.freeze

  def command_for(button)
    BUTTONS.each do |key, value|
      return key if button === value
    end
  end

end
