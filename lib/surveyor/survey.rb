require 'pry'
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
      @responses.detect { |response| response.email.casecmp(email).zero? }
    end

    def user_responded?(email)
      @responses.any? { |response| response.email.casecmp(email).zero? }
    end

    def ratings_breakdown(question:, segments: [])
      return nil unless question.is_a?(RatingQuestion)

      results = { 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0 }

      matching_answers = find_questions_answers(question: question, segments: segments)
      matching_answers.each { |answer| results[answer.value] += 1 }

      results
    end

    def multiple_choice_breakdown(question:, segments: [])
      return nil unless question.is_a?(MultipleChoiceQuestion)

      results = {}
      question.items.each { |item| results[item] = 0 }

      matching_answers = find_questions_answers(question: question, segments: segments)
      matching_answers.each { |answer| results[answer.value] += 1 }

      results
    end

    def ratings_scale_count(question:, scale:, segments: [])
      return nil unless question.is_a?(RatingQuestion)

      range = scale_range(scale)
      find_questions_answers(question: question, segments: segments).select { |answer| range.cover?(answer.value) }.length
    end

    def multiple_choice_correct(question: question, segments: [])
      return nil unless question.is_a?(MultipleChoiceQuestion)

      matching_answers = find_questions_answers(question: question, segments: segments)
      total = matching_answers.length
      correctly_answered = matching_answers.select(&:correct?).length

      [correctly_answered, total]
    end

    def percent_correct(question:, segments: [])
      return nil unless question.is_a?(MultipleChoiceQuestion)

      correct, total = multiple_choice_correct(question: question, segments: segments)
      (correct.to_f / total.to_f) * 100
    end

    private

    def find_questions_answers(question:, segments: [])
      @responses.map do |response|
        (segments - response.segments).empty? ? response.answer_to(question) : nil
      end.compact
    end

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
  end
end
