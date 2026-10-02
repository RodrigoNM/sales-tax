# frozen_string_literal: true

RSpec.describe SalesTax::ReceiptCalculator do
  subject(:calculator) { described_class.new }

  it "calculates line totals, taxes, and receipt total" do
    items = SalesTax::BasketParser.new.parse(<<~INPUT)
      2 book at 12.49
      1 music CD at 14.99
      1 chocolate bar at 0.85
    INPUT

    receipt = calculator.calculate(items)

    expect(receipt.lines.map { |line| line.total.cents }).to eq([2498, 1649, 85])
    expect(receipt.sales_taxes.cents).to eq(150)
    expect(receipt.total.cents).to eq(4232)
  end
end
