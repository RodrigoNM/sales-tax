# frozen_string_literal: true

module SalesTax
  module Errors
    class Error < StandardError; end

    class InvalidInput < Error; end
    class InvalidItem < Error; end
    class InvalidQuantity < InvalidItem; end
    class InvalidPrice < InvalidItem; end
  end
end
