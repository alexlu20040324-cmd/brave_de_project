# Jaffle Shop Analytics Pipeline

End-to-end ELT pipeline built with dbt Core and Snowflake, transforming raw e-commerce data into analytics-ready tables answering business questions about product profitability.

## Business Problem

A retail food company needs to understand which products actually drive profit. Raw transactional data is messy and hard to query. This pipeline turns it into clean, tested, documented tables.

## Key Insight

Beverages have lower per-unit profit than food, but sell 3-4x more often, generating ~2x the total profit. Looking at margin alone would have led to the wrong strategy.

## Architecture

Raw CSVs to Staging (clean) to Marts (dim + fact) to Aggregates.

- Staging: 6 views - rename, cast types, standardize.
- Marts: star schema. Dims (dim_customers, dim_products, dim_stores), Facts (fct_orders, fct_order_items).
- Aggregate: product_profitability - revenue, cost, profit, margin per product.

## Data Quality

21 automated tests: generic (unique, not_null, relationships), custom (profit non-negative, order totals reconcile), and unit (profit-calculation logic). Zero-value orders (~0.78%) are flagged, not deleted.

## Orchestration

Full pipeline (run + test) scheduled via cron to run daily with timestamped logs.

## Cost Efficiency

~4 credits total (<1% of trial): XSMALL warehouse with auto-suspend, view materialization, lean logic.

## Tech Stack

Snowflake, dbt Core 1.12, Python 3.10, cron
