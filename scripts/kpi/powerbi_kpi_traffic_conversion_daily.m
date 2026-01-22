let
    Source =
        fnShopifyQL(
"FROM sales, sessions
SHOW day, total_sales, sessions, orders
GROUP BY day
SINCE -30d UNTIL today
ORDER BY day"
        )
in
    Source
