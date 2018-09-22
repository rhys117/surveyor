module Surveyor
  class Answer
    attr_reader :question
    attr_accessor :value

    def initialize(options)
      raise "invalid question" unless options[:question].is_a?(Question)

      @question = options[:question]
      @value = options[:value]
    end
  end
end