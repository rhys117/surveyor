module Surveyor
  class Response
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    attr_reader :email, :answers

    def initialize(options)
      raise "invalid email" unless VALID_EMAIL_REGEX.match options[:email]

      @email = options[:email]
      @answers = []
    end

    def add_answer(question, value)
      answer = Answer.new(question: question, value: value)
      answer.valid_answer? ? @answers << answer : raise("invalid answer to question")
      answer
    end

    def answer_to(question)
      # Depending on use cases matching by Question objects might be more appropriate
      @answers.find { |answer| answer.question.title == question.title }
    end
  end
end
