require 'spec_helper'

RSpec.describe Surveyor::Survey do
  subject { described_class.new(name: "Engagement Survey") }

  it "has a name" do
    expect(subject.name).to eq("Engagement Survey")
  end

  it "can have questions added" do
    question = double(:question)
    subject.add_question(question)
    expect(subject.questions).to include(question)
  end

  it "can have responses added" do
    response = double(:response)
    subject.add_response(response)
    expect(subject.responses).to include(response)
  end

  context "find users response" do
    it "returns responses of user" do
      response = double(:response, email: 'example@gmail.com')
      subject.add_response(response)
      expect(subject.find_users_response('example@gmail.com')).to eq(response)
    end

    it "returns nil when not found" do
      expect(subject.find_users_response('non_existant@gmail.com')).to eq(nil)
    end
  end

  context "user responded?" do
    it "returns true when user has responded" do
      email = 'example@example.com'
      response = double(:response, email: email)
      subject.add_response(response)
      expect(subject.user_responded?(email)).to eq(true)
    end

    it "returns false when user has not responded" do
      expect(subject.user_responded?('none-existant@gmail.com')).to eq(false)
    end
  end

  context "ratings answer breakdown" do
    # it 'should count correctly' do
    #   10.times { |num| subject.add_response(Surveyor::Response.new(email: "#{num}@example.com")) }
    #   10.times { |num| subject.add_question(Surveyor::RatingQuestion.new(title: num)) }
    #   subject.questions.each do |question|
    #     subject.responses.each_with_index do |response, index|
    #       value = index > 5 ? 1 : 2
    #       response.add_answer(question: question, value: value)
    #     end
    #   end
    #   expected = { 1 => 4, 2 => 6, 3 => 0, 4 => 0, 5 => 0 }
    #   expect(subject.ratings_answer_breakdown(subject.questions.first)).to eq(expected)
    # end

    it 'should return nil if not ratings question' do
      dummy_question = double(:FreeTextQuestion, title: 'Test title')
      expect(subject.ratings_answer_breakdown(question: dummy_question)).to eq(nil)
    end

    it 'should give appropriate response to segments' do
      question = Surveyor::RatingQuestion.new(title: 'Q')
      subject.add_response(Surveyor::Response.new(email: "male@example.com", segments: %w(Male Melbourne)))
      subject.add_response(Surveyor::Response.new(email: "female@example.com", segments: %w(Female Melbourne)))
      subject.add_question(question)

      subject.responses.first.add_answer(question: question, value: 1)
      subject.responses.last.add_answer(question: question, value: 1)

      expected = { 1 => 1, 2 => 0, 3 => 0, 4 => 0, 5 => 0 }
      expect(subject.ratings_answer_breakdown(question: question, segments: %w(Male Melbourne))).to eq(expected)
    end
  end
end
