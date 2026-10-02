# frozen_string_literal: true

module SalesTax
  class BasketParser
    ITEM_PATTERN = /\A(\d+) (.+) at (\d+\.\d{2})\z/

    def parse(input)
      input.lines.filter_map do |line|
        line = line.strip
        next if line.empty?

        parse_item(line)
      end
    end

    private

    def parse_item(line)
      match = ITEM_PATTERN.match(line)
      raise Errors::InvalidItem, "Invalid item: #{line.inspect}" unless match

      quantity = match[1].to_i
      raise Errors::InvalidQuantity, "Quantity must be greater than zero: #{line.inspect}" unless quantity.positive?

      Item.new(
        quantity: quantity,
        name: match[2],
        unit_price: Money.parse(match[3])
      )
    end
  end
end
