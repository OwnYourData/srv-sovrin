#!/usr/bin/env ruby
# encoding: utf-8

require 'httparty'
require 'json'

# read parameters
config_raw = ARGV.pop
config = JSON.parse(config_raw)

# get genesis file
cmd = "wget -q " + config["genesis_file"]
system "bash", "-c", cmd

# write wallet
cmd = 'echo -e -n "' + config["wallet64"] + '" | base64 -d > wallet'
system "bash", "-c", cmd

# send data to be stored in database
info_url = "http://localhost:3000/api/info"
response = HTTParty.post(info_url,
				headers: { 'Content-Type' => 'application/json' },
				body: config.to_json)
