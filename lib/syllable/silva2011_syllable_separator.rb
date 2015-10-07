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
# Ported from original python version created by Alessandro Bokan <alessandro.bokan@gmail.com>
# https://github.com/andrecunha/coh-metrix-dementia
# http://www.portaldalinguaportuguesa.org/index.php?action=syllables&act=list&letter=a
module Helpfulness
module PT
module Syllable
  # This class implements the syllabic separation algorithm presented in
  # the fourth chapther of the PhD thesis:

  #  Silva, D.C. (2011) Algoritmos de Processamento da Linguagem e Síntese
  #  de Voz com Emoções Aplicados a um Conversor Text-Fala Baseado
  #  em HMM. PhD dissertation, COPPE, UFRJ.
  module Silva2011SyllableSeparator

    # Vowels
    V = ['a', 'e', 'o', 'á', 'é', 'í', 'ó', 'ú', 'ã', 'õ', 'â', 'ê', 'ô', 'à', 'ü']

    # Semivowels
    G = ['i', 'u']

    # Stop consonants
    COc = ['ca', 'co', 'cu', 'que', 'qui', 'ga', 'go', 'gu', 'gue', 'gui']
    CO  = ['p', 't',  'b', 'd', 'c', 'g', 'q'] + COc

    # Fricative consonants
    CFc = ['ce', 'ci', 'ss', 'ch', 'ge', 'gi']
    CF  = ['f', 'v', 's', 'ç', 'z', 'j', 'x'] + CFc

    # Liquid consonants
    CL = ['l', 'r', 'rr']

    # Nasal consonants
    CN = ['m', 'n']

    # Consonants
    C = ['lh', 'nh'] + CO + CF + CL + CN

    # Separate the syllables of a word.

    #Required arguments:
    #w -- the word that will be separated in syllables

    #Returns:
    #A list of strings, containing each syllable of the word.
    def Silva2011SyllableSeparator.syllables(w)
      p   = w.enum_for(:scan,/a|e|o|i|u|á|é|í|ó|ú|ã|õ|â|ê|ô|à|ü/).map { Regexp.last_match.begin(0) }
      p0  = 0  # syllable start position
      pVt = Tonic.tonic_vowel(w)  # tonic vowel position
      k   = 0
      c   = 0  # Count hyfens

      # Just to pass the Biderman test.
      return [w] if p.empty? || w.length == 1

      while p0 <= (w.length - 1)

        # Rule 1:
        if p[k] + 1 < w.length && V.include?(w[p0]) && !['ã', 'õ'].include?(w[p[k]]) && V.include?(w[p[k] + 1]) && !G.include?(w[p[k] + 1])
          # puts "RULE 1"
          if p[k] + 3 < w.length && w[p[k] + 2] == 's' && p[k] + 3 == w.length
            # puts "RULE 1.1"
            return w
          else
            # puts "RULE 1.2"
            w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)
          end

        # Rule 2:
        elsif p[k] + 3 < w.length && V.include?(w[p0]) && C.include?(w[p[k] + 1]) && C.include?(w[p[k] + 2]) && CO.include?(w[p[k] + 3])
          # puts "RULE 2"
          w, p0, k, c, p, pVt = case5(w, p, p0, pVt, k, c)

        # Rule 3:
        elsif p[k] + 2 < w.length && V.include?(w[p0]) && (G+CN+['s', 'r', 'l', 'x']).include?(w[p[k] + 1]) && C.include?(w[p[k] + 2])
          # TODO Problema "arr".
          # Exemplo: arrendar -> a-rre-dar (N) | ar-ren-dar (Y)

          # puts "RULE 3"
          if w[p[k] + 1] == 'i' && CN.include?(w[p[k] + 2])  # NOVA REGRA, p.ex: "ainda"
              # puts "RULE 3.0"
              w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)
          elsif !['s', 'h'].include?(w[p[k] + 2]) && w[p[k] + 1] != w[p[k] + 2]
              # puts "RULE 3.1"
              w, p0, k, c, p, pVt = case2(w, p, p0, pVt, k, c)
          elsif p[k] + 3 < w.length && CN.include?(w[p[k] + 1]) && w[p[k] + 2] == 's' && !V.include?(w[p[k] + 3])
              # puts "RULE 3.2"
              w, p0, k, c, p, pVt = case7(w, p, p0, pVt, k, c)
          elsif w[p[k] + 1] == w[p[k] + 2] || w[p[k] + 2] == 'h'
              # puts "RULE 3.3"
              w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)
          elsif p[k] + 3 < w.length && w[p[k] + 2] == 's' && ((C.include?(w[p[k] + 3]) && w[p[k] + 3] != 's') || !(C+V).include?(w[p[k] + 3]))
              # puts "RULE 3.4"
              w, p0, k, c, p, pVt = case7(w, p, p0, pVt, k, c)
          else
              # puts "RULE 3.5"
              w, p0, k, c, p, pVt = case2(w, p, p0, pVt, k, c)
          end

        # Rule 4:
        elsif p[k] + 3 < w.length && V.include?(w[p0]) && (CO+CF+['g', 'p']).include?(w[p[k] + 1]) && (CO+CF+CN+['ç']).include?(w[p[k] + 2]) && (V+G).include?(w[p[k] + 3])
          # puts "RULE 4"
          # TODO adicionando um G ao w[p[k] + 3], p.ex: ab-di-car
          if w[p[k] + 1] == w[p[k] + 2]
              w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)
          else
              w, p0, k, c, p, pVt = case2(w, p, p0, pVt, k, c)
          end

        # Rule 5:
        elsif (p[k] + 2 < w.length) && V.include?(w[p0]) && C.include?(w[p[k] + 1]) && (V + G + CL+['h']).include?(w[p[k] + 2])
          # puts "RULE 5"
          w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)

        # Rule 6:
        elsif p[k] + 3 < w.length && V.include?(w[p0]) && G.include?(w[p[k] + 1]) && w[p[k] + 2] == 's' && CO.include?(w[p[k] + 3])
          # TODO Regra 6 esta dentro da regra 3
          # puts "RULE 6"
          w, p0, k, c, p, pVt = case5(w, p, p0, pVt, k, c)

        # Rule 7:
        elsif p[k] + 2 < w.length && !V.include?(w[p0]) && (C + ['u', 'ü', 'q']).include?(w[p[k] - 1]) && C.include?(w[p[k] + 1]) && V.include?(w[p[k] + 2])
          # puts "RULE 7"
          w, p0, k, c, p, pVt = case3(w, p, p0, pVt, k, c)

        # Rule 8:
        elsif p[k] + 3 < w.length && !V.include?(w[p0]) && C.include?(w[p[k] - 1]) && G.include?(w[p[k] + 1]) && w[p[k] + 2] == 'r' && C.include?(w[p[k] + 3])
          # puts "RULE 8"
          # if p[k] == pVt:
          #    w, p0, k, c, p, pVt = case4(w, p, p0, pVt, k, c)
          # else:
          w, p0, k, c, p, pVt = case3(w, p, p0, pVt, k, c)

        # Rule 9:
        elsif p[k] + 3 < w.length && !V.include?(w[p0]) && C.include?(w[p[k] - 1]) && (G+CN).include?(w[p[k] + 1]) && w[p[k] + 2] == 's' && CO.include?(w[p[k] + 3])
          # puts "RULE 9"
          w, p0, k, c, p, pVt = case7(w, p, p0, pVt, k, c)

        # Rule 10:
        elsif p[k] + 3 < w.length && !V.include?(w[p0]) && (C+G).include?(w[p[k] - 1]) && ['i', 'u', 'e', 'o'].include?(w[p[k] + 1]) && p[k] + 1 != pVt && w[p[k]] != w[p[k] + 1] && C.include?(w[p[k] + 2]) && (C+V).include?(w[p[k] + 3]) && w[p[k] + 2] != 's'
  
          # puts "RULE 10"
          # a-juizado
          if p[k] == pVt && w[p[k] + 2] != 'n' && !C.include?(w[p[k] + 3])
            # puts "RULE 10.1"
            w, p0, k, c, p, pVt = case4(w, p, p0, pVt, k, c)
          elsif !['q', 'g'].include?(w[p[k] - 1]) && w[p[k]] == 'u' && w[p[k] + 1] == 'i' && w[p[k] + 2] != 'n'
            w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)
          elsif p[k] != pVt && w[p[k] + 1] == 'i' && w[p[k] + 2] != 'n'
            # puts "RULE 10.2"
            w, p0, k, c, p, pVt = case2(w, p, p0, pVt, k, c)
          elsif (w[p[k] + 1] != 'i' && (CN+['r']).include?(w[p[k] + 2]) && !['h', w[pVt]].include?(w[p[k] + 3])) || 
                  (['a', 'e', 'o'].include?(w[p[k]]) && ['a', 'e', 'o'].include?(w[p[k] + 1]) && CN.include?(w[p[k] + 2]) && !['h', 's'].include?(w[p[k] + 3]) && (V+C).include?(w[p[k] + 4]))

            # puts "RULE 10.3"
            if w[p[k] - 1..p[k] + 1] == "gu" && V.include?(w[p[k] + 1]) && CN.include?(w[p[k] + 2])
              w, p0, k, c, p, pVt = case5(w, p, p0, pVt, k, c)
            elsif w[p[k] - 1..p[k] + 1] == "gu" && V.include?(w[p[k] + 1]) && CL.include?(w[p[k] + 2])
              w, p0, k, c, p, pVt = case2(w, p, p0, pVt, k, c)
            else
              w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)
            end

          elsif G.include?(w[p[k]]) && ['a', 'e', 'o'].include?(w[p[k] + 1]) && CN.include?(w[p[k] + 2])
            # puts "RULE 10.4"
            w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)
          else
            # puts "RULE 10.5"
            w, p0, k, c, p, pVt = case4(w, p, p0, pVt, k, c)
          end

        # Rule 11:
        elsif p[k] + 2 < w.length && !V.include?(w[p0]) && C.include?(w[p[k] - 1]) && G.include?(w[p[k] + 1]) && V.include?(w[p[k] + 2])
          # puts "RULE 11"
          w, p0, k, c, p, pVt = case4(w, p, p0, pVt, k, c)

        # Rule 12:
        elsif p[k] + 3 < w.length && !V.include?(w[p0]) && C.include?(w[p[k] - 1]) && G.include?(w[p[k]]) && (V+['i']).include?(w[p[k] + 1]) && w[p[k]] != w[p[k] + 1] && C.include?(w[p[k] + 2]) && V.include?(w[p[k] + 3])
          # TODO Agregue un "i" as vogais
          #   porque sino no entra ao exemplo.
          # puts "RULE 12"
          if (['q', 'g']).include?(w[p[k] - 1]) && ((w[p[k] + 2] == 'ç' && ['ã', 'õ'].include?(w[p[k] + 3])) || (w[p[k] - 1] == 'q' && V.include?(w[p[k] + 1])))
            # puts "RULE 12.1"
            w, p0, k, c, p, pVt = case2(w, p, p0, pVt, k, c)
          elsif p[k] + 1 == pVt || w[p[k] - 1] == 'r' && p[k] + 3 == pVt
            # puts "RULE 12.2"
            w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)
          else
            # puts "RULE 12.3"
            w, p0, k, c, p, pVt = case8(w, p, p0, pVt, k, c)
          end

        # Rule 13:
        elsif p[k] + 3 < w.length && !V.include?(w[p0]) && (C.include?(w[p[k] - 1]) || (['qu', 'qü', 'gu', 'gü'].include?(w[p[k] - 1..p[k] + 1]))) && (V+CL+CN+['c', 'x']).include?(w[p[k] + 1]) && ['h', 'l', 'r'].include?(w[p[k] + 2]) && (V+['h', 'l', 'r']).include?(w[p[k] + 3])
          # TODO Arrumando regra para "guerra" -> gue-rra
          # puts "RULE 13"
          if w[p[k] + 1] == w[p[k] + 2] || ['c', 'l'].include?(w[p[k] + 1]) || w[p[k] + 1..p[k] + 3] == 'nh'
            # puts "RULE 13.1"
            w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)
          else
            # puts "RULE 13.2"
            w, p0, k, c, p, pVt = case4(w, p, p0, pVt, k, c)
          end

        # Rule 14:
        elsif p[k] + 2 < w.length && !V.include?(w[p0]) && C.include?(w[p[k] - 1]) && (CL+CN+['i']).include?(w[p[k] + 1]) && w[p[k] + 2] == 's'
          # puts "RULE 14"
          if p[k] + 3 == w.length
            p0 = case6(w, p0)
          elsif p[k] == pVt || (p[k] + 3 < w.length && V.include?(w[p[k] + 3]))
            w, p0, k, c, p, pVt = case4(w, p, p0, pVt, k, c)
          else
            w, p0, k, c, p, pVt = case5(w, p, p0, pVt, k, c)
          end

        # Rule 15:
        elsif p[k] + 2 < w.length && !V.include?(w[p0]) && V.include?(w[p[k] + 1]) && (V+G).include?(w[p[k] + 2]) && !['qu', 'gu'].include?(w[p[k] - 1..p[k] + 1])
          # puts "RULE 15", w[p0]
          if p[k] + 3 < w.length && p[k] == pVt && G.include?(w[p[k] + 1]) && C.include?(w[p[k] + 3])
            # puts "RULE 15.1"
            w, p0, k, c, p, pVt = case2(w, p, p0, pVt, k, c)
          else
            # puts "RULE 15.2"
            w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)
          end

        # Rule 16:
        elsif p[k] + 2 < w.length && !V.include?(w[p0]) && w[p[k]] != 'u' && C.include?(w[p[k] - 1]) && V.include?(w[p[k] + 1]) && CN.include?(w[p[k] + 2])
          # puts "RULE 16"
          w, p0, k, c, p, pVt = case3(w, p, p0, pVt, k, c)

        # Rule 17:
        elsif p[k] + 1 < w.length && p[k] - 2 >= 0 && !V.include?(w[p0]) && w[p[k]] == 'i' && (['á', 'é', 'í', 'ó', 'ú'].include?(w[p[k] - 2]) || ['á', 'é', 'í', 'ó', 'ú'].include?(w[p[k] - 3])) && C.include?(w[p[k] - 1]) && ['a', 'o'].include?(w[p[k] + 1])
          # TODO trocar caso 6 por caso 1.
          # carícia -> ca-rí-cia (N) | ca-rí-ci-a (Y)
          # puts "RULE 17"
          w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)

        # Rule 18:
        elsif p[k] + 1 < w.length && !V.include?(w[p0]) && ['ã', 'õ'].include?(w[p[k]]) && C.include?(w[p[k] - 1]) && ['e', 'o'].include?(w[p[k] + 1])
          # puts "RULE 18"
          p0 = case6(w, p0)

        # -------------------- Change rule 19 by 20 --------------------
        # Rule 20:
        elsif p[k] + 3 < w.length && !V.include?(w[p0]) && C.include?(w[p[k] - 1]) && V.include?(w[p[k] + 1]) && CN.include?(w[p[k] + 2]) && C.include?(w[p[k] + 3])
          # puts "RULE 20"
          w, p0, k, c, p, pVt = case7(w, p, p0, pVt, k, c)

        # Rule 19:
        elsif p[k] + 1 < w.length && !V.include?(w[p0]) && C.include?(w[p[k] - 1]) && p[k] + 1 == pVt && !['i', 'u'].include?(w[p[k] + 1]) && !['gu', 'qu'].include?(w[p[k] - 1..p[k] + 1])
          # puts "RULE 19"
          if p[k] + 3 == w.length && ['gu', 'qu'].include?(w[p[k] - 1..p[k] + 1]) && V.include?(w[p[k] + 1]) && C.include?(w[p[k] + 2])
            # puts "RULE 19.1"
            p0 = case6(w, p0)
          elsif p[k] + 2 < w.length && ['gu', 'qu'].include?(w[p[k] - 1..p[k] + 1]) && V.include?(w[p[k] + 1]) && (C+G).include?(w[p[k] + 2])
            # puts "RULE 19.2"
            w, p0, k, c, p, pVt = case5(w, p, p0, pVt, k, c)
          else
            # puts "RULE 19.3"
            w, p0, k, c, p, pVt = case3(w, p, p0, pVt, k, c)
          end

        # Rule 21:
        elsif p[k] + 3 < w.length && !V.include?(w[p0]) && (CO+['f', 'v', 'g']).include?(w[p[k] + 1]) && (CL+CO).include?(w[p[k] + 2]) && (V+G).include?(w[p[k] + 3])
          # puts "RULE 21"
          if ['f', 'p'].include?(w[p[k] + 1]) && ['t', 'ç'].include?(w[p[k] + 2])
            # puts "RULE 21.1"
            w, p0, k, c, p, pVt = case2(w, p, p0, pVt, k, c)
          else
            # puts "RULE 21.2"
            w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)
          end

        # Rule 22:
        elsif p[k] + 1 < w.length && p[k] - 2 >= 0 && !V.include?(w[p0]) && (C.include?(w[p[k] - 1]) || ['qu', 'gu'].include?(w[p[k] - 1..p[k] + 1]) ) && V.include?(w[p[k] + 1]) && (p[k] + 2 == w.length || C.include?(w[p[k] + 2]))
          # puts "RULE 22"
          if (['i', 'u', 'í', 'ú', 'é', 'ê'].include?(w[p[k]]) && p[k] == pVt && w[p[k] + 1] != 'u') || (p[k] + 3 < w.length && !G.include?(w[p[k]]) && w[p[k] + 2] == 's' && !(C+V).include?(w[p[k] + 3]))
            # puts "RULE 22.1"
            w, p0, k, c, p, pVt = case3(w, p, p0, pVt, k, c)
          elsif p[k] + 2 == w.length && w[p[k]] == 'i' && p[k] == pVt && w[p[k] + 1] == 'u'
            # puts "RULE 22.2"
            w, p0, k, c, p, pVt = case4(w, p, p0, pVt, k, c)
          elsif p[k] + 3 < w.length && ((G.include?(w[p[k]]) && p[k] + 1 != pVt && !(C + V).include?(w[p[k] + 2])) || (w[p[k] + 2] == 's' && !(C+V).include?(w[p[k] + 3])) || (p[k] != pVt && p[k] + 1 != pVt && w[p[k] + 2] == 's' && p[k] + 3 == w.length))
            # puts "RULE 22.3"
            p0 = case6(w, p0)
          elsif p[k] + 3 < w.length && ['qu', 'gu'].include?(w[p[k] - 1..p[k] + 1]) && C.include?(w[p[k] + 2]) && (V+G).include?(w[p[k] + 3])
            # puts "RULE 22.4"
            w, p0, k, c, p, pVt = case2(w, p, p0, pVt, k, c)
          elsif p[k] + 2 == w.length && ['qu', 'gu'].include?(w[p[k] - 1..p[k] + 1]) && (V+G).include?(w[p[k] + 1])
            # puts "RULE 22.4.5"
            p0 = case6(w, p0)
          elsif p[k] + 3 == w.length && ['o', 'u'].include?(w[p[k] + 1]) && p[k] + 1 != pVt && w[p[k] + 2] == 's'
            # puts "RULE 22.5"
            w, p0, k, c, p, pVt = case7(w, p, p0, pVt, k, c)
          else
            # TODO Trocar case2 por case 1
            # puts "RULE 22.6"
            w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)
          end

        # Rule 23:
        elsif p[k] + 2 < w.length && !V.include?(w[p0]) && (C.include?(w[p[k] - 1]) || w[p[k] - 2..p[k] - 1] == "qu") && C.include?(w[p[k] + 1]) && C.include?(w[p[k] + 2])
          # puts "RULE 23"
          if w[p[k] + 1] == w[p[k] + 2]
            # puts "RULE 23.1"
            w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)
          elsif w[p[k] + 1] == 's' && w[p[k] + 2] != 's'
            # puts "RULE 23.2"
            w, p0, k, c, p, pVt = case2(w, p, p0, pVt, k, c)
          elsif p[k] + 3 < w.length && w[p[k] + 2] == 's' && CO.include?(w[p[k] + 3])
            # puts "RULE 23.3"
            w, p0, k, c, p, pVt = case5(w, p, p0, pVt, k, c)
          else  # Adicionando ELSE
            # puts "RULE 23.4"
            w, p0, k, c, p, pVt = case2(w, p, p0, pVt, k, c)
          end

        # Rule 24:
        elsif p[k] + 2 < w.length && !V.include?(w[p0]) && C.include?(w[p[k] + 1]) && G.include?(w[p[k] + 2])
          # Regra 24 igual a 23. Arrumar regra, p.ex: di-sen-"teria"
          # puts "RULE 24"
          w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)

        # Rule 25: Already aplicated

        # Rule 26:
        elsif p[k] + 2 < w.length && !V.include?(w[p0]) && (C.include?(w[p[k] - 1]) || (['qu', 'qü', 'gu', 'gü'].include?(w[p[k] - 1..p[k] + 1]))) && G.include?(w[p[k] + 1]) && CN.include?(w[p[k] + 2])
          # Manual: a-mi-gui-nho | Automatic: a-mi-gu-i-nho
          # puts "RULE 26"
          w, p0, k, c, p, pVt = case4(w, p, p0, pVt, k, c)

        # Rule 27:
        elsif p[k] + 2 < w.length && !V.include?(w[p0]) && C.include?(w[p[k] - 1]) && C.include?(w[p[k] - 2]) && G.include?(w[p[k] + 1]) && C.include?(w[p[k] + 2])
          # puts "RULE 27"
          w, p0, k, c, p, pVt = case1(w, p, p0, pVt, k, c)

        # Rule 28
        elsif p[k] + 2 < w.length && !V.include?(w[p0]) && ['qu', 'qü', 'gu', 'gü'].include?(w[p[k] - 1..p[k] + 1]) && V.include?(w[p[k] + 1])
          # puts "RULE 28"
          if p[k] + 3 < w.length && C.include?(w[p[k] + 2]) && C.include?(w[p[k] + 3])
              # puts "RULE 28.1"
              w, p0, k, c, p, pVt = case5(w, p, p0, pVt, k, c)
          elsif p[k] + 3 < w.length && C.include?(w[p[k] + 2]) && (V+G).include?(w[p[k] + 3])
              # puts "RULE 28.2"
              w, p0, k, c, p, pVt = case4(w, p, p0, pVt, k, c)
          elsif p[k] + 2 < w.length && V.include?(w[p[k] + 2])
              # puts "RULE 28.3"
              w, p0, k, c, p, pVt = case4(w, p, p0, pVt, k, c)
          elsif p[k] + 2 < w.length && G.include?(w[p[k] + 2])
              # puts "RULE 28.4"
              w, p0, k, c, p, pVt = case5(w, p, p0, pVt, k, c)
          end

        end
        p0 += 1
      end
      puts "#{w}: #{w.split('-').length}"
      w.split('-')
    end

    private

      def Silva2011SyllableSeparator.case1(w, p, p0, pVt, k, c)
        # puts "case1"
        w     = w[0, p[k]+1] << "-" << w[p[k] + 1, w.length]
        # puts w
        p0    = p[k] + 1
        k     = (k + 1 < p.length ? k + 1 : k)
        c    += 1
        p[k]  = p[k] + c
        pVt  += 1
        return w, p0, k, c, p, pVt
      end

      def Silva2011SyllableSeparator.case2(w, p, p0, pVt, k, c)
        # puts "case2"
        w     = w[0, p[k] + 2] << "-" << w[p[k] + 2, w.length]
        # puts w
        p0    = p[k] + 2
        k     = (k + 1 < p.length ? k + 1 : k)
        c    += 1
        p[k]  = p[k] + c
        pVt  += 1
        return w, p0, k, c, p, pVt
      end

      def Silva2011SyllableSeparator.case3(w, p, p0, pVt, k, c)
        # puts "case3"
        w    = w[0, p[k]+1] << "-" << w[p[k] + 1, w.length] # Case 7
        # puts w
        p0   = p[k] + 1
        k    += 1
        c    += 1
        p[k]  = p[k] + c
        pVt  += 1
        return w, p0, k, c, p, pVt
      end

      def Silva2011SyllableSeparator.case4(w, p, p0, pVt, k, c)
        # puts "case4"
        w     = w[0, p[k] + 2] << "-" << w[p[k] + 2, w.length]
        # puts w
        p0    = p[k] + 2
        k     = (k + 1 < p.length ? k + 1 : k)
        c    += 1
        p[k]  = p[k] + c
        pVt  += 1
        return w, p0, k, c, p, pVt
      end

      def Silva2011SyllableSeparator.case5(w, p, p0, pVt, k, c)
        # puts "case5"
        w     = w[0, p[k]+3] << "-" << w[p[k] + 3, w.length]  # Case 5
        p0    = p[k] + 3
        k    += 1
        c    += 1
        p[k]  = p[k] + c
        pVt  += 1
        return w, p0, k, c, p, pVt
      end

      def Silva2011SyllableSeparator.case6(w, p0)
        # puts "case6"
        p0 += w.length - 1
        return p0
      end

      def Silva2011SyllableSeparator.case7(w, p, p0, pVt, k, c)
        # puts "case7"
        w     = w[0, p[k]+3] << "-" << w[p[k] + 3, w.length]  # Case 5
        p0    = p[k] + 3
        k    += 1
        c    += 1
        p[k]  = p[k] + c
        pVt  += 1
        return w, p0, k, c, p, pVt
      end

      def Silva2011SyllableSeparator.case8(w, p, p0, pVt, k, c)
        # puts "case8"
        w     = w[0,p[k]+1] << "-" << w[p[k] + 1, w.length]
        p0    = p[k] + 1
        k    += 1
        c    += 1
        p[k]  = p[k] + c
        pVt  += 1
        return w, p0, k, c, p, pVt
      end

  end

end
end
end