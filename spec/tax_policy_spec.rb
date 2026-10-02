# frozen_string_literal: true

RSpec.describe SalesTax::TaxPolicy do
  subject(:policy) { described_class.new }

  def item(name, imported: false)
    prefix = imported ? "imported " : ""
    SalesTax::Item.new(
      quantity: 1,
      name: "#{prefix}#{name}",
      unit_price: SalesTax::Money.new(1000)
    )
  end

  it "applies basic tax to taxable goods" do
    expect(policy.basic_tax_rate(item("music CD"))).to eq(10)
  end

  it "does not apply basic tax to exempt goods" do
    expect(policy.basic_tax_rate(item("book"))).to eq(0)
    expect(policy.basic_tax_rate(item("chocolate bar"))).to eq(0)
    expect(policy.basic_tax_rate(item("headache pills"))).to eq(0)
  end

  it "applies import duty to imported goods" do
    expect(policy.import_duty_rate(item("bottle of perfume", imported: true))).to eq(5)
  end

  it "does not apply import duty to domestic goods" do
    expect(policy.import_duty_rate(item("bottle of perfume"))).to eq(0)
  end
end
