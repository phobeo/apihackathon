require 'rubygems'
require 'open-uri'
require 'json'

# Pearson.new.word
class Pearson
  attr_reader :word, :desc
  
  def initialize()
    url = 'https://api.pearson.com/longman/dictionary/entry/random.json?apikey=3f9dd8a4d07e884eeb988f8269a343cc'
    buffer = open(url, "UserAgent" => "Ruby-Wget").read
    result = JSON.parse(buffer)

    # @word = result['Entry']['Head']['HWD']['#text']
    # @desc = result['Entry']['Sense']['DEF']['#text']
    @word = 'analytical'
    @desc = 'thinking about things in a detailed and intelligent way, so that you can examine and understand things'
  end
end