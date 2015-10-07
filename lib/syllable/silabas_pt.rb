# coding: utf-8

# silva2011_syllable_separator.rb - .
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
# http://www.portaldalinguaportuguesa.org/index.php?action=syllables&act=list&letter=a
# http://pt.wikibooks.org/wiki/Portugu%C3%AAs/S%C3%ADlaba/Divis%C3%A3o
module Helpfulness
module PT
module Syllable

  module SilabasPT

    #CONSOANTES = ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'x', 'z', 'ç']

    # Vowels
    VOGAIS = ['a', 'e', 'i', 'o', 'u']

    CONJ_1 = ['b', 'c', 'd', 'f', 'g', 'p', 't', 'v']

    CONJ_2 = ['c', 'l', 'n']

    LATERAIS = ['l', 'r', 'z']

    H = ['h']

    #CONJ_5 = ['c', 'g', 'm', 'p']

    #CONJ_6 = ['n']

    ACENTOS_GA = ['à', 'á', 'é', 'í', 'ó', 'ú']

    CIRCUNFLEXO = ['â', 'ê', 'î', 'ô']

    # Semivowels
    SEMI_VOGAIS = ['i', 'u']

    TIL = ['ã', 'õ']

    # Nasal consonants
    NASAIS = ['m', 'n']

    CONJ_8 = ['q', 'g']

    #HIFEN = ['-']

    #MONOSSILABOS_ATONOS = ["o", "a", "os", "as", 
    #                       "um", "uns", 
    #                       "me", "te", "se", "lhe", "nos", "lhes", 
    #                       "que", 
    #                       "com", "de", "por", "sem", "sob", 
    #                       "e", "mas", "nem", "ou"]

    ACENTOS             = ACENTOS_GA + CIRCUNFLEXO + TIL
    VOGAIS_ACENTOS      = VOGAIS + ACENTOS
    #SEMI_VOGAIS_ACENTOS = SEMI_VOGAIS + ACENTOS

    # Separate the syllables of a word.

    #Required arguments:
    #w -- the word that will be separated in syllables

    #Returns:
    #A list of strings, containing each syllable of the word.
    def SilabasPT.syllables(w)
      palavra = w.downcase.dup
      if palavra == "ao" || palavra == "aos"
        return [palavra]
      end
      posicoes = constroi_posicoes2(palavra, constroi_posicoes1(palavra))
      return preenche_silabas(posicoes, palavra)
    end

    def SilabasPT.silaba_tonica(palavra, silabas)
      pos = tonica_pos(palavra, silabas)
      (pos >= 0 ? silabas[pos] : "-")
    end

    private

    def SilabasPT.preenche_silabas(posicoes, palavra)
      ret = Array.new
      if posicoes.length > 0
        i = 0
        while(i < posicoes.length - 1)
          # captura a string no formato de posicao[i] até posicao[i+1] subtraindo o valor dentro do índice
          # utilizar com virgula, siginifica tamanho
          ret << palavra[posicoes[i]..(posicoes[i+1] - 1)]
          i += 1
        end
        ret << palavra[posicoes[i]..palavra.length]
      end
      # puts "#{ret}: #{ret.length}"
      return ret
    end

    def SilabasPT.constroi_posicoes1(palavra)
      posicoes = Array.new
      for i in 1..palavra.length
        if include?(palavra[i], VOGAIS_ACENTOS) && !include?(palavra[i - 1], VOGAIS_ACENTOS) && (i > 1)
          if (include?(palavra[i - 1], H) && include?(palavra[i - 2], CONJ_2)) ||
             (include?(palavra[i - 1], LATERAIS) && include?(palavra[i - 2], CONJ_1))
            posicoes << (i - 2)
          else
            posicoes << (i - 1)
          end 
        end
      end
      if posicoes.length > 0 && posicoes[0] == 1 && !include?(palavra[0], VOGAIS_ACENTOS)
        posicoes[0] = 0
      end
      if posicoes.length == 0 || posicoes[0] != 0
        posicoes.insert(0, 0)
      end
      return posicoes
    end

    def SilabasPT.constroi_posicoes2(palavra, posicoes)
      for i in 1..palavra.length
        if include?(palavra[i], VOGAIS_ACENTOS) && include?(palavra[i - 1], VOGAIS_ACENTOS)
          if ((i <= 1) || (palavra[i - 1] != 'u') || !include?(palavra[i - 2], CONJ_8)) && !include?(palavra[i - 1], TIL)

            if !include?(palavra[i], SEMI_VOGAIS) ||
               (ultima_silaba(i, posicoes) && include_with_index?(LATERAIS, palavra, i + 1)) || 
                (include_with_index?(NASAIS, palavra, i + 1) && !include_with_index?(VOGAIS_ACENTOS, palavra, i + 1))

              for j in 0..posicoes.length
                if posicoes[j] > i
                  posicoes.insert(j, i)
                  break
                end
                if j == (posicoes.length - 1)
                  posicoes << i
                  break
                end
              end

            end
          end
        end
      end
      return posicoes
    end

    def SilabasPT.ultima_silaba(index, posicoes)
      (index >= (posicoes[posicoes.length - 1]))
    end

    def SilabasPT.include?(l, conjunto)
      conjunto.include?(l)
    end

    def SilabasPT.include_with_index?(conjunto, palavra, index)
      return false if index >= palavra.length || index < 0
      include?(palavra[index], conjunto)
    end

    def SilabasPT.tonica_pos(palavra, silabas)
      return -1 if MONOSSILABOS_ATONOS.include?(palavra) || palavra.length == 0

      # percorre o array de silabas invertido
      (silabas.length-1).downto(0).each do | i |
        silaba = silabas[i]
        # percorre cada letra na silaba
        for j in 0..silaba.length
          # verifica se a letra é acentuada ou se a silaba possui assento circunflexo e a palavra tem mais de 4 silabas
          if ACENTOS_GA.include?(silaba[j]) || (CIRCUNFLEXO.include?(silaba[j]) && (i > silabas.length - 4))
            # retorna a posição do acento
            return i
          end
          # verifica se a silaba possui assento ~ e a palavra tem mais de 3 silabas
          if TIL.include?(silaba[j]) && (i > silabas.length - 3)
            # retorna a posição do acento
            return i
          end
        end
      end

      # monossilabos ou última letra da palavra terminada em 'l', 'r', 'z'
      if silabas.length == 1 || LATERAIS.include?(palavra[-1,1])
        return silabas.length - 1
      end

      # verifica a se a última silaba é a tônica
      ultima_silaba = silabas.last
      for i in 0..ultima_silaba.length
        if SEMI_VOGAIS.include?(ultima_silaba[i]) && (ultima_silaba[i] != 'u' || !CONJ_8.include?(ultima_silaba[i]))
          return silabas.length - 1
        end
      end
      # retorna a posição [tamanho das silabas - 2]
      silabas.length - 2
    end

  end

end
end
end
