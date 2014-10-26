require 'rubygems'
require 'bundler'
require 'data_mapper'

Bundler.require

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite::memory:')

require './models/link'

DataMapper.finalize.auto_upgrade!

require './lesh'
run LeSh::App
