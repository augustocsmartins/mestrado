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
#
#* Referências:
#* Dias-da Silva, B. C., Oliveira, M. F. d., and Moraes, H. R. d. (2002). Groundwork for the development of the brazilian portuguese wordnet. In PorTAL ’02: Proceedings of the Third International Conference on Advances in Natural Language Processing, pages 189–196, London, UK. Springer-Verlag.
#* Dias-da Silva, B. C. (2003). Human language technology research and the development of the brazilian portuguese wordnet. 17th International Congress of Linguists.
#* Dias-da Silva, B. C. (2005). A construç˜ao da base da wordnet.br: conquistas e desafios. In the Proceedings of the 3rd Workshop in Information and Human Language Technology (TIL’2005), pages 2238–2247.
#* Dias-da Silva, B. C., Di Felippo, A., and Nunes, M. G. V. (2008). The automatic mapping of princeton wordnet lexical-conceptual relations onto the brazilian portuguese wordnet database. In Chair), N. C. C., Choukri, K., Maegaard, B., Mariani, J., Odjik, J., Piperidis, S., and Tapias, D., editors, Proceedings of the Sixth International Language Resources and Evaluation (LREC’08), Marrakech, Morocco. European Language Resources Association (ELRA). http://www.lrec-conf.org/proceedings/lrec2008/.
#* Maziero, E. G., Pardo, T. A. S., Di Felipo, A. e Dias-da-Silva, B. C. (2008). A Base de Dados Lexical e a Interface Web do TeP 2.0 - Thesaurus Eletrônico para o Português do Brasil. Em Anais do VI Workshop em Tecnologia da Informação e da Linguagem Humana TIL, 2008, Vila Velha, ES.
#* Scarton, C. E. e Aluísio, S. M. (2009). Herança Automática das Relações de Hiperonímia para a Wordnet.Br. Série de Relatórios do NILC. NILC-TR-09- 10, Dezembro, 48p.
#* SCARTON, Carolina; GASPERIN, Caroline; ALUISIO, Sandra. Revisiting the readability assessment of texts in Portuguese. In: Advances in Artificial Intelligence–IBERAMIA 2010. Springer Berlin Heidelberg, 2010. p. 306-315.
#* SCARTON, Carolina Evaristo; ALUÍSIO, Sandra Maria. Análise da Inteligibilidade de textos via ferramentas de Processamento de Língua Natural: adaptando as métricas do Coh-Metrix para o Português. Linguamática, v. 2, n. 1, p. 45-61, 2010.

#http://www.linguateca.pt/floresta/BibliaFlorestal/anexo1.html
#http://www.nilc.icmc.usp.br/macmorpho/macmorpho-manual.pdf

#2.3. Categoria gramatical (nós terminais)
#símbolo   categoria
#n         nome, substantivo
#prop      nome próprio
#adj       adjectivo
#n-adj     flutuação entre substantivo e adjectivo
#v-fin     verbo finito
#v-inf     infinitivo
#v-pcp     particípio
#v-ger     gerúndio
#art       artigo
#pron-pers pronome pessoal
#pron-det  pronome determinativo
#pron-indp pronome independente (com comportamento semelhante ao nome)
#adv       advérbio
#num       numeral
#prp       preposição
#intj      interjeição
#conj-s    conjunção subordinativa
#conj-c    conjunção coordenativa

module Helpfulness
module PT
module CohMetrixPort

  class TagSet

    # Operators.
    LOGIC_OPERATORS = ['e', 'ou', 'se', 'não', 'nem', 'nenhum', 'nenhuma', 'nada', 'nunca', 'jamais', 'caso', 'desde que', 'contanto que', 'uma vez que',
                       'a menos que', 'sem que', 'a não ser que', 'salvo se', 'exceto se', 'então é porque', 'vai que', 'va que']

    NEGATIONS = ['não', 'nem', 'nenhum', 'nenhuma', 'nada', 'nunca', 'jamais']

    AND = ['e']
    OR  = ['ou']
    IF  = ['se']

    attr_reader :tokens, :part_of_speech

    # The constructor accepts the text to be analysed, and returns a report
    # object which gives access to the 
    def initialize(text)

      tagger_model = "pt-pos-perceptron.bin"
      if tagger_model == "pt-pos-maxent.bin"
        @article_tags         = ['ART']
        @verb_tags            = ['V']
        @auxiliary_verb_tags  = ['VAUX']
        @participle_tags      = ['PCP']
        @noun_tags            = ['N', 'NPROP']
        @adjective_tags       = ['ADJ']
        @adverb_tags          = ['ADV', 'ADV-KS' 'ADV-KS-REL']
        @pronoun_tags         = ['PROPESS', 'PROSUB', 'PROADJ', 'PRO-KS', 'PRO-KS-REL', ]
        @numeral_tags         = ['NUM']
        @conjunction_tags     = ['KS', 'KC']
        @preposition_tags     = ['PREP', 'PREP+PROPESS', 'PREP+ART']
        @interjection_tags    = ['IN']
        @denotative_word_tags = ['PDEN']
        @content_word_tags    = @verb_tags + @noun_tags + @adjective_tags + @adverb_tags
        @function_word_tags   = @article_tags + @preposition_tags + @pronoun_tags + @conjunction_tags + @interjection_tags

        @functions_as_noun_tags      = ['N', 'NPROP', 'PROSUB']
        @functions_as_adjective_tags = ['ADJ', 'PROADJ']
        @punctuation_tags            = ['PU']
      else
        @article_tags                = ['art']
        @finito_tags                 = ['v-fin']
        @infinitive_tags             = ['v-inf']
        @participle_tags             = ['v-pcp']
        @gerundio_tags               = ['v-ger']
        @noun_tags                   = ['n', 'prop']
        @adjective_tags              = ['adj', 'n-adj']
        @adverb_tags                 = ['adv']
        @pronoun_tags                = ['pron-pers', 'pron-indp']
        @denotative_word_tags        = ['pron-det']
        @numeral_tags                = ['num']
        @preposition_tags            = ['prp']
        @conjunction_tags            = ['conj-s', 'conj-c']
        @interjection_tags           = ['intj']
        @punctuation_tags            = ['punc']
        @functions_as_noun_tags      = ['n', 'nprop']
        @functions_as_adjective_tags = ['adj', 'n-adj']
        @verb_tags                   = @finito_tags + @infinitive_tags + @participle_tags + @gerundio_tags
        @content_word_tags           = @verb_tags + @noun_tags + @adjective_tags + @adverb_tags
        @function_word_tags          = @article_tags + @preposition_tags + @pronoun_tags + @conjunction_tags + @interjection_tags
      end

      @tagger    = OpenNLP::POSTaggerME.new(tagger_model)
      @tokenizer = OpenNLP::TokenizerME.new("pt-token.bin")

      @tokens         = @tokenizer.tokenize(text.gsub(/(\p{Punct})/," \\1 "))
      @part_of_speech = @tagger.tag(@tokens).to_a
    end

    def remove_accents(text)
      output = Iconv.iconv("ASCII//TRANSLIT", 'utf-8', text).first
      output.gsub("`|\\'|~", "").gsub("[ \t]{2,}", "").gsub("^\\s+|\\s+$", "")
    end
    # Return all non-punctuation tokens of the text in a single list.
    def all_words
      result = []
      tagged_words.each do |word|
        result << word[0] unless is_punctuation([ word[0], word[1] ])
      end
      result
    end

    # Return a list of pair (string, string), representing the
    # non-punctuation tokens not separated in sentences.
    def tagged_words
      @part_of_speech.map.with_index {|pos, i| [@tokens[i], pos] }.reject(&:nil?)
    end

    def is_denotative_word(token)
      _is_in(token, @denotative_word_tags)
    end

    # Check if a token represents an article.
    def is_article(token)
      _is_in(token, @article_tags)
    end

    # Check if a token represents a verb.
    def is_verb(token)
      _is_in(token, @verb_tags)
    end

    # Check if a token represents an auxiliary verb.
    def is_auxiliary_verb(token)
      _is_in(token, @auxiliary_verb_tags)
    end

    # Check if a token represents a verb in the participle.
    def is_participle(token)
      _is_in(token, @participle_tags)
    end

    # Check if a token represents a noun.
    def is_noun(token)
      _is_in(token, @noun_tags)
    end

    # Check if a token represents an adjective.
    def is_adjective(token)
      _is_in(token, @adjective_tags)
    end

    # Check if a token represents an adverb.
    def is_adverb(token)
      _is_in(token, @adverb_tags)
    end

    # Check if a token represents a pronoun.
    def is_pronoun(token)
      _is_in(token, @pronoun_tags)
    end

    # Check if a token represents a numeral.
    def is_numeral(token)
      _is_in(token, @numeral_tags)
    end

    # Check if a token represents a conjunction.
    def is_conjunction(token)
      _is_in(token, @conjunction_tags)
    end

    # Check if a token represents a preposition.
    def is_preposition(token)
      _is_in(token, @preposition_tags)
    end

    # Check if a token represents an interjection.
    def is_interjection(token)
      _is_in(token, @interjection_tags)
    end

    # Check if a token represents a currency value.
    def is_currency(token)
      _is_in(token, @currency_tags)
    end

    # Check if a token represents a content word.
    def is_content_word(token)
      _is_in(token, @content_word_tags)
    end

    # Check if a token represents a function word.
    def is_function_word(token)
      _is_in(token, @function_word_tags)
    end

    # Check if a token represents a word that functions as a noun.
    def functions_as_noun(token)
      _is_in(token, @functions_as_noun_tags)
    end

    # Check if a token represents a word that functions as an adjective.
    def functions_as_adjective(token)
      _is_in(token, @functions_as_adjective_tags)
    end

    # Check if a token represents a punctuation mark.
    def is_punctuation(token)
      _is_in(token, @punctuation_tags)
    end

    private

      # Return true if the token's tag is in the list, and false otherwise.
      def _is_in(token, list)
        return false unless list
        list.include?(token[1])
      end

  end

end
end
end
