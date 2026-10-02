# frozen_string_literal: true

RSpec.describe SalesTax::Money do
  describe ".parse" do
    it "parses a decimal price into cents" do
      expect(described_class.parse("12.49").cents).to eq(1249)
    end

    it "rejects prices without exactly two decimal places" do
      expect { described_class.parse("12") }
        .to raise_error(SalesTax::Errors::InvalidPrice)

      expect { described_class.parse("12.5") }
        .to raise_error(SalesTax::Errors::InvalidPrice)
    end
  end

  it "adds money values" do
    result = described_class.new(1249) + described_class.new(851)

    expect(result.cents).to eq(2100)
  end

  it "multiplies by a quantity" do
    result = described_class.new(1249) * 2

    expect(result.cents).to eq(2498)
  end

  it "formats cents as a decimal price" do
    expect(described_class.new(1249).to_s).to eq("12.49")
  end
end
