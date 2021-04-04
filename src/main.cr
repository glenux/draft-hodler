
require "option_parser"
require "yaml"
require "colorize"
require "xdg_basedir"
require "completion"

require "./version"
require "./types"
require "./models"
require "./cli"

Hodler::Cli.run(ARGV)

