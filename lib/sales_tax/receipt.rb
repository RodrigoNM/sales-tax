# frozen_string_literal: true

module SalesTax
  class Receipt
    Line = Struct.new(:item, :tax, :total, keyword_init: true)

    attr_reader :lines

    def initialize(lines)
      @lines = lines.freeze
    end

    def sales_taxes
      lines.reduce(Money.new(0)) { |total, line| total + line.tax }
    end

    def total
      lines.reduce(Money.new(0)) { |sum, line| sum + line.total }
    end
  end
end
