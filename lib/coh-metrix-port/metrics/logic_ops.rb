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
module Helpfulness
module PT
module CohMetrixPort
module Metrics

  module LogicOps

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 15. Operadores Lógicos: Incidência de operadores lógicos em um texto. Consideramos como operadores lógicos: e, ou, se, negações e um número de condições.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "- Não podemos acrescentar nenhuma despesa a mais no nosso orçamento. Já não temos recursos suficientes para a manutenção das escolas, por exemplo, e também precisamos valorizar o magistério - justifica a diretora do Departamento Pedagógico da SEC, Sonia Balzano."
    # No exemplo, as palavras em negrito são operadores lógicos. Como há 4 operadores lógicos e 38 palavras a incidência de operadores lógicos é 105,26 (número de operadores lógicos/(número de palavras/1000)).
    # ol <- c("e", "ou", "se", "não", "nem", "nenhum", "nenhuma", "nada", "nunca", "jamais", "caso", "desde que", "contanto que", "uma vez que", "a menos que", "sem que", "a não ser que", "salvo se", "exceto se", "então é porque", "fosse", "vai que", "va que")

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 16. Incidência de E: Incidência do operador lógico e em um texto.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 17. Incidência de OU: Incidência do operador lógico ou em um texto.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 18. Incidência de SE: Incidência do operador lógico se em um texto (desconsideramos o se quando este é pronome).
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 19. Negações: Incidência de Negações. Consideramos como negações: não, nem, nenhum, nenhuma, nada, nunca e jamais.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "- Não podemos acrescentar nenhuma despesa a mais no nosso orçamento. Já não temos recursos suficientes para a manutenção das escolas, por exemplo, e também precisamos valorizar o magistério - justifica a diretora do Departamento Pedagógico da SEC, Sonia Balzano."
    # No exemplo aparecem 3 negações. Como o mesmo possui 38 palavras a incidência de negações é 78,95 (número de negações/(número de palavras/1000)).

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 20. Frequências: Média de todas as frequências das palavras de conteúdo (substantivos, verbos, advérbios e adjetivos) encontradas no texto. 
    # O valor da frequência das palavras é retirado da lista de frequências do córpus Banco de Português (BP), compilado por Tony Sardinha da PUC-SP.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "Acessório utilizado por adolescentes, o boné é um dos itens que compõem a vestimenta idealizada pela proposta."
    # As palavras em negrito no exemplo são as palavras de conteúdo. De acordo com a lista frequências do BP, o valor médio das frequências dessas palavras é 32432,7.

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 21. Mínimo Frequências: Primeiramente identificamos a menor frequência dentre todas as palavras de conteúdo (substantivos, verbos, advérbios e adjetivos) em cada sentença. 
    # Depois, calculamos uma média de todas as frequências mínimas. A palavra com a menor frequência é a mais rara da sentença.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "Acessório utilizado por adolescentes, o boné é um dos itens que compõem a vestimenta idealizada pela proposta."
    # No exemplo a palavra mais rara desta sentença, de acordo com o BP, está sublinhada. O valor obtido para esta palavra foi 773. Como este exemplo possui somente uma sentença o valor da métrica é o menos da palavra mais rara desta sentença.


    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 22. Incidência de Pronomes Pessoais: Incidência de pronomes pessoais em um texto. Consideramos como pronomes pessoais: eu, tu, ele/ela, nós, nós, eles/elas, você e vocês.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "O acessório polêmico entrou no projeto, de autoria do senador Cícero Lucena (PSDB-PB), graças a uma emenda aprovada na Comissão de Educação do Senado em outubro. Foi o senador Flávio Arns (PT-PR) quem sugeriu a inclusão da peça entre os itens do uniforme de alunos dos ensinos Fundamental e Médio nas escolas municipais, estaduais e federais. Ele defende a medida como forma de proteger crianças e adolescentes dos males provocados pelo excesso de exposição aos raios solares. Se a idéia for aprovada, os estudantes receberão dois conjuntos anuais, completados por calçado, meias, calça e camiseta."
    # Este exemplo possui 1 pronome pessoal (em negrito). Como este texto possui 95 palavras, a incidência de pronomes pessoais é 10,52 (número de pronomes pessoais/(número de palavras/1000)).

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 23. Hiperônimos de Verbos: Para cada verbo soma-se o número de hiperônimos e divide o total pelo número de verbos. Hiperonímia é uma relação, definida na Wordnet.Br (Dias-da-Silva et. al., 2002; Dias-da-Silva, 2003; Dias-da-Silva, 2005; Dias-da-Silva et. al., 2008 e Scarton e Aluísio, 2009), de "super tipo de". Por exemplo, o verbo "sonhar" possui como hiperônimos "fantasiar" e "mentalizar".
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 24. Pronomes por Sintagmas: Média do número de pronomes que aparecem em um texto pelo número de sintagmas.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 25. Type/Token: Número de palavras únicas dividido pelo número de tokens dessas palavras. Cada palavra única é um tipo. Cada instância desta palavra é um token.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Por exemplo, se a palavra cachorro aparece 7 vezes em um texto, seu tipo (type) é 1 e seu token é 7. Calculamos esta métrica somente para palavras de conteúdo (substantivos, verbos, advérbios e adjetivos).
    # Observação: Não usamos lematização de palavras, ou seja, a palavra cachorro é considerada diferente de cachorros.

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 26. Incidência de Sintagmas: Incidência de sintagmas nominais por 1000 palavras.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "[Acessório] utilizado [por adolescentes], [o boné é um dos itens que] compõem [a vestimenta] idealizada [pela proposta]."
    # No exemplo os trechos entre colchetes são os sintagmas encontrados no texto (6 sintagmas). Como o texto possui 17 palavras a incidência de sintagmas é 352,94 (número de sintagmas/(número de palavras/1000)).


    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 27. Modificadores por Sintagmas: Média do número de modificadores por sintagmas nominais. Consideramos como modificadores adjetivos, advérbios e artigos que participam de um sintagma.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "[Acessório] utilizado [por adolescentes], [o boné é um dos itens que] compõem [a vestimenta] idealizada [pela proposta]."
    # No exemplo as palavras sublinhadas são os modificadores dos sintagmas. Como o texto possui 6 sintagmas e 3 modificadores, o valor desta métrica é 0,5 para este exemplo.


    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 28. Palavras Antes de Verbos Principais: Média de palavras antes de verbos principais na cláusula principal da sentença. Segundo a documentação do Coh-Metrix é um bom índice para avaliar a carga da memória de trabalho.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    # "Acessório utilizado por adolescentes, o boné é um dos itens que compõem a vestimenta idealizada pela proposta."
    # Neste exemplo, o verbo principal está em negrito. Como este texto possui uma sentença o valor desta métrica corresponde ao valor de palavras antes do verbo desta única sentença, que, neste caso é 1 (a palavra acessório é a única que antecede o verbo).



    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 38. Ambiguidade de Verbos: Para cada verbo do texto soma-se o número de sentidos apresentados no TEP (Maziero et. al., 2008) e divide o total pelo número de verbos.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 39. Ambiguidade de Substantivos: Para cada substantivo do texto soma-se o número de sentidos apresentados no TEP (Maziero et. al., 2008) e divide o total pelo número de substantivos.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 40. Ambiguidade de Adjetivos: Para cada adjetivo do texto soma-se o número de sentidos apresentados no TEP (Maziero et. al., 2008) e divide o total pelo número de adjetivos.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 41. Ambiguidade de Advérbios: Para cada advérbio do texto soma-se o número de sentidos apresentados no TEP (Maziero et. al., 2008) e divide o total pelo número de advérbios.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 42. Sobreposição de Argumentos Adjacentes: Proporção de sentenças adjacentes que compartilham um ou mais argumentos (substantivos, pronomes ou sintagmas nominais).
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "(1) Dentro do lago, existem peixes, como a traíra e o dourado, além da palometa, um tipo de piranha. (2) Ela é uma espécie carnívora que se alimenta de peixes. (3) No verão, elas ficam mais próximas das margens da barragem, atraídas pela movimentação das pessoas e por restos de comida que alguns turistas deixam na água quando lavam os pratos."
    # Para este exemplo temos que as sentenças (1) e (2) compartilham um substantivo (peixes) e, portanto, este par incrementa 1 no valor de correferência. Como também há dois pares de sentenças adjacentes ((1) com (2) e (2) com (3)), o valor final da métrica é 1/2 = 0,5.


    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 43. Sobreposição de Argumentos: Proporção de todos os pares de sentenças que compartilham um ou mais argumentos.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "(1) Dentro do lago, existem peixes, como a traíra e o dourado, além da palometa, um tipo de piranha. (2) Ela é uma espécie carnívora que se alimenta de peixes. 
    #   (3) No verão, elas ficam mais próximas das margens da barragem, atraídas pela movimentação das pessoas e por restos de comida que alguns turistas deixam na água quando lavam os pratos."
    # Para este exemplo temos os pares de sentenças (1) com (2), (1) com (3) e (2) com (3). Como somente o par (1) com (2) compartilham um substantivo (peixes) o valor final da métrica é 1/3 = 0,333.


    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 44. Sobreposição de Radicais de palavras Adjacentes: Proporção de sentenças adjacentes que compartilham radicais.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "(1) dentr do lag , exist peix , com a trar e o dour , além da palomet , um tip de piranh . (2) ela é uma espéci carnvor que se aliment de peix . (3) no doming , pescador vão compet par ver quem pesc mais piranh ."
    # Neste exemplo, para sentenças adjacentes, temos que (1) e (2) compartilham o radical peix. Como há dois pares de sentenças adjacentes e somente um compartilha um radical, então o resultado da métrica é 1/2 = 0,5.


    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 45. Sobreposição de Radicais de palavras: Proporção de todos os pares de sentenças que compartilham radicais.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "(1) dentr do lag , exist peix , com a trar e o dour , além da palomet , um tip de piranh . (2) ela é uma espéci carnvor que se aliment de peix . (3) no doming , pescador vão compet par ver quem pesc mais piranh ."
    # Neste exemplo, além de (1) e (2), (1) e (3) também compartilham um radical (piranh). Então, como são três os possíveis pares, o valor final da métrica é 2/3 = 0,667.


    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 46. Sobreposição de Palavras de conteúdo: Proporção de sentenças adjacentes que compartilham palavras de conteúdo.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 47. Referência Anafórica Adjacente: Proporção de referências anafóricas entre sentenças adjacentes.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # Exemplo:
    #  "Dentro do lago, existem peixes, como a traíra e o dourado, além da palometa, um tipo de piranha. Ela é uma espécie carnívora que se alimenta de peixes."
    # Neste exemplo, os “candidatos” a resolver a anáfora pronominal ela são traíra, palometa e piranha. Como há três "candidatos" e uma sentenças adjacentes, o valor final da métrica é 3/1 = 3.

    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # 48. Referência Anafórica: Proporção de referências anafóricas que se referem a um constituinte presente em até cinco sentenças anteriores.
    # --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



  end

end
end
end
end