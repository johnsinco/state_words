# word from states contest

# John Stewart @john_s_in_co
require 'set'

@longest = []

def find_big_word(word, state)
  p "word = #{word}, state = #{state}"
  if(word.length == 1)
p "$$$$$$  RETURNING FINAL STATE #{state[0]} FOR WORD $$$$$$$" 
    return state[0]
  end
  state.find_all { |k| k[0] == word[1] }.each do |next_state|  # find all adjacent states with the next letter word[1]
    p "next state =? #{next_state}..."
    return [state[0]] << find_big_word(word[1,word.length], @states[next_state[0]].assoc(next_state))
  end
  return []
end



p 'reading list of states...'
@states = Hash.new
File.open('statelist').read().split().each do |line|
  # k,*v=line.split(',')
  @states[line[0]] ||= Array.new()
  @states[line[0]] << line.split(',')
end
p @states
@valid_letters = Regexp.new "^[#{@states.keys.to_set.to_a.join}]+$"
p "valid_letters = #{@valid_letters}"
p "reading dictionary, sorting biggest->smallest, throw out words not in state letter set ..."
dict = File.new('wordlist.txt').read().split()
dict.sort_by! { |line| -line.length }.each do |word|
  word.upcase!
  if(@valid_letters =~ word) # check that each char in the word is in the valid_letters set
    p ">>>>>>>>   checking word #{word}"
    @states[word[0]].each do |first_state|
      result = find_big_word(word, first_state).flatten
      result_word = result.map {|st| st[0]}.join
      if(result_word == word)
        p "****** longest word is #{result_word} ************"
        p "***  path used is #{ result.map { |st| "#{st} -> "}.join}"
        exit
      else
        p "got to #{result_word} using path #{result} for word #{word} trying state #{first_state}"
      end
    end
  end
end
