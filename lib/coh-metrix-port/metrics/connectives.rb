# coding: utf-8

# hotel.rb - .
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
module Helpfulness
module PT
module CohMetrixPort
module Metrics

  module Conectives

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 29. Incidência de Conectivos: Incidência de todos os conectivos que aparecem em um texto. Para esta métrica (e as demais que contam conectivos) compilamos listas de conectivos classificados em duas dimensões. A primeira dimensão divide os conectivos em positivos e negativos (conectivos positivos estendem eventos, enquanto que conectivos negativos param eventos). A segunda dimensão divide os conectivos de acordo com o tipo de coesão: aditivos, temporais, lógicos e causais.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    # "O acessório polêmico entrou no projeto, de autoria do senador Cícero Lucena (PSDB-PB), graças a uma emenda aprovada na Comissão de Educação do Senado em outubro. Foi o senador Flávio Arns (PT-PR) quem sugeriu a inclusão da peça entre os itens do uniforme de alunos dos ensinos Fundamental e Médio nas escolas municipais, estaduais e federais. Ele defende a medida como forma de proteger crianças e adolescentes dos males provocados pelo excesso de exposição aos raios solares. Se a idéia for aprovada, os estudantes receberão dois conjuntos anuais, completados por calçado, meias, calça e camiseta."
    # No exemplo, as palavras em negrito são conectivos. Como há 4 conectivos e 95 palavras, a incidência de conectivos é 42,10 (número de conectivos/(número de palavras/1000)).


    # As listas de conectivos podem ser encontradas aqui.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 30. Conectivos Aditivos Positivos: Incidência de conectivos classificados como aditivos positivos.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 31. Conectivos Aditivos Negativos: Incidência de conectivos classificados como aditivos negativos.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 32. Conectivos Temporais Positivos: Incidência de conectivos classificados como temporais positivos.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 33. Conectivos Temporais Negativos: Incidência de conectivos classificados como temporais negativos.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 34. Conectivos Causais Positivos: Incidência de conectivos classificados como causais positivos.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 35. Conectivos Causais Negativos: Incidência de conectivos classificados como causais negativos.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 36. Conectivos Lógicos Positivos: Incidência de conectivos classificados como lógicos positivos.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 37. Conectivos Lógicos Negativos: Incidência de conectivos classificados como lógicos negativos.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
  end

end
end
end
end