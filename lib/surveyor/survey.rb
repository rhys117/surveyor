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
  end
end
