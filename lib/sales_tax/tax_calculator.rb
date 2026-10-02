# frozen_string_literal: true

module SalesTax
  class TaxCalculator
    ROUNDING_UNIT_CENTS = 5
    PERCENT_DENOMINATOR = 100

    def initialize(tax_policy: TaxPolicy.new)
      @tax_policy = tax_policy
    end

    def calculate(item)
      rate = @tax_policy.basic_tax_rate(item) + @tax_policy.import_duty_rate(item)
      return Money.new(0) if rate.zero?

      tax_per_unit = round_up_to_nearest_five_cents(
        item.unit_price.cents * rate
      )

      Money.new(tax_per_unit) * item.quantity
    end

    private

    def round_up_to_nearest_five_cents(tax_numerator)
      # tax_numerator / 100 is the unrounded tax in cents.
      # Dividing by 500 directly gives the ceiling needed for 5-cent rounding.
      ((tax_numerator + (PERCENT_DENOMINATOR * ROUNDING_UNIT_CENTS) - 1) /
        (PERCENT_DENOMINATOR * ROUNDING_UNIT_CENTS)) * ROUNDING_UNIT_CENTS
    end
  end
end
