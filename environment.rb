require 'bundler/setup'
Bundler.require

require 'base64'

require 'colorize'
require 'colorized_string'

require 'faraday'
require 'faraday/net_http'

require 'io/console'

require 'json'

require 'uri'

require 'terminal-table'

require 'tty-prompt'

require_relative 'welcome'
require_relative 'api_services'

prompt = TTY::Prompt.new

Faraday.default_adapter = :net_http

