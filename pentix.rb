#
# The main script
#
# Copyright (C) 2011 Nikolay Nemshilov
#

$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

require 'gosu'
include Gosu

require 'block'
require 'figure'
require 'glass'
require 'status'
require 'controls'
require 'finish'
require 'game'


Game.new.show if $0 == __FILE__
