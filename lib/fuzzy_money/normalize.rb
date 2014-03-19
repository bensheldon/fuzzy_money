module FuzzyMoney
  class Normalize
    attr_reader :string

    def initialize(string)
      if string.is_a? String
        @string = string.clone.strip
      else
        @string = ""
      end
    end

    def normalize
      case string
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
