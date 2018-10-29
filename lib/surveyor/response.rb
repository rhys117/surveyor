module Surveyor
  class Response
    VALID_EMAIL_REGEX = %r(\A[a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])
                           ?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z)x

    attr_reader :email, :answers, :segments

    def initialize(email:, segments: [])
      raise "invalid email" unless VALID_EMAIL_REGEX.match email

      @email = email
      @answers = []
      @segments = segments
    end

    def add_answer(question:, value:)
      answer = Answer.new(question: question, value: value)
      answer.valid_answer? ? @answers << answer : raise("invalid answer to question")
      answer
    end

    def answer_to(question)
      @answers.find { |answer| answer.question.title == question.title }
    end
  end
end
