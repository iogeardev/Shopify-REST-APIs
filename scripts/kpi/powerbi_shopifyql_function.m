(q as text) as table =>
let
    Store = "{store}",
    Token = "{ACCESS_TOKEN}",
    ApiVersion = "2026-01",

    Url = "https://" & Store & ".myshopify.com/admin/api/" & ApiVersion & "/graphql.json",

    Body =
        Text.ToBinary(
            "{""query"":""query($q:String!){ shopifyqlQuery(query:$q){ __typename ... on ShopifyQLQueryResponse { tableData { columns { name } rowData } } ... on ShopifyQLQueryError { message } } }"",""variables"":{""q"":"
            & Character.FromNumber(34) & Text.Replace(q, Character.FromNumber(34), "\""" ) & Character.FromNumber(34)
            & "}}"
        ),

    Response =
        Json.Document(
            Web.Contents(
                Url,
                [
                    Headers = [
                        #"X-Shopify-Access-Token" = Token,
                        #"Content-Type" = "application/json"
                    ],
                    Content = Body
                ]
            )
        ),

    Node = Response[data][shopifyqlQuery],
    TypeName = Node[__typename],

    TableData =
        if TypeName = "ShopifyQLQueryResponse"
        then Node[tableData]
        else error ("ShopifyQL error: " & Node[message]),

    Cols = List.Transform(TableData[columns], each _[name]),
    Rows = TableData[rowData],

    T0 = Table.FromRows(Rows, Cols)
in
    T0
