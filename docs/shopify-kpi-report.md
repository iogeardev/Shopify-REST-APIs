# Shopify KPI Report Documentation

## Purpose
Provide a complete and auditable set of Shopify KPIs for
executive, finance, and operations reporting in Power BI.

This report combines:
- Shopify Analytics KPIs (ShopifyQL)
- Operational data (Orders, Refunds, Inventory)

---

## KPI Architecture

Shopify exposes KPIs through two mechanisms:

1. ShopifyQL (Analytics summaries)
2. Admin API objects (transactional data)

Both are required for a complete KPI model.

---

## API Requirements

- Shopify Admin API access token
- Required scopes:
  - read_analytics
  - read_orders
  - read_products
  - read_customers
  - read_inventory
- API Version: 2026-01

---

## KPI Tables Overview

| Table Name | Source | Grain |
|-----------|------|------|
| fact_sales_daily | ShopifyQL | Day |
| fact_sessions_daily | ShopifyQL | Day |
| fact_funnel_daily | ShopifyQL | Day |
| fact_customers | ShopifyQL | Week / Month |
| fact_orders | GraphQL Bulk | Order |
| fact_inventory | GraphQL Bulk | SKU + Location |

---

## Sales KPIs

Metrics:
- gross_sales
- discounts
- returns
- net_sales
- shipping
- taxes
- total_sales
- orders

Source: ShopifyQL

---

## Traffic & Conversion KPIs

Metrics:
- sessions
- orders
- conversion_rate (calculated in Power BI)
- average_order_value (calculated)

Source: ShopifyQL

---

## Funnel KPIs

Metrics:
- sessions
- product_views
- add_to_carts
- checkouts
- orders

Source: ShopifyQL

---

## Customer KPIs

Metrics:
- new_customers
- returning_customers

Source: ShopifyQL

---

## Operational KPIs

Metrics:
- order count
- refund count
- refund value
- fulfillment status
- inventory availability

Source:
- GraphQL Bulk Operations
- Inventory module documented separately

---

## Power BI Modeling Notes

- Conversion Rate = Orders / Sessions
- AOV = Total Sales / Orders
- Refund Rate = Returns / Gross Sales
- Inventory is joined by SKU and Date where required

---

## Refresh Strategy

- ShopifyQL KPI tables: Daily
- Orders & Inventory: Daily or On-Demand
- Inventory snapshots are non-historical unless persisted

---

## Change Log
- 2026-01-22: Initial KPI documentation
