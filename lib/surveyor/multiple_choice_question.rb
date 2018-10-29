module Surveyor
  class MultipleChoiceQuestion < Question
    attr_reader :items, :correct_answer

    def initialize(title:, items:, correct_answer:)
      super(title: title)
      @items = items
      @correct_answer = correct_answer

      check_for_errors
    end

    def valid_answer?(input)
      @items.include?(input)
    end

    private

    def check_for_errors
      raise 'correct answer must be included in items' unless @items.include?(@correct_answer)

      raise 'duplicate answer in items' unless @items.uniq.length == @items.length
    end
  end
end