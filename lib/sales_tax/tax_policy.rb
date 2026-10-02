# frozen_string_literal: true

module SalesTax
  class TaxPolicy
    BASIC_RATE = 10
    IMPORT_DUTY_RATE = 5

    def initialize(exemption_policy: TaxExemptionPolicy.new)
      @exemption_policy = exemption_policy
    end

    def basic_tax_rate(item)
      @exemption_policy.exempt?(item) ? 0 : BASIC_RATE
    end

    def import_duty_rate(item)
      item.imported? ? IMPORT_DUTY_RATE : 0
    end
  end
end
