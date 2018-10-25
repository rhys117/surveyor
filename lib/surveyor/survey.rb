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

    ### - Filling Time Start - ###

    def ratings_scale_count(question:, scale:)
      return nil unless question.is_a?(RatingQuestion)

      range = scale_range(scale)
      find_questions_answers(question).select { |answer| range.cover?(answer.value) }.length
    end

    ### - Filling Time End - ###

    private

    def find_questions_answers(question)
      @responses.map do |response|
        response.answer_to(question)
      end.compact
    end

    ### - Filling Time Start - ###

    def scale_range(target)
      case target
      when :low
        (1..2)
      when :neutral
        (3..3)
      when :high
        (4..5)
      else
        raise 'invalid scale'
      end
    end

    ### - Filling Time End - ###
  end
end
