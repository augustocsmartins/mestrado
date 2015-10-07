# coding: utf-8

# coh_metrix_port.rb - .
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

# 26. Referências:
#* Dias-da Silva, B. C., Oliveira, M. F. d., and Moraes, H. R. d. (2002). Groundwork for the development of the brazilian portuguese wordnet. In PorTAL ’02: Proceedings of the Third International Conference on Advances in Natural Language Processing, pages 189–196, London, UK. Springer-Verlag.
#* Dias-da Silva, B. C. (2003). Human language technology research and the development of the brazilian portuguese wordnet. 17th International Congress of Linguists.
#* Dias-da Silva, B. C. (2005). A construç˜ao da base da wordnet.br: conquistas e desafios. In the Proceedings of the 3rd Workshop in Information and Human Language Technology (TIL’2005), pages 2238–2247.
#* Dias-da Silva, B. C., Di Felippo, A., and Nunes, M. G. V. (2008). The automatic mapping of princeton wordnet lexical-conceptual relations onto the brazilian portuguese wordnet database. In Chair), N. C. C., Choukri, K., Maegaard, B., Mariani, J., Odjik, J., Piperidis, S., and Tapias, D., editors, Proceedings of the Sixth International Language Resources and Evaluation (LREC’08), Marrakech, Morocco. European Language Resources Association (ELRA). http://www.lrec-conf.org/proceedings/lrec2008/.
#* Maziero, E. G., Pardo, T. A. S., Di Felipo, A. e Dias-da-Silva, B. C. (2008). A Base de Dados Lexical e a Interface Web do TeP 2.0 - Thesaurus Eletrônico para o Português do Brasil. Em Anais do VI Workshop em Tecnologia da Informação e da Linguagem Humana TIL, 2008, Vila Velha, ES.
#* Scarton, C. E. e Aluísio, S. M. (2009). Herança Automática das Relações de Hiperonímia para a Wordnet.Br. Série de Relatórios do NILC. NILC-TR-09- 10, Dezembro, 48p.
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/coh-metrix-port/metrics')

require 'metrics/ambiguity'
require 'metrics/anaphores'
require 'metrics/connectives'
require 'metrics/constituents'
require 'metrics/corref'
require 'metrics/count'
require 'metrics/freq'
require 'metrics/hypernyms'
require 'metrics/logic_ops'
require 'metrics/tokens'
require 'metrics/tag_set'

module Helpfulness
module PT
module CohMetrixPort

  class Readability

    attr_reader :r

    # The constructor accepts the text to be analysed, and returns a report
    # object which gives access to the 
    def initialize
      #RSRuby uses Singleton design pattern so call instance rather
      #@r = RSRuby.instance
      # Lingua.stemmer( %w(tokens), :language => "pt" )
    end

    def basic_counts(text)
      #text = "A decepção já começou assim que entrei no quarto. A mobília era velha demais pelo preço cobrado. Ar condicionado velho, televisão velha, frigobar antiqüíssimo!!! Mas o grande problema da mobília, era a cama, extremamente dura. Papel higienico do tipo lixa. Reparei também 02 teias de aranha. Como o banheiro tinha um mau cheiro horrível, pedimos para trocar de quarto. O dono da Pousada disse que já tinha feito de tudo e não conseguia resolver o problema do mau cheiro. Ou seja, ele sabia que colocava seus clientes em um lugar insuportável!!!"
      Metrics::Count.new(text)
    end

    private

  end

end
end
end
