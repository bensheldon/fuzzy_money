require 'spec_helper'
require 'fuzzy_money'

describe FuzzyMoney::Normalize do
  subject { FuzzyMoney::Normalize }

  # empty
  it { subject.new(nil).normalize.should eql(0.0) }

  # Dollars
  it { subject.new("$10.99").normalize.should eql(10.99) }
  it { subject.new("$10-$16").normalize.should eql(10.0) }

  # Canadian Dollars
  it { subject.new("C$10.00").normalize.should be_within(0.01).of(9.50) }

  # Euros
  it { subject.new("€10.00").normalize.should be_within(0.01).of(13.20) }
  it { subject.new("€10,00").normalize.should be_within(0.01).of(13.20) }
  it { subject.new("10.00€").normalize.should be_within(0.01).of(13.20) }
  it { subject.new("10,00€").normalize.should be_within(0.01).of(13.20) }

  # Pounds
  it { subject.new("£10.00").normalize.should be_within(0.1).of(15.60) }

end
