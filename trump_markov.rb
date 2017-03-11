require 'marky_markov'

class TrumpMarkov
  def initialize(seedfile, outfile='trumpmarkov.out')
    @seedfile=seedfile
    @outfile=outfile
  end

  def generate(num, type, enums_between_newlines)
    markov = MarkyMarkov::TemporaryDictionary.new
    markov.parse_file @seedfile
    y=1

    File.open(@outfile, 'w') do |file|
      num.times do |x|
        if type == 'words'
          generated_text=markov.generate_n_words 1
         file.write(generated_text + " ")
        elsif type == 'sentences'
          generated_text=markov.generate_n_sentences 1
         file.write(generated_text + " ")
        else
         return 'Invalid usage'
        end
        if y==enums_between_newlines
          file.write("\n")
          y=0
        end
        y+=1
      end
    end
  end
end

