# Design Decisions

## Why a `bin` executable?

`bin/sales_tax` is the application's user-facing executable. It keeps the startup code separate from the domain implementation.

This follows common Ruby project conventions and gives the project a natural entry point:

```bash
./bin/sales_tax
```

## Why `lib/sales_tax.rb` plus `lib/sales_tax/`?

`lib/sales_tax.rb` is the library entry point loaded by `require "sales_tax"`.

The `lib/sales_tax/` directory contains the implementation files. This convention allows the project to scale without putting every class into one file.

## Why a full regex rather than splitting on `at`?

The literal word `at` can appear in an item description. A parser that uses `split(" at ")` would make that word part of the grammar in an unnecessarily fragile way.

The full-line regular expression validates the structure at once and captures the final price correctly.

```ruby
/\A(\d+) (.+) at (\d+\.\d{2})\z/
```

Because the description group is greedy, an item name containing `at` is still handled correctly as long as the final section is ` at PRICE`.

## Why integer cents?

Money enters the application as a decimal string such as `12.49` but becomes `1249` cents at the boundary.

Floating-point numbers are avoided because financial calculations need predictable decimal behavior. Integer cents also make five-cent rounding straightforward.

A `Money` value object hides the integer representation from the rest of the domain.

## Why `TaxExemptionPolicy`?

The basic tax rate and the exemption classification are related but distinct responsibilities.

`TaxPolicy` answers questions about applicable rates. `TaxExemptionPolicy` answers whether a product belongs to an exempt category.

Keeping them separate makes those rules easier to evolve and test independently.

## Why domain-specific errors?

`SalesTax::Errors` prevents the CLI from having to know about generic parsing exceptions such as `ArgumentError`.

The application can rescue `SalesTax::Errors::Error` and present expected user-input failures without accidentally swallowing unrelated programming errors.

## Why no framework or database?

The challenge is a deterministic calculation with no persistence requirement and no web interface. Ruby's standard library and RSpec are sufficient.

Adding Rails, a database, repositories, or an event bus would increase complexity without solving a requirement in the problem.

## Why not use a Money gem?

A production financial system may benefit from a specialized money library. For this exercise, the representation and operations are simple enough to implement safely with integer cents, so an external dependency would provide little value.

## Why keyword classification for exemptions?

The problem statement gives product descriptions but no structured product category. Keyword matching is therefore an explicit assumption made to map the sample input to the stated categories.

A production system would ideally receive a structured category from the product domain.
