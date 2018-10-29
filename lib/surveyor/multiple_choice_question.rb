module Surveyor
  class MultipleChoiceQuestion < Question
    attr_reader :items, :correct_answer

    def initialize(title:, items:, correct_answer:)
      super(title: title)
      @items = items
      @correct_answer = correct_answer

      raise 'correct answer must be included in items' unless @items.include?(@correct_answer)
    end

    def valid_answer?(input)
      @items.include?(input)
    end
  end
end