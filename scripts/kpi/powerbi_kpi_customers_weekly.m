let
    Source =
        fnShopifyQL(
"FROM customers
SHOW new_customers, returning_customers
TIMESERIES week
SINCE -12w UNTIL today
ORDER BY week"
        )
in
    Source
