require 'spec_helper'

RSpec.describe Surveyor::Answer do
  question_title = "What do you call a boomerang that doesn't come back?"
  subject do
    described_class.new(question: Surveyor::FreeTextQuestion.new(title: question_title),
                        value:    "A stick")
  end

  it 'has a question' do
    expect(subject.question.title).to eq(question_title)
  end

  it 'has a value' do
    expect(subject.value).to eq("A stick")
  end

  context "Question" do
    it 'is instance of Question class' do
      expect(subject.question).to be_a(Surveyor::Question)
    end

    it 'invalid Question raises error' do
      expect { described_class.new(question: question_title) }.to raise_error("invalid question")
    end
  end

  context "valid answer?" do
    it 'is true when valid' do
      expect(subject.valid_answer?).to eq(true)
    end

    it 'is false when invalid' do
      invalid = described_class.new(question: Surveyor::RatingQuestion.new(title: question_title),
                                    value: -1)
      expect(invalid.valid_answer?).to eq(false)
    end
  end

  context 'correct?' do
    correct_answer = 'second'
    question = Surveyor::MultipleChoiceQuestion.new(title: 'q', items: %w(first second), correct_answer: correct_answer)

    it 'returns nil when not a multiple choice question' do
      invalid_question = Surveyor::Question.new(title: 'q')
      invalid_answer = Surveyor::Answer.new(question: invalid_question, value: 'something')
      expect(invalid_answer.correct?).to eq(nil)
    end

    it 'returns true when answer correct' do
      answer = Surveyor::Answer.new(question: question, value: correct_answer)
      expect(answer.correct?).to eq(true)
    end

    it 'returns false when answer incorrect' do
      answer = Surveyor::Answer.new(question: question, value: 'first')
      expect(answer.correct?).to eq(false)
    end
  end
end
