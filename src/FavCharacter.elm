module FavCharacter exposing (Character)


type alias Name =
    String


type alias Url =
    String


type Sns
    = Twitter Name
    | Github Name
    | Youtube Name Url
    | Marshmallow Name


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
        , sns : Lst Sns
        , details : String
        , comments : String
        , pic : SrcPath
        }
