require 'spec_helper'

RSpec.describe Surveyor::Response do
  subject { described_class.new(email: "example@example.com", segments: %w(Male Melbourne)) }
  free_text_question = Surveyor::FreeTextQuestion.new(title: "Free text question")
  rating_question = Surveyor::RatingQuestion.new(title: "Rating question")
  multiple_choice_question = Surveyor::MultipleChoiceQuestion.new(title: 'Multiple choice question', items: %w(first second), correct_answer: 'first')

  it 'has an email' do
    expect(subject.email).to eq("example@example.com")
  end

  it 'has answers array' do
    expect(subject.answers).to eq([])
  end

  it 'has an segments array' do
    expect(subject.segments).to eq(%w(Male Melbourne))
  end

  it 'invalid email raises error' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      expect { described_class.new(email: invalid_address) }.to raise_error("invalid email")
    end
  end

  context 'add answer' do
    error_response = 'invalid answer to question'

    it 'valid free text question value added to answers' do
      subject.add_answer(question: free_text_question, value: 'Response')
      expect(subject.answers.count).to eq(1)
    end

    it 'invalid free text question value raises error' do
      expect { subject.add_answer(question: free_text_question, value: 0) }.to raise_error(error_response)
      expect(subject.answers.count).to eq(0)
    end

    it 'valid rating question value added to answers' do
      subject.add_answer(question: rating_question, value: 1)
      expect(subject.answers.count).to eq(1)
    end

    it 'invalid rating question value raises error' do
      expect { subject.add_answer(question: rating_question, value: 6) }.to raise_error(error_response)
      expect(subject.answers.count).to eq(0)
    end

    it 'valid multiple choice question added to answers' do
      subject.add_answer(question: multiple_choice_question, value: 'first')
      expect(subject.answers.count).to eq(1)
    end

    it 'invalid multiple choice question raises error' do
      expect { subject.add_answer(question: multiple_choice_question, value: 'none') }.to raise_error(error_response)
      expect(subject.answers.count).to eq(0)
    end
  end

  context 'answer to' do
    it 'should return matching answer' do
      free_text_answer = subject.add_answer(question: free_text_question, value: "answer to free text question")
      rating_answer = subject.add_answer(question: rating_question, value: 5)
      expect(subject.answer_to(free_text_question)).to eq(free_text_answer)
      expect(subject.answer_to(rating_question)).to eq(rating_answer)
    end

    it 'should return nil if answer not present' do
      question = Surveyor::FreeTextQuestion.new(title: "I'm not in the response")
      expect(subject.answer_to(question)).to eq(nil)
    end
  end
end
