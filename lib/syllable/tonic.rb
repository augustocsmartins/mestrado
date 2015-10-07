# coding: utf-8

# tonic.rb - .
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
module Helpfulness
module PT
module Syllable
  # Implements the tonic vowel finding algorithm presented in
  # the third chapther of the PhD thesis:

  # Silva, D.C. (2011) Algoritmos de Processamento da Linguagem e Síntese
  # de Voz com Emoções Aplicados a um Conversor Text-Fala Baseado
  # em HMM. PhD dissertation, COPPE, UFRJ.
  module Tonic

    def Tonic.tonic_vowel(word)
      # Regra 1: Se existe acento, a vogal marcada é tônica
      match = word.index(/á|é|í|ó|ú|â|ê|ô|à|ã|õ/)
      return match if match
          
      # TODO PALAVRA MARIOR A 2
      # Rule 2: if ^(0) = {r,l,z,x,n} then T = 1
      return word.length - 2 if (word =~/[rlzxn]$/)
        
      # Rule 3:
      # if ^(0) = {m} & ^(1) = {i,o,u} then T = 1
      return word.length - 2 if (word =~/[iou]m$/)
        
      # Rule 4:
      # if ^(0) = {s} & ^(1) = {n} & ^(2) = {i,o,u} then T = 1
      return word.length - 3 if (word =~/[iou]ns$/)

      # Rule 5:
      # if ^(0) = {i} & ^(1) = {u,ü} & ^(2) = {q,g} then T = 0
      return word.length - 1 if (word =~/[qg][uü]i$/)

      # Rule 6:
      # if ^(0) = {s} & ^(1) = {i} & ^(2) = {u,ü} & ^(3) = {q,g} then T = 1
      return word.length - 2 if (word =~/[qg][uü]is$/)

      # Rule 7:
      # if ^(0) = {i,u} & ^(1) = {a,e,i,o,u} then T = 1
      return word.length - 2 if (word =~/[aeiou][iu]$/)

      # if ^(0) = {i,u} & ^(1) != {a,e,i,o,u} then T = 0
      return word.length - 1 if (word =~/[^aeiou][iu]$/)

      # Rule 8:
      # if ^(0) = {s} & ^(1) = {i,u} & ^(2) = {a,e,i,o,u} then T = 2
      return word.length - 3 if (word =~/[aeiou][iu]s$/)

      # Rule 9:
      # if ^(0) = {s} & ^(1) = {i,u} & ^(2) != {a,e,i,o,u} then T = 2
      return word.length - 2 if (word =~/[^aeiou][iu]s$/)

      # Rule 10:
      # if ^(0) = {e} & ^(1) = {u} & ^(2) = {q} & ^(3) = {r} & ^(4) = {o} &
      # ^(4) = {p} then T = 0
      return word.length - 1 if word == "porque"

      # Rule 11
        # if ^(0) = {e} & ^(1) = {u} & ^(2) = {qg} & ^(3) = {a,e,i,o,u} then T = 3
        return word.length - 4 if (word =~/[aeiou][qg]ue$/)
        # if ^(0) = {e} & ^(1) = {u} & ^(2) = {qg} & ^(3) != {a,e,i,o,u} then T = 4
        return word.length - 5 if (word =~/[^aeiou][qg]ue$/)

      # Rule 12
        # if ^(0)={e} & ^(1)={e} & ^(2)={u} & ^(3)={qg} & ^(4)={aeiou} then T = 4
        return word.length - 5 if (word =~/[aeiou][qg]ues$/)
        # if ^(0)={e} & ^(1)={e} & ^(2)={u} & ^(3)={qg} & ^(4)!={aeiou} then T = 5
        return word.length - 6 if (word =~/[^aeiou][qg]ues$/)

      # Rule 13:
      # if ^(0) = {a,e,i,o,u} & ^(2) = {i,u} & ^(3) = {a,e,i,o,u} then T = 2
      return word.length - 3 if (word =~/[aeiou][iu][aeiou]$/)
        
      # Rule 14:
      # if ^(0) & ^(3) = {a,e,i,o,u} & ^(2) = {i,u} & ^(1) != {a,e,i,o,u} &
      # ^(4) != {q,g} then T = 3
      return word.length - 4 if (word =~/[^qg][aeiou][iu][^aeiou][aeiou]$/)

      # Rule 15:
      # if ^(0) = {s} & ^(1) & ^(4) = {a,e,i,o,u} & ^(3) = {i,u} &
      # ^(2) != {a,e,i,o,u} & ^(5) != {q,g} then T = 4
      return word.length - 5 if (word =~/[^qg][aeiou][iu][^aeiou][aeiou]$/)

      # Rule 16:
      # if ^(0) = {a,e,o} & ^(1) = cons & ^(2) = {n} & ^(3) = {i,u} &
      # ^(4) = {a,e,i,o,u} then T = 3
      # consts = 'bdfghjklmnñpqrstvxyz'
      return word.length - 4 if (word =~/[aeiou][iu]n[bdfghjklmnñpqrstvxyz][aeo]$/)

      # Rule 17:
      matches = word.enum_for(:scan,/a|e|i|o|u/).map { Regexp.last_match.begin(0) }
      if matches.length >= 2
        k = matches[-2]
        v = ['a', 'e', 'i', 'o', 'u']
        if ['i', 'u'].include?(word[k]) && v.include?(word[k - 1]) && !v.include?(word[k + 1])
          if k - 2 < 0
            return 0
          end
          if ['q', 'g'].include?(word[k - 2])
            return k - 1
          end
        end
      end

      # Rule 18:
      # if ^(0) = {m} & ^(1) = {e} & ^(2) = {u} & ^(3) = {q} then T = 1
      return word.length - 2 if word == "quem"

      # Rule 19:
      # Penultimate vowel of the word
      matches = word.enum_for(:scan,/a|e|i|o|u/).map { Regexp.last_match.begin(0) }
      if matches.length >= 2
        return matches[-2]
      end
      return -1
    end

  end

end
end
end
