# frozen_string_literal: true

module SalesTax
  class TaxExemptionPolicy
    EXEMPT_KEYWORDS = %w[
      book
      food
      chocolate
      medical
      medicine
      pill
      pills
    ].freeze

    def exempt?(item)
      normalized_name = item.name.downcase

      EXEMPT_KEYWORDS.any? { |keyword| normalized_name.include?(keyword) }
    end
  end
end
