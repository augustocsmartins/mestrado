#!/usr/bin/env ruby
# coding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
# helpvotes.rb - .
# Copyright (C) 2014  Augusto Cesar S. Martins
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Authors:  Augusto Cesar S. Martins <augusto@base16.com.br>
require 'rubygems'
require 'gli'
require 'mysql2'
require 'open-nlp'
require 'rsemantic'
require 'stopwords'
require 'lingua/stemmer'
require 'terminal-table'
require 'helpfulness'
require 'iconv'
require 'csv'

include GLI::App

OpenNLP.use :portuguese
OpenNLP.model_path = "#{File.dirname(__FILE__)}/lib/models/opennlp/"
OpenNLP.load

program_desc 'TripAdvisor Helpfulness Votes'

desc 'Determines TripAdvisor Helpfulness Votes about Hotels'
command :hotel do |c|
  c.action do |global_options, options, args|
    puts "Determines TripAdvisor Helpfulness Votes about Hotels"
    helpfulness = Helpfulness::PT::Opinions.new({type: "hotel"})

  end
end

desc 'Determines TripAdvisor Helpfulness Votes about Restaurants'
command :restaurant do |c|
  c.action do |global_options,options,args|
    puts "Determines TripAdvisor Helpfulness Votes about Restaurants"

  end
end

desc 'Determines TripAdvisor Helpfulness Votes about Attractions'
command :attraction do |c|
  c.action do |global_options,options,args|
    puts "Determines TripAdvisor Helpfulness Votes about Restaurants"

  end
end

pre do |global,command,options,args|
  true
end

post do |global,command,options,args|
  true
end

on_error do |exception|
  true
end

exit run(ARGV)
