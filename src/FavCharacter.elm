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




me : Character
me =
    Person
        { name = "Cj.bc_sd a.k.a Cj-bc"
        , links =
            [ Twitter "Cj_bc_sd"
            , Other "Github" "https://github.com/Cj-bc"
            , Other "Qiita" "https://qiita.com/Cj-bc"
            ]
        , details = " N odetails here"
        , comments = "It's me! Obviously"
        , pic = "assets/icon/cj-bc.jpg"
        }
