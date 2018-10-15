module Surveyor
  class Survey
    attr_reader :name, :questions, :responses

    def initialize(name:)
      @name = name
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
      @responses.any? { |response| response.email == email }
    end

    def ratings_answer_breakdown(question)
      return nil unless question.is_a?(RatingQuestion)

      results = { 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0 }

      matching_answers = find_questions_answers(question)
      matching_answers.each { |answer| results[answer.value] += 1 }

      results
    end

    private

    def find_questions_answers(question)
      @responses.map do |response|
        response.answer_to(question)
      end.compact
    end
  end
end
