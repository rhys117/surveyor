module Surveyor
  class FreeTextQuestion < Question
    def valid_answer?(input)
      input.is_a?(String)
    end
  end
end
