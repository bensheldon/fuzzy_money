require 'spec_helper'

describe FuzzyMoney::Price do
  subject { FuzzyMoney::Price }

  describe "#split" do
    {
      # USD
      "$10.50" => ['$', 10.50],
      # Canadian Dollars
      "C$10.50" => ['C$', 10.50],
      # Euros
      "€10.50" => ['€', 10.50],
      "10.50€" => ['€', 10.50],
      # GBP
      "£10.50" => ['£', 10.50]
    }.each do |raw, result|
      it "splits #{raw} -> { denomination: '#{result[0]}', value: #{result[1]} }" do
        denomination = result[0]
        value = result[1]

        price = FuzzyMoney::Price.new(raw)

        expect(price.split).to eq({
          denomination: denomination,
          value: value
        })
      end
    end
  end

  describe '#normalize' do
    {
      # USD
      "$10.99" => 10.99,
      "$10-$16" => 10.0,
      # Canadian Dollars
      "C$10.00" => 9.50,
      # Euros
      "€10.00" => 13.20,
      "€10,00" => 13.20,
      "10.00€" => 13.20,
      "10,00€" => 13.20,
      # GBP
      "£10.00" => 15.60
    }.each do |raw, result|
      it "converts #{raw} -> #{result}" do
        price = FuzzyMoney::Price.new(raw)
        expect(price.normalize).to be_within(0.01).of(result)
      end
    end

    it 'converts nil -> 0.0' do
      price = FuzzyMoney::Price.new(nil)
      expect(price.normalize).to eq 0.0
    end
  end
end
