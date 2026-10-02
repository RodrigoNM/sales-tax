# Architecture

## Overview

The project uses a small layered design with composition between objects.

```text
                    +---------+
                    |   CLI   |
                    +----+----+
                         |
                         v
                 +---------------+
                 | BasketParser   |
                 +-------+-------+
                         |
                         v
                  +-------------+
                  |     Item    |
                  +------+------+ 
                         |
                         v
              +----------------------+
              | ReceiptCalculator    |
              +----------+-----------+
                         |
                         v
                 +---------------+
                 | TaxCalculator |
                 +-------+-------+
                         |
                 +-------+-------+
                 |               |
                 v               v
           +-----------+   +------------------+
           | TaxPolicy |   | TaxExemption     |
           |           |   | Policy           |
           +-----------+   +------------------+
                         |
                         v
                   +-----------+
                   |  Receipt  |
                   +-----+-----+
                         |
                         v
                 +---------------+
                 |ReceiptFormatter|
                 +---------------+
```

## Responsibilities

### `CLI`

Handles terminal input/output and converts application errors into user-friendly messages. It does not calculate taxes.

### `BasketParser`

Converts the external text representation into `Item` objects. It validates the line format and quantity.

### `Item`

Represents a product line in the basket: quantity, description, price, and whether the name indicates an imported product.

### `Money`

Represents monetary values as integer cents and owns basic money operations and formatting.

### `TaxPolicy`

Owns the tax rates themselves and delegates exemption classification to `TaxExemptionPolicy`.

### `TaxExemptionPolicy`

Determines whether an item is exempt from basic sales tax.

### `TaxCalculator`

Calculates the tax for an item, including the required 5-cent upward rounding.

### `ReceiptCalculator`

Combines items and tax calculations into receipt lines and totals.

### `Receipt`

Represents the calculated result without knowing how it will be displayed.

### `ReceiptFormatter`

Converts a `Receipt` into the exact textual output expected by the challenge.

## Composition

The main collaborators are injected rather than constructed throughout the classes.

For example:

```ruby
ReceiptCalculator.new(tax_calculator: TaxCalculator.new)
```

and:

```ruby
TaxPolicy.new(exemption_policy: TaxExemptionPolicy.new)
```

This makes the business rules independently testable and replaceable.

## SOLID principles used pragmatically

### Single Responsibility

Each object has one primary responsibility, such as parsing, tax calculation, formatting, or user interaction.

### Open/Closed

Tax classification and tax calculation are separate, so a new policy can be introduced without changing the receipt or CLI layers.

### Dependency Inversion

Collaborators are passed into classes where it improves testability and separation of concerns.

### Interface Segregation

No artificial interfaces are introduced because Ruby is dynamically typed and this small application does not need them.

### Liskov Substitution

The design intentionally avoids inheritance hierarchies because there is no meaningful subtype relationship required by the domain.
