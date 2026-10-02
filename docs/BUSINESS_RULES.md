# Business Rules

## Basic sales tax

Basic sales tax is 10%.

It applies to all goods except:

- books
- food
- medical products

The implementation uses `TaxExemptionPolicy` to identify the exempt categories from the product description supplied by the challenge.

## Import duty

Imported goods receive an additional 5% import duty.

There is no exemption from import duty. Therefore an imported exempt item pays 5%, while an imported taxable item pays 15% in total.

Examples:

- domestic book: 0%
- domestic perfume: 10%
- imported chocolate: 5%
- imported perfume: 15%

## Tax rounding

For a tax rate of `n%` and a shelf price of `p`, the tax is:

```text
n × p / 100
```

The result is rounded **up to the nearest 0.05**.

In the implementation, prices are stored in cents. A five-cent rounding unit means the tax is rounded up to a multiple of 5 cents.

## Quantity

Tax is calculated per unit and then multiplied by the quantity.

This is important because the specification describes rounding of the tax contained in an individual item's shelf price.

For example, three imported boxes of chocolates at $11.25 each have their per-unit tax rounded first, and the rounded tax is then multiplied by three.

## Input format

Each line must follow:

```text
QUANTITY DESCRIPTION at PRICE
```

Example:

```text
2 book at 12.49
```

The price must contain exactly two decimal places.

## Product classification assumption

The challenge supplies only a product description, not an explicit category field. Therefore the implementation identifies exempt products by keywords in the description.

This is intentionally documented as an assumption. A production application with a real product catalog would use an explicit product category rather than infer the category from free-form text.
