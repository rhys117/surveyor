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
      expect(subject.user_responded?('noneexistant@gmail.com')).to eq(false)
    end
  end

  context "scale ratings count" do
    before do
      10.times { |num| subject.add_response(Surveyor::Response.new(email: "#{num}@example.com")) }
      10.times { |num| subject.add_question(Surveyor::RatingQuestion.new(title: num)) }
      subject.questions.each do |question|
        subject.responses.each_with_index do |response, index|
          value = index > 5 ? 1 : 3
          response.add_answer(question: question, value: value)
        end
      end
    end


    it 'should count low correctly' do
      expect(subject.ratings_scale_count(question: subject.questions.first, scale: :low)).to eq(4)
    end

    it 'should count neautural correctly' do
      expect(subject.ratings_scale_count(question: subject.questions.first, scale: :neutral)).to eq(6)
    end


    it 'should count neautural correctly' do
      expect(subject.ratings_scale_count(question: subject.questions.first, scale: :high)).to eq(0)
    end

    it 'should return nil if not ratings question' do
      expect(subject.ratings_scale_count(question: Surveyor::FreeTextQuestion.new(title: 'Something'), scale: :low)).to eq(nil)
    end

    it 'should raise error if invalid scale' do
      expect { subject.ratings_scale_count(question: subject.questions.first, scale: :none) }.to raise_error('invalid scale')
    end
  end

  context "ratings breakdown" do
    it 'should count correctly' do
      10.times { |num| subject.add_response(Surveyor::Response.new(email: "#{num}@example.com")) }
      10.times { |num| subject.add_question(Surveyor::RatingQuestion.new(title: num)) }
      subject.questions.each do |question|
        subject.responses.each_with_index do |response, index|
          value = index > 5 ? 1 : 2
          response.add_answer(question: question, value: value)
        end
      end
      expected = { 1 => 4, 2 => 6, 3 => 0, 4 => 0, 5 => 0 }
      expect(subject.ratings_breakdown(question: subject.questions.first)).to eq(expected)
    end

    it 'should return nil if not ratings question' do
      dummy_question = double(:FreeTextQuestion, title: 'Test title')
      expect(subject.ratings_breakdown(question: dummy_question)).to eq(nil)
    end

    it 'should give appropriate response to segments' do
      question = Surveyor::RatingQuestion.new(title: 'Q')
      subject.add_response(Surveyor::Response.new(email: "male@example.com", segments: %w(Male Melbourne)))
      subject.add_response(Surveyor::Response.new(email: "female@example.com", segments: %w(Female Melbourne)))
      subject.add_question(question)

      subject.responses.first.add_answer(question: question, value: 1)
      subject.responses.last.add_answer(question: question, value: 1)

      expected = { 1 => 1, 2 => 0, 3 => 0, 4 => 0, 5 => 0 }
      expect(subject.ratings_breakdown(question: question, segments: %w(Male Melbourne))).to eq(expected)
    end
  end

  context "multiple choice breakdown" do
    items = %w(first second third)
    correct_answer = 'second'

    it 'should count correctly' do
      10.times { |num| subject.add_response(Surveyor::Response.new(email: "#{num}@example.com")) }
      10.times { |num| subject.add_question(Surveyor::MultipleChoiceQuestion.new(title: num, items: items, correct_answer: correct_answer)) }
      subject.questions.each do |question|
        subject.responses.each_with_index do |response, index|
          value = index > 5 ? 'first' : 'second'
          response.add_answer(question: question, value: value)
        end
      end
      expected = { 'first' => 4, 'second' => 6, 'third' => 0 }
      expect(subject.multiple_choice_breakdown(question: subject.questions.last)).to eq(expected)
    end
  end

  context "multiple choice correct" do
    items = %w(first second)
    correct_answer = 'second'

    it 'should return nil unless multiple choice question' do
      question = Surveyor::Question.new(title: 'q')
      expect(subject.multiple_choice_correct(question: question)).to eq(nil)
    end

    it 'should count correctly' do
      10.times { |num| subject.add_response(Surveyor::Response.new(email: "#{num}@example.com")) }
      10.times { |num| subject.add_question(Surveyor::MultipleChoiceQuestion.new(title: num, items: items, correct_answer: correct_answer)) }
      subject.questions.each do |question|
        subject.responses.each_with_index do |response, index|
          value = index > 5 ? 'first' : 'second'
          response.add_answer(question: question, value: value)
        end
      end
      expected = 6
      expect(subject.multiple_choice_correct(question: subject.questions.last)).to eq(expected)
    end
  end

  context "percent correct" do
    items = %w(first second)
    correct_answer = 'second'

    it 'should return nil unless multiple choice question' do
      question = Surveyor::Question.new(title: 'q')
      expect(subject.multiple_choice_correct(question: question)).to eq(nil)
    end

    it 'should give correct percent in float' do
      10.times { |num| subject.add_response(Surveyor::Response.new(email: "#{num}@example.com")) }
      10.times { |num| subject.add_question(Surveyor::MultipleChoiceQuestion.new(title: num, items: items, correct_answer: correct_answer)) }
      subject.questions.each do |question|
        subject.responses.each_with_index do |response, index|
          value = index > 5 ? 'first' : 'second'
          response.add_answer(question: question, value: value)
        end
      end
      expected = 60.0
      expect(subject.percent_correct(question: subject.questions.last)).to eq(expected)
    end
  end

  context "number of answers to" do
    it 'should give appropriate response to segments' do
      question = Surveyor::RatingQuestion.new(title: 'Q')
      subject.add_response(Surveyor::Response.new(email: "male@example.com", segments: %w(Male Melbourne)))
      subject.add_response(Surveyor::Response.new(email: "female@example.com", segments: %w(Female Melbourne)))
      subject.add_question(question)

      subject.responses.first.add_answer(question: question, value: 1)
      subject.responses.last.add_answer(question: question, value: 1)

      expected = 1
      expect(subject.number_of_answers_to(question: question, segments: %w(Male Melbourne))).to eq(expected)
    end
  end
end
