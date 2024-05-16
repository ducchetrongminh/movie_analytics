# Naming Convention

This document helps you determine the name of an object throughout the data warehouse.

# General convention

We prefer long but descriptive names over short but fuzzy names.

Abbreviations should be avoided, except very common abbreviations. If you use abbreviations, please specify at [Abbreviation List](./abbreviation.md).

# SQL naming convention

⬜ SQL object name should follow `snake_case`.

# Schema naming convention

⬜ Schema name should have prefix `movie_analytics*` when it belongs to the data warehouse.

⬜ Schema `movie_analytics` is the main schema, contains all dimension and fact tables.

⬜ Schema `movie_analytics_base`, `movie_analytics_staging` is to contain models that is staging, or middle models before the final models.

# Table naming convention

⬜ Table name should have prefix 
- `dim_*` for dimension tables.
- `fact_*` for fact tables.
- `stg_*` for models stay in the folder `staging`.
- `base_*` for models stay in the folder `base`.

⬜ Regarding different systems, table name should have prefix of the system name
- `dim_imdb_*`
- `dim_movielens_*`
- `dim_tmdb_*`

⬜ Table name might have suffix:
- `*_snapshot` for snapshot tables.
- `*_pipeline` for pipeline tables (tables that concatenate a whole process, such as sales order-picking-packing-invoice).
- `dim_*_indicator` for junk dimension tables.

# Model naming convention

⬜ If needed, staging model name might have suffix describing the purpose or action (note that 2 underscores).
- `*__rename_column`
- `*__handle_null`
- `*__convert_enum`
- `*__convert_numeric`
- `*__cleanse`
- `*__remove_*`

⬜ In case there are many in-between models, we can add step to model name
- `*__step1_*`
- `*__step2_*`

⬜ When writing SQL, at the part that joining a lot table with long name, you might alias table name to short form that still keep the meaning. For example:
- `fact_sales_order AS fact_header`
- `fact_sales_order_line AS fact_line`
- `fact_purchase_order AS fact_header`
- `fact_purchase_order_line AS fact_line`

# Column naming convention

⬜ Name of columns that describe `id, status` should be unique throughout the data warehouse. For example, `imdb_movie_id, imdb_movie_status, tmdb_movie_id, tmdb_movie_status`: movie data from 2 sources will have different names.

⬜ For ID columns, column name should have suffix 
- `*_key` for surrogate key from data warehouse
- `*_id` for surrogate key from data source system
- `*_no` for natural key

⬜ In case many columns pointing to the same dimension table, the meaning of ID should be passive verb and prefix. For example, in table sales, we might have `created_by` and `updated_by`, both are employee IDs. In that case, we will rename to `created_by_employee_id`, `updated_by_employee_id`.

⬜ Column name should have suffix for aggregation, measure.
- `*_avg`
- `*_count`
- `*_minutes`





# Appendix

## Example of names from Kimball book

Read these names so you can have a feeling about how Kimball names the objects.

### Tables

- Fact Retail Sales Transaction
- Fact Store Inventory Snapshot
- Fact Warehouse Inventory Transaction
- Fact Procurement Transaction
- Fact Purchase Requisition
- Fact Purchase Order
- Fact Shipping Notices
- Fact Warehouse Receipts
- Fact Vendor Payment
- Fact Procurement Pipeline
- Fact Order Line Transaction
- Fact Shipment Invoice Line Transaction

### Quantity columns

- Sales quantity
- Order quantity
- Shipped quantity
- Delivered quantity
- Received quantity
- Sold quantity
- Purchase order quantity
- Order line quantity
- Invoice line quantity
- Shipment quantity
- Shipment damage quantity
- Shipment return quantity
- Customer return quantity

### Unit price columns

- Regular unit price
- Discount unit price
- Net unit price
- List unit price
- Cost unit price

### Amount columns

- Discount amount
- Sales amount
- Cost amount
- Gross profit amount
- Purchase order amount
- Vendor invoice amount
- Vendor discount amount
- Vendor net payment amount
- Order line gross amount
- Order line discount amount
- Order line net amount
- Invoice line gross amount
- Invoice line allowance amount
- Invoice line discount amount
- Invoice line net amount
- Payment amount
- Budget amount

