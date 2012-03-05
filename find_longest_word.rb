# word from states contest

# John Stewart @john_s_in_co
require 'set'

@longest = []

def find_big_word(word, state)
  p "word = #{word}, state = #{state}"
  if(word.length == 1)
    return state[0]
  end
  state.find_all { |k| k[0] == word[1] }.each do |next_state|  # find all adjacent states with the next letter word[1]
    p "next state =? #{next_state}..."
    result = find_big_word(word[1,word.length], @states[next_state[0]].assoc(next_state))
    if(result)
      return state[0] << result
    end
  end
  return nil
  # next_state = state.find { |k| k[0] == word[1] }
  # if(next_state)
    # p "@states[state.find {|k| k[0] == word[1] }]  =  #{@states[state.find {|k| k[0] == word[1] }]}"
    # return find_big_word(word[1,word.length], @states[next_state[0]].assoc(next_state))
  # else
    # @longest = []
  # end
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
      result = find_big_word(word, first_state)
      if(result == word)
        p "****** longest word is #{result}    ************"
      else
        p "got to #{result} for word #{word} trying state #{first_state}"
      end
    end
  end
end

# for each word in dict starting with the longest...
  # find the first letter in state list, traverse thru the adjacent @states array
    # if the next letter found, goto that state's entry in the hash and recurse
      # until all letters found
      # print out the letter/@states, end
    # else goto the next word...
