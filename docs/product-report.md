# Shopify Product & Metadata Download (GET-only)

## Purpose
Provide a read-only method to download **all Shopify product information**
including **product, variant, and inventory metafields** using REST GET calls only.

This approach is intended for:
- Manual downloads
- Audits
- One-time or periodic exports
- Environments where POST / GraphQL is restricted

---

## Key Constraint
Shopify REST APIs do **not** provide a single endpoint to retrieve
all product metafields.

As a result, data must be retrieved in multiple steps:
1. Products
2. Product metafields
3. Variant metafields (optional)
4. Inventory item metafields (optional)

---

## Data Included

### Products
- id
- title
- handle
- vendor
- product_type
- tags
- status
- body_html
- created_at
- updated_at
- variants (basic)
- images

### Metafields
- namespace
- key
- value
- type
- description
- created_at
- updated_at

---

## API Requirements
- Shopify Admin REST API
- GET requests only
- Required scopes:
  - read_products
  - read_inventory

API Version: 2026-01

---

## Download Flow (GET-only)

1. Download all products
2. For each product:
   - Download product metafields
   - Download variant metafields (if applicable)
   - Download inventory item metafields (if applicable)

---

## Output Files
Recommended output structure:

- products.json
- product_metafields.json
- variant_metafields.json
- inventory_metafields.json

These files can be joined using:
- product_id
- variant_id
- inventory_item_id

---

## Limitations
- Requires many requests for large catalogs
- Subject to REST rate limits
- Slower than GraphQL Bulk exports

This is the **only GET-only compliant solution**.

---

## Power BI Integration

KPI data is retrieved using ShopifyQL via the Shopify GraphQL Admin API
and ingested directly into Power BI using Power Query (M).

Power BI executes read-only HTTP requests to the ShopifyQL endpoint,
receives tabular JSON (`tableData`), and transforms it into KPI fact tables.

### Power BI Queries
The following Power BI queries are used:
- powerbi_kpi_sales_daily
- powerbi_kpi_traffic_conversion_daily
- powerbi_kpi_funnel_daily
- powerbi_kpi_customers_weekly

Each query calls a shared ShopifyQL Power Query function to ensure
consistent authentication and response handling.
