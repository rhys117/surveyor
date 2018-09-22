require 'spec_helper'

RSpec.describe Surveyor::Answer do
  question = "What do you call a boomerang that doesn't come back?"
  subject do
    described_class.new(question: Surveyor::FreeTextQuestion.new(title: question),
                        value:    "A stick")
  end

  it 'has a question' do
    expect(subject.question.title).to eq(question)
  end

  it 'has a value' do
    expect(subject.value).to eq("A stick")
  end

  context "Question" do
    it 'is instance of Question class' do
      expect(subject.question).to be_a(Surveyor::Question)
    end
  end

end
