module FuzzyMoney
  class Price
    attr_reader :raw, :normalizations, :denominated_order

    DEFAULT_NORMALIZATIONS = {
      '$'  =>  1.0,
      'C$' =>  0.95,
      '€'  =>  1.32,
      '£'  =>  1.56,
    }

    DEFAULT_DENOMINATED_ORDER = {
      '$' => :before,
      'C$' => :before,
      '€' => :after,
      '£' => :before,
    }

    def initialize(raw, options={})
      if raw.is_a? String
        @raw = raw.clone.strip
      else
        @raw = ""
      end

      @normalizations = options.fetch(:normalizations, DEFAULT_NORMALIZATIONS)
      @denominated_order = options.fetch(:denominated_order, DEFAULT_DENOMINATED_ORDER)
    end

    def multiple
      Array(
        raw.split('/')
         .map(&:strip)
         .map { |r| Price.new(r) }
      )
    end

    def range
      Array(
        raw.split('-')
         .map(&:strip)
         .map { |r| Price.new(r) }
      )
    end

    def range?
      range.size > 1
    end

    def multiple?
      multiple.size > 1
    end

    def min
      if range?
        range[0]
      elsif multiple?
        multiple.sort { |p| p.normalized_float }.first
      else
        self
      end
    end

    def normalize
      min.denominate(:round)
    end

    def denominate(convert=:to_f)
      value = split[:value].send(convert)
      denomination = split[:denomination]

      if denominated_order[denomination] == :after
        "#{value}#{denomination}"
      else
        "#{denomination}#{value}"
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

    def normalized_float
      return 0.0 if split[:value].nil?
      split[:value] * normalizations[split[:denomination]]
    end
  end
end
