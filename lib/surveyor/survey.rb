module Surveyor
  class Survey
    attr_reader :name, :questions, :responses

    def initialize(options)
      @name = options[:name]
      @questions = []
      @responses = []
    end

    def add_question(question)
      @questions << question
    end

    def add_response(response)
      @responses << response
    end

    def find_users_response(email)
      @responses.detect { |r| r.email == email }
    end

    def user_responded?(email)
      @responses.map(&:email).include?(email)
    end

    def ratings_answer_breakdown(question)
      return nil unless question.is_a?(RatingQuestion)

      results = {}
      (1..5).each { |num| results[num] = 0 }

      matching_answers = find_questions_answers(question)
      matching_answers.map { |answer| results[answer.value] += 1 }

      results
    end

    private

    def find_questions_answers(question)
      matches = []

      @responses.each do |response|
        related_answer = response.answer_to(question)
        matches << related_answer if related_answer
      end

      matches
    end
  end
end
