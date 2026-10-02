# frozen_string_literal: true

module SalesTax
  class ReceiptFormatter
    def format(receipt)
      lines = receipt.lines.map do |line|
        "#{line.item.quantity} #{line.item.name}: #{line.total}"
      end

      lines << "Sales Taxes: #{receipt.sales_taxes}"
      lines << "Total: #{receipt.total}"

      lines.join("\n")
    end
  end
end
