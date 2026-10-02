# frozen_string_literal: true

module SalesTax
  class ReceiptCalculator
    def initialize(tax_calculator: TaxCalculator.new)
      @tax_calculator = tax_calculator
    end

    def calculate(items)
      lines = items.map do |item|
        tax = @tax_calculator.calculate(item)
        subtotal = item.unit_price * item.quantity

        Receipt::Line.new(
          item: item,
          tax: tax,
          total: subtotal + tax
        )
      end

      Receipt.new(lines)
    end
  end
end
