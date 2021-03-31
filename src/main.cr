
require "option_parser"
require "yaml"
require "colorize"
require "xdg_basedir"
require "completion"

# require "./config"
require "./version"
require "./cli"


Hodler::Cli.run(ARGV)

