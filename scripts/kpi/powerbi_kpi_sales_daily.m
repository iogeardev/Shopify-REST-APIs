let
    Source =
        fnShopifyQL(
"FROM sales
SHOW gross_sales, discounts, returns, net_sales, shipping, taxes, total_sales, orders
TIMESERIES day
SINCE -30d UNTIL today
ORDER BY day"
        )
in
    Source
