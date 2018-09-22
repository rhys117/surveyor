module Surveyor
  class Question
    attr_reader :title

    def initialize(options)
      @title = options[:title]
    end
  end
end
