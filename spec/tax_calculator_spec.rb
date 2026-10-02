# frozen_string_literal: true

RSpec.describe SalesTax::TaxCalculator do
  subject(:calculator) { described_class.new }

  def item(name, price, quantity: 1)
    SalesTax::Item.new(
      quantity: quantity,
      name: name,
      unit_price: SalesTax::Money.parse(price)
    )
  end

  it "calculates 10% basic tax and rounds up to 5 cents" do
    expect(calculator.calculate(item("music CD", "14.99")).cents)
      .to eq(150)
  end

  it "applies only import duty to an imported exempt item" do
    expect(calculator.calculate(item("imported box of chocolates", "10.00")).cents)
      .to eq(50)
  end

  it "applies both taxes to an imported taxable item" do
    expect(calculator.calculate(item("imported bottle of perfume", "47.50")).cents)
      .to eq(715)
  end

  it "multiplies rounded unit tax by quantity" do
    expect(calculator.calculate(item("imported boxes of chocolates", "11.25", quantity: 3)).cents)
      .to eq(180)
  end
end
