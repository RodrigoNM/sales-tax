# frozen_string_literal: true

RSpec.describe SalesTax::ReceiptFormatter do
  subject(:formatter) { described_class.new }

  it "formats a receipt" do
    items = SalesTax::BasketParser.new.parse(<<~INPUT)
      2 book at 12.49
      1 music CD at 14.99
      1 chocolate bar at 0.85
    INPUT
    receipt = SalesTax::ReceiptCalculator.new.calculate(items)

    expect(formatter.format(receipt)).to eq(<<~OUTPUT.chomp)
      2 book: 24.98
      1 music CD: 16.49
      1 chocolate bar: 0.85
      Sales Taxes: 1.50
      Total: 42.32
    OUTPUT
  end
end
