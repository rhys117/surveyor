module Surveyor
  class Response
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    attr_reader :email

    def initialize(options)
      raise "invalid email" unless VALID_EMAIL_REGEX.match options[:email]

      @email = options[:email]
    end
  end
end
