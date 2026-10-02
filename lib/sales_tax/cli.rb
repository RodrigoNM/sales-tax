# frozen_string_literal: true

module SalesTax
  class CLI
    def initialize(
      input: $stdin,
      output: $stdout,
      parser: BasketParser.new,
      receipt_calculator: ReceiptCalculator.new,
      formatter: ReceiptFormatter.new
    )
      @input = input
      @output = output
      @parser = parser
      @receipt_calculator = receipt_calculator
      @formatter = formatter
    end

    def run
      print_instructions

      receipt = build_receipt(read_basket)

      @output.puts
      @output.puts "-" * 32
      @output.puts @formatter.format(receipt)
    rescue Errors::Error => e
      @output.puts
      @output.puts "Error: #{e.message}"
      1
    end

    private

    def print_instructions
      @output.puts ""
      @output.puts "Enter the items in your basket."
      @output.puts "Example: 2 book at 12.49"
      @output.puts "Press ENTER on an empty line when finished."
      @output.puts ""
    end

    def read_basket
      lines = []

      loop do
        @output.print "> "
        line = @input.gets

        break if line.nil? || line.strip.empty?

        lines << line
      end

      lines.join
    end

    def build_receipt(input)
      items = @parser.parse(input)
      @receipt_calculator.calculate(items)
    end
  end
end
