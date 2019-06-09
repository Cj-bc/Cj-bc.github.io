module FavCharacter exposing (Character)


type alias Name =
    String


type alias Url =
    String


type Link
    = Twitter Name
    | Github Name
    | Youtube Name Url
    | Marshmallow Name
    | Fanbox Name Url
    | Other String Url


type alias SrcPath =
    String


type Character
    = Character
        { name : String
        , details : String
        , comments : String
        , pic : SrcPath
        }
    | Person
        { name : String
        , links : List Link
        , details : String
        , comments : String
        , pic : SrcPath
        }
