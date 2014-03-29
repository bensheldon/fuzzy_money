require 'spec_helper'

describe FuzzyMoney::Price do
  describe '#normalize' do
    {
      '$10' => '$10',
      '$10-$55.00' => '$10',
      '£8/€10/$12' => '$12',
      '$10.99' => '$11',
      '€10,00' => '10€',
      '10.00€' => '10€',
      '' => '',
      nil => '',
      '$0' => '$0',
      '$0.00' => '$0'
    }.each do |raw, result|
     it "#{raw} -> #{result}" do
       price = FuzzyMoney::Price.new(raw)
       expect(price.normalize).to eq result
     end
    end
  end

  describe '#denominate' do
    it "'£8/€10/$12'.min -> $12" do
      price = FuzzyMoney::Price.new('£8/€10/$12')

      expect(price.min.denominate(:to_i)).to eq('$12')
    end
  end

  describe '#multiple' do
    {
      '£8/€10/$12' => ['£8', '€10' ,'$12'],
    }.each do |raw, result|
      it "#{raw} -> #{result}" do
        price = FuzzyMoney::Price.new(raw)
        ranges = price.multiple.map(&:raw)
        expect(ranges).to eq result
      end
    end
  end

  describe '#multiple?' do
    {
      '£8/€10/$12' => true,
      '€10' => false
    }.each do |raw, result|
      it "#{raw} -> #{result}" do
        price = FuzzyMoney::Price.new(raw)
        expect(price.multiple?).to eq result
      end
    end
  end

  describe '#range' do
    {
      '$10-$55.00' => ['$10', '$55.00'],
    }.each do |raw, result|
      it "#{raw} -> #{result}" do
        price = FuzzyMoney::Price.new(raw)
        ranges = price.range.map(&:raw)
        expect(ranges).to eq result
      end
    end
  end

  describe '#range?' do
    {
      '$10-$55.00' => true,
      '$55.00' => false,
    }.each do |raw, result|
      it "#{raw} -> #{result}" do
        price = FuzzyMoney::Price.new(raw)
        expect(price.range?).to eq result
      end
    end
  end

  describe '#min' do
    {
      '$10-$55.00' => '$10',
      '£8/€10/$12' => '$12',
      '$10.00' => '$10.00',
    }.each do |raw, result|
      it "#{raw} -> #{result}" do
        price = FuzzyMoney::Price.new(raw)
        expect(price.min.raw).to eq result
      end
    end
  end

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

  describe '#normalized_float' do
    {
      # USD
      "$10.99" => 10.99,
      # Canadian Dollars
      "C$10.00" => 9.50,
      # Euros
      "€10.00" => 13.20,
      "€10,00" => 13.20,
      "10.00€" => 13.20,
      "10,00€" => 13.20,
      # GBP
      "£10.00" => 15.60,
      # Multiple
      '£8/€10/$12' => 12.0,
      # Range
      "$10-$16" => 10.0,
    }.each do |raw, result|
      it "converts #{raw} -> #{result}" do
        price = FuzzyMoney::Price.new(raw)
        expect(price.normalized_float).to be_within(0.01).of(result)
      end
    end

    it 'converts nil -> 0.0' do
      price = FuzzyMoney::Price.new(nil)
      expect(price.normalized_float).to eq 0.0
    end
  end
end
