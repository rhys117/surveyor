module Surveyor
  class RatingQuestion < Question
    def valid_answer?(input)
      (1..5).cover?(input)
    end
  end
end
