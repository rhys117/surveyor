require 'spec_helper'

RSpec.describe Surveyor::MultipleChoiceQuestion do
  question_tile = "Multiple choice question"
  items = %w(first second third fourth)

  subject do
    described_class.new(title: question_tile, items: items, correct_answer: 'second')
  end

  it 'has a question' do
    expect(subject.title).to eq(question_tile)
  end

  it 'has items' do
    expect(subject.items).to eq(items)
  end

  it 'has a correct answer' do
    expect(subject.correct_answer).to eq('second')
  end

  context 'valid answer?' do
    it 'is valid when is included in items list' do
      items.each { |answer| expect(subject.valid_answer?(answer)).to eq(true) }
    end

    it 'is invalid when not included on list' do
      examples = ['not on list', nil]
      examples.each { |answer| expect(subject.valid_answer?(answer)).to eq(false) }
    end
  end
end
