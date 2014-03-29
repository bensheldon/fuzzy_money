module FuzzyMoney
  class Price
    attr_reader :raw

    def initialize(raw)
      if raw.is_a? String
        @raw = raw.clone.strip
      else
        @raw = ""
      end
    end

    def split
      denomination, value = \
        case raw
        when /C\$(\d+\.?\d{0,2})/ # Canadian
          ['C$', $1.to_f]
        when /\$(\d+\.?\d{0,2})/ # USA
          ['$', $1.to_f]
        when /€(\d+[\.,]?\d{0,2})/ # Leading Euro
          ['€', $1.to_f]
        when /(\d+[\.,]?\d{0,2})€/ # Trailing Euro
          ['€', $1.to_f]
        when /£(\d+[\.,]?\d{0,2})/ # Pounds
          ['£', $1.to_f]
        else
          [nil, nil]
        end

      {
        denomination: denomination,
        value: value
      }
    end

    def default_normalizations
      {
        '$'  =>  1.0,
        'C$' =>  0.95,
        '€'  =>  1.32,
        '£'  =>  1.56
      }
    end

    def normalize
      case raw
      when /C\$(\d+\.?\d{0,2})/ # Canadian
        $1.to_f * 0.95
      when /\$(\d+\.?\d{0,2})/ # USA
        $1.to_f
      when /€(\d+[\.,]?\d{0,2})/ # Leading Euro
        $1.to_f * 1.32
      when /(\d+[\.,]?\d{0,2})€/ # Trailing Euro
        $1.to_f * 1.32
      when /£(\d+[\.,]?\d{0,2})/ # Pounds
        $1.to_f * 1.56
      else
        0.00
      end
    end
  end
end
