module Surveyor
  class FreeTextQuestion < Question
    def valid_answer?(input)
      input.is_a?(String)

      # include below statement to stop blank strings from being allowed
      # && !input.strip.size.zero?
    end
  end
end
