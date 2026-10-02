# frozen_string_literal: true

RSpec.describe SalesTax::CLI do
  it "reads a basket from stdin and prints the receipt" do
    input = StringIO.new(<<~INPUT)
      2 book at 12.49
      1 music CD at 14.99
      1 chocolate bar at 0.85

    INPUT
    output = StringIO.new

    described_class.new(input: input, output: output).run

    expect(output.string).to include(<<~OUTPUT.chomp)
      2 book: 24.98
      1 music CD: 16.49
      1 chocolate bar: 0.85
      Sales Taxes: 1.50
      Total: 42.32
    OUTPUT
  end

  it "prints a friendly error for invalid input" do
    input = StringIO.new("not an item\n\n")
    output = StringIO.new

    status = described_class.new(input: input, output: output).run

    expect(status).to eq(1)
    expect(output.string).to include("Error: Invalid item")
  end
end
