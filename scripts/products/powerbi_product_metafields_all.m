let
    Store = "{store}",
    Token = "{ACCESS_TOKEN}",
    ApiVersion = "2026-01",

    // Reference your products query name here (must match whatever you name the products query in Power BI)
    ProductsTable = #"powerbi_products_all_pages",   // <-- change if your query name differs

    ProductIds = List.Transform(ProductsTable[product_id], each Text.From(_)),

    BaseUrl = "https://" & Store & ".myshopify.com/admin/api/" & ApiVersion & "/products/",

    // Small throttle between calls (prevents rate limiting)
    Delay = #duration(0, 0, 0, 0.25),   // 0.25 seconds

    GetProductMetafields = (Pid as text) as table =>
        let
            Url = BaseUrl & Pid & "/metafields.json",
            Response =
                try
                    Function.InvokeAfter(
                        () =>
                            Web.Contents(
                                Url,
                                [
                                    Headers = [ #"X-Shopify-Access-Token" = Token ],
                                    Query = [ limit = "250" ],
                                    ManualStatusHandling = {429, 500, 502, 503, 504}
                                ]
                            ),
                        Delay
                    )
                otherwise
                    null,

            Parsed = if Response <> null then try Json.Document(Response) otherwise null else null,
            ListMeta = if Parsed <> null and Record.HasFields(Parsed, "metafields") then Parsed[metafields] else {},

            T0 = Table.FromList(ListMeta, Splitter.SplitByNothing(), {"metafield"}, null, ExtraValues.Error),

            Expand = if Table.RowCount(T0) > 0 then
                Table.ExpandRecordColumn(
                    T0, "metafield",
                    {"id","namespace","key","value","type","description","created_at","updated_at","owner_id"},
                    {"metafield_id","namespace","key","value","type","description","created_at","updated_at","owner_id"}
                )
            else
                Table.FromRecords({}),

            WithProductId = Table.AddColumn(Expand, "product_id", each Number.FromText(Pid), Int64.Type)
        in
            WithProductId,

    Tables = List.Transform(ProductIds, each GetProductMetafields(_)),
    Combined = Table.Combine(Tables)
in
    Combined
