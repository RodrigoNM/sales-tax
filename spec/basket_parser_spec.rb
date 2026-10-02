# frozen_string_literal: true

RSpec.describe SalesTax::BasketParser do
  subject(:parser) { described_class.new }

  it "parses an item" do
    item = parser.parse("2 book at 12.49").first

    expect(item.quantity).to eq(2)
    expect(item.name).to eq("book")
    expect(item.unit_price.cents).to eq(1249)
  end

  it "allows the word 'at' inside the item name" do
    item = parser.parse("1 item at home at 12.49").first

    expect(item.name).to eq("item at home")
    expect(item.unit_price.cents).to eq(1249)
  end

  it "ignores blank lines" do
    items = parser.parse("\n2 book at 12.49\n\n")

    expect(items.size).to eq(1)
  end

  it "rejects invalid item syntax" do
    expect { parser.parse("book 12.49") }
      .to raise_error(SalesTax::Errors::InvalidItem)
  end

  it "rejects zero quantity" do
    expect { parser.parse("0 book at 12.49") }
      .to raise_error(SalesTax::Errors::InvalidQuantity)
  end
end
