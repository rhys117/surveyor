module Surveyor
  class Answer
    attr_reader :question, :value

    def initialize(options)
      raise "invalid question" unless options[:question].is_a?(Question)

      @question = options[:question]
      @value = options[:value]
    end

    def valid_answer?
      @question.valid_answer?(@value)
    end
  end
end
