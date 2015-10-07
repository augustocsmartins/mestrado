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
module Helpfulness
module PT
module CohMetrixPort
module Metrics

  class Count

    DECIMAL_ROUND = 3

    attr_reader :text, :paragraphs, :sentences, :words, :frequencies, :tagset

    def initialize(text)
      @text                = text.dup
      @paragraphs          = text.split(/\n\s*\n\s*/)
      @tagset              = TagSet.new(@text)

      @tagged_words        = @tagset.tagged_words
      @words               = @tagset.all_words

      sentence_detector    = OpenNLP::SentenceDetectorME.new("pt-sent.bin")
      @sentences           = sentence_detector.sent_detect(@text).to_a

      @frequencies         = {}
      @frequencies.default = 0
      count_words
    end

    # The total number of syllables in the text sample. Just for completeness.
    def number_of_syllables
      return (@words.map { |word| Helpfulness::PT::Syllable::syllables( word ).length }.inject(:+).to_f) || 0
    end

    def mean_of_syllables_per_word
      return (number_of_syllables.to_f / number_of_words.to_f) || 0
    end

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 1. Índice Flesch: O Índice de Legibilidade de Flesch busca uma correlação entre tamanhos médios de palavras e sentenças e a facilidade de leitura.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # ILF = 248.835 - [1.015 x (Número de palavras por sentença)] - [84.6 x (Número de sílabas do texto / Número de palavras do texto)]
    # São identificadas quatro faixas de dificuldades de leitura para a língua Portuguesa:
    #  textos classificados como muito fáceis (índice entre 75 - 100), que seriam adequados para leitores com nível de escolaridade até a quarta série do ensino fundamental;
    #  textos fáceis (índice entre 50 - 75), que seriam adequados a alunos com escolaridade até a oitava série do ensino fundamental;
    #  textos difíceis (índice entre 25 - 50), que seriam adequados para alunos cursando o ensino médio ou universitário e;
    #  textos muitos difíceis (índice entre 0 - 25), que em geral seriam adequados apenas para áreas acadêmicas específicas.
    def flesch
      return ((248.835 - (1.015 * mean_of_words_per_sentence) - (84.6 * mean_of_syllables_per_word)).round(DECIMAL_ROUND)) || 0
    end
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 2. Número de Palavras: Número de palavras do texto.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "Acessório utilizado por adolescentes, o boné é um dos itens que compõem a vestimenta idealizada pela proposta."
    # O exemplo possui 17 palavras.
    def number_of_words
      @words.length.to_f
    end
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 3. Número de Sentenças: Número de sentenças de um texto.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "O acessório polêmico entrou no projeto, de autoria do senador Cícero Lucena (PSDB-PB), graças a uma emenda aprovada na Comissão de Educação do Senado em outubro. Foi o senador Flávio Arns (PT-PR) quem sugeriu a inclusão da peça entre os itens do uniforme de alunos dos ensinos Fundamental e Médio nas escolas municipais, estaduais e federais. Ele defende a medida como forma de proteger crianças e adolescentes dos males provocados pelo excesso de exposição aos raios solares. Se a idéia for aprovada, os estudantes receberão dois conjuntos anuais, completados por calçado, meias, calça e camiseta."
    # O exemplo possui 4 sentenças.
    def number_of_sentences
      @sentences.length.to_f
    end

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 4. Número de Parágrafos: Número de parágrafos de um texto. Consideramos como parágrafos somente a quebra de linha (não identações).
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "No caso do Jeca Tatu, o verme que o deixou doente foi outro: o Ancylostoma. A larva desse verme vive no solo e penetra diretamente na pele. Só o contrai quem anda descalço na terra contaminada por fezes humanas. Se não se tratar, a pessoa fica fraca, sem ânimo e com a pele amarelada. Daí a doença ser também conhecida como amarelão.\n
    #   Os vermes – também chamados de helmintos – são parasitos, animais que, em geral, dependem da relação com outros seres para viver. Eles podem se hospedar no organismo de diversos animais, como bois, aves e peixes. Por isso, podemos também contraí-los comendo carnes cruas ou mal cozidas."
    # O exemplo possui 2 parágrafos.
    def number_of_paragraphs
      @paragraphs.length.to_f
    end

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 5. Palavras por Sentenças: Número de palavras dividido pelo número de sentenças.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "O acessório polêmico entrou no projeto, de autoria do senador Cícero Lucena (PSDB-PB), graças a uma emenda aprovada na Comissão de Educação do Senado em outubro. Foi o senador Flávio Arns (PT-PR) quem sugeriu a inclusão da peça entre os itens do uniforme de alunos dos ensinos Fundamental e Médio nas escolas municipais, estaduais e federais. Ele defende a medida como forma de proteger crianças e adolescentes dos males provocados pelo excesso de exposição aos raios solares. Se a idéia for aprovada, os estudantes receberão dois conjuntos anuais, completados por calçado, meias, calça e camiseta."
    # Neste exemplo o número de palavras é 95 e o número de sentenças é 4. Portanto, o número de palavras por sentenças é 23,75.
    def mean_of_words_per_sentence
      return (number_of_words.to_f / number_of_sentences.to_f) || 0
    end

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 6. Sentenças por Parágrafos: Número de sentenças dividido pelo número de parágrafos.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    def sentences_per_paragraph
      return (number_of_sentences.to_f / number_of_paragraphs.to_f) || 0
    end

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 7. Sílabas por Palavra de Conteúdo: Número médio de sílabas por palavras de conteúdo (substantivos, verbos, adjetivos e advérbios).
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "Acessório utilizado por adolescentes, o boné é um dos itens que compõem a vestimenta idealizada pela proposta."
    # As palavras em negrito são as palavras de conteúdo. Portanto, número de sílabas por palavras de conteúdo do exemplo é 3,6.
    def syllables_per_content_word
      content_tokens = @tagged_words.select { |word| @tagset.is_content_word(word) }
      content_words  = content_tokens.map { |word| word[0] }
      syllables      = content_words.map { |word| Helpfulness::PT::Syllable::syllables( word ).length }
      return (syllables.inject(:+).to_f / content_words.length.to_f) || 0
    end

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 8. Incidência de Verbos: Incidência de verbos em um texto.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "Acessório utilizado por adolescentes, o boné é um dos itens que compõem a vestimenta idealizada pela proposta."
    # No exemplo, as palavras em negrito são os verbos. Com 3 verbos e 17 palavras, a incidência de verbos é 235,29 (número de verbos/(número de palavras /1000)).
    def verb_count
      @tagged_words.select { |word| @tagset.is_verb(word) }.length
    end

    def verb_incidence
      return (verb_count.to_f / (number_of_words.to_f / 1000)) || 0
    end

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 9. Incidência de Substantivos: Incidência de substantivos em um texto.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "Acessório utilizado por adolescentes, o boné é um dos itens que compõem a vestimenta idealizada pela proposta."
    # No exemplo, as palavras em negrito são substantivos. Com 6 substantivos e 17 palavras, a incidência de substantivos é 352,94 (número de substantivos/(número de palavras /1000)).
    def noun_count
      @tagged_words.select { |word| @tagset.is_noun(word) }.length
    end

    def noun_incidence
      return (noun_count.to_f / (number_of_words.to_f / 1000)) || 0
    end

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 10. Incidência de Adjetivos: Incidência de adjetivos em um texto.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "O acessório polêmico entrou no projeto, de autoria do senador Cícero Lucena (PSDB-PB), graças a uma emenda aprovada na Comissão de Educação do Senado em outubro. Foi o senador Flávio Arns (PT-PR) quem sugeriu a inclusão da peça entre os itens do uniforme de alunos dos ensinos Fundamental e Médio nas escolas municipais, estaduais e federais. Ele defende a medida como forma de proteger crianças e adolescentes dos males provocados pelo excesso de exposição aos raios solares. Se a idéia for aprovada, os estudantes receberão dois conjuntos anuais, completados por calçado, meias, calça e camiseta."
    # No exemplo, as palavras em negrito são adjetivos. Com 11 adjetivos e 95 palavras, a incidência de adjetivos é 115,78 (número de adjetivos/(número de palavras/1000)).
    def adjective_count
      @tagged_words.select { |word| @tagset.is_adjective(word) }.length
    end

    def adjective_incidence
      return (adjective_count.to_f / (number_of_words.to_f / 1000)) || 0
    end

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 11. Incidência de Advérbios: Incidência de advérbios em um texto.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "- Não podemos acrescentar nenhuma despesa a mais no nosso orçamento. Já não temos recursos suficientes para a manutenção das escolas, por exemplo, e também precisamos valorizar o magistério - justifica a diretora do Departamento Pedagógico da SEC, Sonia Balzano."
    # No exemplo, as palavras em negrito são advérbios. Com 2 advérbios e 38 palavras, a incidência de advérbios é 52,63 (número de advérbios/(número de palavras/1000)).
    def adverb_count
      @tagged_words.select { |word| @tagset.is_adverb(word) }.length
    end

    def adverb_incidence
      return (adverb_count.to_f / (number_of_words.to_f / 1000)) || 0
    end

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 12. Incidência de Pronomes: Incidência de pronomes em um texto.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "Foi o senador Flávio Arns (PT-PR) quem sugeriu a inclusão da peça entre os itens do uniforme de alunos dos ensinos Fundamental e Médio nas escolas municipais, estaduais e federais. Ele defende a medida como forma de proteger crianças e adolescentes dos males provocados pelo excesso de exposição aos raios solares. Se a idéia for aprovada, os estudantes receberão dois conjuntos anuais, completados por calçado, meias, calça e camiseta."
    # No exemplo, as palavras em negrito são pronomes. Com 2 pronomes e 95 palavras, a incidência de pronomes é 21,05 (número de pronomes/(número de palavras/1000)).
    def pronoun_count
      @tagged_words.select { |word| @tagset.is_pronoun(word) }.length
    end

    def pronoun_incidence
      return (pronoun_count.to_f / (number_of_words.to_f / 1000)) || 0
    end

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 13. Incidência de Palavras de Conteúdo: Incidência de palavras de conteúdo em um texto. Palavras de conteúdo são substantivos, verbos, adjetivos e advérbios.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    def content_word_count
      @tagged_words.select { |word| @tagset.is_content_word(word) }.length
    end

    def content_word_incidence
      return (content_word_count.to_f / (number_of_words.to_f / 1000)) || 0
    end

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 14. Incidência de Palavras Funcionais: Incidência de palavras funcionais em um texto. Palavras funcionais são artigos, preposições, pronomes, conjunções e interjeições.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    def function_word_count
      @tagged_words.select { |word| @tagset.is_function_word(word) }.length
    end
    def function_word_incidence
      return (function_word_count.to_f / (number_of_words.to_f / 1000)) || 0
    end
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # The number of characters in the sample.
    def number_of_characters
      @text.length
    end

    # The number of different unique words used in the text sample.
    def number_of_unique_words
      @frequencies.keys.length
    end
       
    # The number of occurences of the word +word+ in the text sample.
    def number_of_occurrences(word)
      @frequencies[word]
    end

    # Return a nicely formatted report on the sample, showing most the useful
    # statistics about the text sample.
    def report
      table = Terminal::Table.new(headings: ['Basic', 'Result']) do |t|
        t << ["Number of paragraphs", number_of_paragraphs]
        t << ["Number of sentences", number_of_sentences]
        t << ["Number of words", number_of_words]
        t << ["Number of characters", number_of_characters]
        t << ["Number of syllables", number_of_syllables]

        t << :separator
        t << ["Average words per sentence", mean_of_words_per_sentence]
        t << ["Average syllables per word", mean_of_syllables_per_word]
        t << ["Average syllables per content word", syllables_per_content_word]

        t << :separator
        t << ["Verbs Ocurrencies", verb_incidence]
        t << ["Nouns Ocurrencies", noun_incidence]
        t << ["Adjective Ocurrencies", adjective_incidence]
        t << ["Adverb Ocurrencies", adverb_incidence]
        t << ["Pronoun Ocurrencies", pronoun_incidence]
        t << ["Content Word Ocurrencies", content_word_incidence]
        t << ["Function Word Ocurrencies", function_word_incidence]

        t << :separator
        t << ["Flesch score", flesch]
      end
      puts table
    end

    private
    def count_words
      @words.each do |word|
        @frequencies[word] += 1
      end
    end

  end

end
end
end
end
