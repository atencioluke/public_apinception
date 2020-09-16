# fetch data from API
require 'net/http'
require 'json'
require 'open-uri'

# CLI navigation tools
require "tty-prompt"

# Debugging
require 'pry'

# Files in program
require_relative '../lib/public_apinception/cli'
require_relative '../lib/public_apinception/adapter'
require_relative '../lib/public_apinception/api'
require_relative '../lib/public_apinception/category'
require_relative '../lib/public_apinception/ascii-images'