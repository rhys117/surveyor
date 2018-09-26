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
end
