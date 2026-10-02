# frozen_string_literal: true

module SalesTax
  class Item
    attr_reader :quantity, :name, :unit_price

    def initialize(quantity:, name:, unit_price:)
      @quantity = quantity
      @name = name
      @unit_price = unit_price
    end

    def imported?
      name.downcase.include?("imported")
    end
  end
end
