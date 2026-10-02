# frozen_string_literal: true

module SalesTax
  class Money
    PRICE_PATTERN = /\A\d+\.\d{2}\z/

    attr_reader :cents

    def self.parse(value)
      unless value.match?(PRICE_PATTERN)
        raise Errors::InvalidPrice, "Invalid price: #{value.inspect}"
      end

      new(value.delete(".").to_i)
    end

    def initialize(cents)
      unless cents.is_a?(Integer) && cents >= 0
        raise ArgumentError, "Money must be a non-negative integer number of cents"
      end

      @cents = cents
    end

    def +(other)
      Money.new(cents + other.cents)
    end

    def *(quantity)
      Money.new(cents * quantity)
    end

    def to_s
      format("%.2f", cents / 100.0)
    end
  end
end
