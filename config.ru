#\ -s puma
require 'rubygems'
require 'bundler'

Bundler.require

require './lesh'
run LeSh::App
