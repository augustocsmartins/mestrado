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
module Hotel

  begin
    options = {host: "localhost", username: "root", password: "", database: "base16soft_manager"}
    @connection = Mysql2::Client.new(:host     => options[:host], 
                                     :username => options[:username], 
                                     :password => options[:password], 
                                     :port     => options[:port] || "3306", 
                                     :database => options[:database], 
                                     :socket   => "/tmp/mysql.sock",
                                     :encoding => 'utf8')
  rescue => e
    STDERR.puts 'cannot connect MySQL!!'
    STDERR.puts e.to_s
    exit 1
  end

  # tabela 1
  def Hotel.number_of_opinons_by_location
    results = @connection.query("SELECT l.name as location_name, 
                                  (select count(*) from manager_hotels_eval where location_id=r.location_id) as total_hotels,
                                  count(*) as total_opinions 
                                  FROM manager_hotel_reviews_eval r LEFT JOIN manager_locations l ON r.location_id=l.id 
                                  GROUP BY r.location_id
                                  ORDER BY l.name")

    rows = []
    total_opinions = 0
    total_hotels = 0
    results.each do |row|
      rows << [row["location_name"], row["total_hotels"], row["total_opinions"], 0.0]
      total_opinions = total_opinions + row["total_opinions"]
      total_hotels = total_hotels + row["total_hotels"]
    end
    # calcula coluna de a porcentagem
    rows.each { |i| i[3] = ((i[2].to_f * 100)/total_opinions).round(2)}

    table = Terminal::Table.new(headings: ['Cidade', 'Número de Hotéis', 'Número de Opiniões', '%'], rows: rows) do |t|
      t << :separator
      t << ['Total', total_hotels, total_opinions, 100]
    end
    puts table

    return rows
  end

  # tabela 2
  def Hotel.number_of_hotels_by_number_of_reviews
    results = @connection.query("SELECT count(*) as total_opinions 
                                  FROM manager_hotel_reviews_eval
                                  GROUP BY hotel_id
                                  ORDER by total_opinions")

    rows = []
    total_hotels = 0
    lte_10, gte_10_lte_30, gte_30_lte_100, gte_100 = [0,0,0,0]

    results.each do |row|
      if row["total_opinions"] <= 10
        lte_10 = lte_10 + 1
      elsif row["total_opinions"] > 10 && row["total_opinions"] <= 30
        gte_10_lte_30 = gte_10_lte_30 + 1
      elsif row["total_opinions"] > 30 && row["total_opinions"] <= 100
        gte_30_lte_100 = gte_30_lte_100 + 1
      elsif row["total_opinions"] > 100
        gte_100 = gte_100 + 1
      end
      total_hotels = total_hotels + 1
    end
    rows << ["N <= 10", lte_10, 0.0]
    rows << ["10 < N <= 30", gte_10_lte_30, 0.0]
    rows << ["30 < N <= 100", gte_30_lte_100, 0.0]
    rows << ["N > 100", gte_100, 0.0]

    # calcula coluna de a porcentagem
    rows.each { |i| i[2] = ((i[1].to_f * 100)/total_hotels).round(2)}

    table = Terminal::Table.new(headings: ['Número de Opiniões (N)', 'Número de Hotéis', '%'], rows: rows) do |t|
      t << :separator
      t << ['Total', total_hotels, 100]
    end
    puts table

    return rows
  end

  # tabela 3
  def Hotel.number_of_opinons_by_helpfulness
    results = @connection.query("SELECT helpful_vote, count(*) as total_opinions 
                                    FROM manager_hotel_reviews_eval
                                    GROUP BY helpful_vote")

    rows = []
    total_opinions = 0
    total_grouped_opinions = 0
    results.each do |row|
      if row["helpful_vote"] < 7
        rows << [row["helpful_vote"], row["total_opinions"], 0.0]
      else
        total_grouped_opinions = total_grouped_opinions + row["total_opinions"]
      end
      total_opinions = total_opinions + row["total_opinions"]
    end
    rows << [7, total_grouped_opinions, 0.0]

    # calcula coluna de a porcentagem
    rows.each { |i| i[2] = ((i[1].to_f * 100)/total_opinions).round(2)}

    table = Terminal::Table.new(headings: ['Votos de Utilidade', 'Número de Opiniões', '%'], rows: rows) do |t|
      t << :separator
      t << ['Total', total_opinions, 100]
    end
    puts table

    return rows
  end

  def Hotel.setup_basics
    result = @connection.query("SELECT AVG(rating) as rating_average FROM manager_hotel_reviews_reduced
                                  WHERE id IN (SELECT review_id from random_reviews);").first

    #result = @connection.query("SELECT AVG(rating) as rating_average FROM manager_hotel_reviews_reduced;").first

    rating_average = BigDecimal.new(result["rating_average"])
    puts "AVG Rating: #{(rating_average.truncate(3)).to_s('F')}"

    results = @connection.query("SELECT * FROM manager_hotel_reviews_reduced
                                  WHERE id IN (SELECT review_id from random_reviews);")

    #results = @connection.query("SELECT * FROM manager_hotel_reviews_reduced")

    CSV.open("#{File.dirname(__FILE__)}/../data/hotel_basics_sample.csv", "wb") do |csv|
      csv << ["numvotes", "interval", "level", "triptype", "sleepquality", "service", "value", "rooms", "cleanliness", "location"]
      results.each do |row|
        csv << [(row["helpful_vote"].to_i > 10 ? 10 : row["helpful_vote"]), 
                (row["published_date"] - row["user_travel_date"]).to_i,
                (row["rating"].to_f - rating_average.truncate(3)).to_s('F'), 

                (row["user_trip_type"]),
                (row["hotel_sleep_quality"] / 10).to_i,
                (row["hotel_service"] / 10).to_i,
                (row["hotel_value"] / 10).to_i,
                (row["hotel_rooms"] / 10).to_i,
                (row["hotel_cleanliness"] / 10).to_i,
                (row["hotel_location"] / 10).to_i]

        puts "#{row["helpful_vote"]}, #{(row["published_date"] - row["user_travel_date"]).to_i}, #{(row["rating"].to_f - rating_average.truncate(3)).to_s('F')}"
      end
    end

  end

  def Hotel.setup_stylistics
    results = @connection.query("SELECT * FROM manager_hotel_reviews_reduced
                                  WHERE id IN (SELECT review_id from random_reviews);")

    #results = @connection.query("SELECT * FROM manager_hotel_reviews_reduced;")

    readability = Helpfulness::PT::CohMetrixPort::Readability.new

    CSV.open("#{File.dirname(__FILE__)}/../data/hotel_stylistics_sample.csv", "wb") do |csv|
      csv << ["numvotes", "fleschsc", "numsente", "nunwords", "nunsylla", "meanwsen", "meansypw", 
              "verb_cnt", "noun_cnt", "adjc_cnt", "advb_cnt", "pron_cnt", "verb_inc", "noun_inc", "adjc_inc", "advb_inc", "pron_inc"]

      results.each do |row|
        basic_counts = readability.basic_counts(row["description"])
        numvotes = (row["helpful_vote"].to_i > 10 ? 10 : row["helpful_vote"])

        numsente = basic_counts.number_of_sentences.to_i
        nunwords = basic_counts.number_of_words.to_i
        nunsylla = basic_counts.number_of_syllables.to_i
        meanwsen = basic_counts.mean_of_words_per_sentence.to_f.round(2)
        meansypw = basic_counts.mean_of_syllables_per_word.to_f.round(2)

        verb_cnt = basic_counts.verb_count
        noun_cnt = basic_counts.noun_count
        adjc_cnt = basic_counts.adjective_count
        advb_cnt = basic_counts.adverb_count
        pron_cnt = basic_counts.pronoun_count

        vic = basic_counts.verb_incidence
        verb_inc = (vic.nan? ? 0 : vic).round(2)

        nic = basic_counts.noun_incidence
        noun_inc = (nic.nan? ? 0 : nic).round(2)

        aic = basic_counts.adjective_incidence
        adjc_inc = (aic.nan? ? 0 : aic).round(2)

        dic = basic_counts.adverb_incidence
        advb_inc = (dic.nan? ? 0 : dic).round(2)

        pic = basic_counts.pronoun_incidence
        pron_inc = (pic.nan? ? 0 : pic).round(2)

        bcf = basic_counts.flesch
        fleschsc = (bcf.nan? || bcf < 0 ? 0 : (bcf > 100 ? 100 : bcf)).to_f.round(2)

        csv << [numvotes, fleschsc, numsente, nunwords, nunsylla, meanwsen, meansypw, 
                verb_cnt, noun_cnt, adjc_cnt, advb_cnt, pron_cnt, verb_inc, noun_inc, adjc_inc, advb_inc, pron_inc]

        table = Terminal::Table.new(headings: ['Basic', 'Result']) do |t|
          t << ["Number of Votes", numvotes]
          t << :separator
          t << ["Number of Sentences", numsente]
          t << ["Number of Words", nunwords]
          t << ["Number of Syllables", nunsylla]
          t << ["Average words per sentence", meanwsen]
          t << ["Average syllables per word", meansypw]

          t << :separator
          t << ["Verbs Count", verb_cnt]
          t << ["Nouns Count", noun_cnt]
          t << ["Adjective Count", adjc_cnt]
          t << ["Adverb Count", advb_cnt]
          t << ["Pronoun Count", pron_cnt]

          t << :separator
          t << ["Verbs Incidence", verb_inc]
          t << ["Nouns Incidence", noun_inc]
          t << ["Adjective Incidence", adjc_inc]
          t << ["Adverb Incidence", advb_inc]
          t << ["Pronoun Incidence", pron_inc]

          t << :separator
          t << ["Flesch score", fleschsc]
        end
        puts table

      end
    end

  end

  def Hotel.setup_lsa
    stopwords_pt = File.read("#{File.dirname(__FILE__)}/models/stopwords_portugues.txt").lines.map(&:split)
    filter  = Stopwords::Filter.new(stopwords_pt.join(" ").split(" "))
    stemmer = Lingua::Stemmer.new(:language => "pt", :encoding => "UTF_8")

    results = @connection.query("SELECT id, helpful_vote, description FROM manager_hotel_reviews_reduced
                                  where id IN (SELECT review_id from random_reviews);")

    #results = @connection.query("SELECT id, helpful_vote, description FROM manager_hotel_reviews_reduced;")

    CSV.open("#{File.dirname(__FILE__)}/../data/hotel_sdv_sample.csv", "wb") do |csv|
      csv << ["numvotes", "description"]

      results.each do |row|
        tagset = Helpfulness::PT::CohMetrixPort::TagSet.new(row["description"].downcase.gsub("\+", " "))

        content_tokens = tagset.tagged_words.select { |word| tagset.is_content_word(word) }
        content_words  = content_tokens.map { |word| word[0] }

        filtered_opinion = filter.filter(content_words)
        #filtered_opinion = filtered_opinion.map { |word| stemmer.stem(tagset.remove_accents(word)) if word.length > 2 }
        filtered_opinion = filtered_opinion.map { |word| tagset.remove_accents(word) if word.length > 3 }

        csv << [(row["helpful_vote"].to_i > 10 ? 10 : row["helpful_vote"]), filtered_opinion.join(" ")]

        puts "#{row["helpful_vote"]}, #{filtered_opinion.join(" ")}"
      end
    end

  end


#        query_ancestor = "REPLACE INTO manager_hotel_reviews_basics(review_id, helpful_vote, published_travel_interval, 
#                                                                   trip_type_friends, trip_type_couple, trip_type_family, trip_type_business, trip_type_single,
#                                                                   extremeness_level, hotel_sleep_quality, hotel_service, hotel_value, hotel_rooms, hotel_cleanliness, hotel_location)
#                          VALUES ('#{row["id"]}', '#{(row["helpful_vote"].to_i > 10 ? 10 : row["helpful_vote"])}', 
#                                  DATEDIFF('#{row["published_date"]}', '#{row["user_travel_date"]}'),
#                                  '#{row["user_trip_type"] == "amigos" ? 1 : 0}', '#{row["user_trip_type"] == "casal" ? 1 : 0}', '#{row["user_trip_type"] == "familia" ? 1 : 0}',
#                                  '#{row["user_trip_type"] == "negocios" ? 1 : 0}', '#{row["user_trip_type"] == "sozinho" ? 1 : 0}',
#                                  '#{row["rating"] - rating_average}', '#{(row["hotel_sleep_quality"] > 0 ? 1 : 0)}', '#{(row["hotel_service"] > 0 ? 1 : 0)}',
#                                  '#{(row["hotel_value"] > 0 ? 1 : 0)}', '#{(row["hotel_rooms"] > 0 ? 1 : 0)}', 
#                                  '#{(row["hotel_cleanliness"] > 0 ? 1 : 0)}', '#{(row["hotel_location"] > 0 ? 1 : 0)}');"
#        insert = @connection.query(query_ancestor)


##
 #        query_ancestor = "REPLACE INTO manager_hotel_reviews_stylistics(review_id, helpful_vote, number_of_paragraphs, number_of_sentences, number_of_words,
 #                                number_of_characters, number_of_syllabes, mean_words_sentences, mean_syllabes_words, mean_syllabes_content_words, 
 #                                verbs_occur, nouns_occur, adjective_occur, adverb_occur, pronoun_occur, content_word_occur, function_word_occur, flesch_score)
 #                          VALUES ('#{row["id"]}', '#{row["helpful_vote"]}', 
 #                                  '#{number_of_paragraphs.to_i}',
 #                                  '#{number_of_sentences.to_i}',
 #                                  '#{number_of_words.to_i}', 
 #                                  '#{number_of_characters.to_i}',
 #                                  '#{number_of_syllables.to_i}',
 #                                  '#{(mean_of_words_per_sentence.nan? ? 0 : mean_of_words_per_sentence.to_f)}', 
 #                                  '#{(mean_of_syllables_per_word.nan? ? 0 : mean_of_syllables_per_word.to_f)}', 
 #                                  '#{(syllables_per_content_word.nan? ? 0 : syllables_per_content_word.to_f)}', 
 #                                  '#{(verb_incidence.nan? ? 0 : verb_incidence.to_f)}', 
 #                                  '#{(noun_incidence.nan? ? 0 : noun_incidence.to_f)}', 
 #                                  '#{(adjective_incidence.nan? ? 0 : adjective_incidence.to_f)}',
 #                                  '#{(adverb_incidence.nan? ? 0 : adverb_incidence.to_f)}', 
 #                                  '#{(pronoun_incidence.nan? ? 0 : pronoun_incidence.to_f)}', 
 #                                  '#{(content_word_incidence.nan? ? 0 : content_word_incidence.to_f)}', 
 #                                  '#{(function_word_incidence.nan? ? 0 : function_word_incidence.to_f)}',
 #                                  '#{(flesch.nan? ? 0 : flesch.to_f)}');"
 #        insert = @connection.query(query_ancestor)
##



end
end
end