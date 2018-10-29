module Surveyor
  class Answer
    attr_reader :question, :value

    def initialize(question:, value: nil)
      raise "invalid question" unless question.is_a?(Question)

      @question = question
      @value = value
    end

    def valid_answer?
      @question.valid_answer?(@value)
    end

    def correct?
      return nil unless question.is_a?(MultipleChoiceQuestion)

      @value == @question.correct_answer
    end
  end
end
