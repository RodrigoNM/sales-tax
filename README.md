# Sales Tax

A small Ruby application that calculates sales tax and prints receipts for shopping baskets.

The implementation follows the supplied coding-challenge rules while keeping the design intentionally small. It uses composition, dependency injection, domain-specific errors, and a `Money` value object without introducing unnecessary frameworks or abstractions.

## Requirements

- Ruby 3.x recommended
- Bundler
- RSpec

## Run the application

The application has a friendly interactive CLI:

```bash
./bin/sales_tax
```

Enter one item per line and press ENTER on an empty line to calculate the receipt.

Example:

```text
Enter the items in your basket.
Example: 2 book at 12.49
Press ENTER on an empty line when finished.

> 2 book at 12.49
> 1 music CD at 14.99
> 1 chocolate bar at 0.85
>
--------------------------------
2 book: 24.98
1 music CD: 16.49
1 chocolate bar: 0.85
Sales Taxes: 1.50
Total: 42.32
```

## Run the tests

```bash
bundle exec rspec
```

The supplied three baskets are tested as acceptance examples, in addition to unit tests for parsing, money, tax policy, tax calculation, receipt calculation, formatting, and the CLI.

## Project structure

```text
sales-tax-app/
├── bin/
│   └── sales_tax
├── lib/
│   ├── sales_tax.rb
│   └── sales_tax/
│       ├── basket_parser.rb
│       ├── cli.rb
│       ├── errors.rb
│       ├── item.rb
│       ├── money.rb
│       ├── receipt.rb
│       ├── receipt_calculator.rb
│       ├── receipt_formatter.rb
│       ├── tax_calculator.rb
│       ├── tax_exemption_policy.rb
│       └── tax_policy.rb
├── spec/
├── docs/
├── Gemfile
└── README.md
```

## Design overview

The executable in `bin/sales_tax` is the application entry point. `lib/sales_tax.rb` is the library entry point and loads the application's components.

The core flow is:

```text
CLI
  -> BasketParser
  -> Item / Money
  -> ReceiptCalculator
       -> TaxCalculator
            -> TaxPolicy
            -> TaxExemptionPolicy
  -> Receipt
  -> ReceiptFormatter
```

Each object has a focused responsibility. Dependencies that represent collaborators are injected, which keeps the classes easy to test and replace.

## Key design decisions

### Money is represented as integer cents

User input such as `12.49` is accepted as a decimal string, but the domain converts it immediately to `1249` cents.

This avoids floating-point arithmetic for monetary calculations and makes tax rounding deterministic.

The `Money` object encapsulates this representation so the rest of the application does not need to know that money is stored as cents.

### Full-line regular expression for item input

The basket parser validates an entire line with a regular expression:

```ruby
/\A(\d+) (.+) at (\d+\.\d{2})\z/
```

This deliberately avoids splitting the input on the word `at`. The item name can itself contain `at`, and the regex greedily captures the description up to the final ` at PRICE` portion.

### Domain-specific errors

Application errors live under `SalesTax::Errors`. This allows the CLI to rescue application errors without hiding unrelated programming errors.

### Composition instead of inheritance

The application does not create subclasses such as `ImportedItem < Item` or `FoodItem < Item`. Tax behavior is composed from policies and calculators.

This keeps the model simple and makes business rules independently replaceable.

## More documentation

- [`docs/BUSINESS_RULES.md`](docs/BUSINESS_RULES.md) — tax rules and assumptions
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — responsibilities and dependency flow
- [`docs/DECISIONS.md`](docs/DECISIONS.md) — important design trade-offs and why they were made
