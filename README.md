A markov chain text generator that is fed a set of Trump's tweets   

Example Usage (see file 1000_generated_sentences.txt):    
```
irb(main):001:0> require_relative 'trump_markov'
=> true
irb(main):002:0> gen = TrumpMarkov.new('trump_tweets.txt', '1000_generated_sentences.txt')
=> #<TrumpMarkov:0x0000000091ad48 @seedfile="trump_tweets.txt", @outfile="1000_generated_sentences.txt">
irb(main):003:0> gen.generate(1000, 'sentences', 1)
=> 1000
```
