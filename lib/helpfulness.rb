# coding: utf-8
# helpfulness.rb - .
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
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/coh-metrix-port')

require 'hotel'
require 'syllable'
require 'coh_metrix_port'

module Helpfulness
module PT

# The class Helpfulness::PT::Opinions
class Opinions
  
  attr_reader :connection
  
  # The constructor accepts the text to be analysed, and returns a report
  # object which gives access to the 
  def initialize(options = {})

    case options[:type]
    when "hotel"
      analyse_hotel_opinions
    when "restaurant"
      analyse_restaurant_opinions
    when "attractions"
      analyse_attractions_opinions
    end

  end

  def analyse_hotel_opinions
    puts "=> Número de opinioes agrupadas por localidades"
    Helpfulness::PT::Hotel.number_of_opinons_by_location

    puts "=> Número de hoteis agrupados por número de opiniões"
    Helpfulness::PT::Hotel.number_of_hotels_by_number_of_reviews

    puts "=> Número de opinioes agrupadas por votos de utilidade"
    Helpfulness::PT::Hotel.number_of_opinons_by_helpfulness

    #Helpfulness::PT::Hotel.setup_basics
    #Helpfulness::PT::Hotel.setup_stylistics
    #Helpfulness::PT::Hotel.setup_lsa
  end

  def analyse_restaurant_opinions
  end

  def analyse_attractions_opinions
  end

end
end
end