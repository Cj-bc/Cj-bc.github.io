module Product exposing (Name, Product(..), Url)


type alias Name =
    String


type alias Url =
    String


type alias Description =
    String


type Product
    = Product Name Url Description
