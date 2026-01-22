let
    Store = "{store}",
    Token = "{ACCESS_TOKEN}",
    ApiVersion = "2026-01",
    Url = "https://" & Store & ".myshopify.com/admin/api/" & ApiVersion & "/products.json?limit=250",

    Source = Json.Document(
        Web.Contents(
            Url,
            [
                Headers = [
                    #"X-Shopify-Access-Token" = Token,
                    #"Content-Type" = "application/json"
                ]
            ]
        )
    ),

    ProductsList = Source[products],
    T0 = Table.FromList(ProductsList, Splitter.SplitByNothing(), {"product"}, null, ExtraValues.Error),

    Expand = Table.ExpandRecordColumn(
        T0, "product",
        {"id","title","handle","vendor","product_type","status","tags","body_html","created_at","updated_at"},
        {"product_id","title","handle","vendor","product_type","status","tags","body_html","created_at","updated_at"}
    ),

    TagsText = Table.TransformColumns(
        Expand,
        {{"tags", each if _ is list then Text.Combine(List.Transform(_, Text.From), ", ") else Text.From(_), type text}}
    )
in
    TagsText
