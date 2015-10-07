#!/usr/bin/env ruby
# coding: utf-8

# syllabe.rb - .
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
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/syllable')
require 'tonic'
require 'silva2011_syllable_separator'
require 'silabas_pt'

module Helpfulness
module PT
module Syllable

  def Syllable.syllables(word)
    #Silva2011SyllableSeparator::syllables word
    SilabasPT::syllables word
  end

end
end
end

if __FILE__ == $0
  ARGV.each { | word |  puts "'#{word}' : " + 
    Helpfulness::PT::Syllable::syllables(word).to_s }
end
