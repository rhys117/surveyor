module Surveyor
  class RatingQuestion < Question
    def valid_answer?(input)
      input.is_a?(Integer) && (1..5).cover?(input)
    end
  end
end
