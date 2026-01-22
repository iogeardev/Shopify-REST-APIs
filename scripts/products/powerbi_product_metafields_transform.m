let
    Store = "{store}",
    Token = "{ACCESS_TOKEN}",
    ApiVersion = "2026-01",
    ProductId = "{product_id}",

    Url = "https://" & Store & ".myshopify.com/admin/api/" & ApiVersion & "/products/" & ProductId & "/metafields.json?limit=250",

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

    MetaList = Source[metafields],
    T0 = Table.FromList(MetaList, Splitter.SplitByNothing(), {"metafield"}, null, ExtraValues.Error),

    Expand = Table.ExpandRecordColumn(
        T0, "metafield",
        {"id","namespace","key","value","type","description","created_at","updated_at","owner_id"},
        {"metafield_id","namespace","key","value","type","description","created_at","updated_at","owner_id"}
    ),

    WithProductId = Table.AddColumn(Expand, "product_id", each Number.FromText(ProductId), Int64.Type)
in
    WithProductId
