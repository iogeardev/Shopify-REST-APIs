# REST-APIs
Rest API calls GET only
# Shopify Comprehensive Inventory → Power BI

This repository exports **all Shopify inventory states across all locations**
and transforms the data into a **Power BI–ready table**.

## What this solves
- Shopify Admin shows inventory, but not in analytics-friendly form
- REST API only exposes `available`
- GraphQL + Bulk Operations allow **full inventory state visibility**

## Inventory states included
- available
- on_hand
- incoming
- committed
- reserved
- damaged
- safety_stock
- quality_control

## Output
- One row per **SKU + Location**
- Inventory states pivoted as columns
- Ready for Power BI modeling

## Data flow
Shopify GraphQL Bulk API → JSONL → Power Query (M) → Power BI Model

## Docs
See `/docs/inventory-report.md` for full technical details.
