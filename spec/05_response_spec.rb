require 'spec_helper'

RSpec.describe Surveyor::Response do
  subject { described_class.new(email: "contact@rhysmurray.me") }

  it 'has an email' do
    expect(subject.email).to eq("contact@rhysmurray.me")
  end

  it 'invalid email raises error' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      expect { described_class.new(email: invalid_address) }.to raise_error("invalid email")
    end
  end
end
