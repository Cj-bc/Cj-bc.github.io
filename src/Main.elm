module Main exposing (main)

import Browser
import Html exposing (Html, a, article, div, img, pre, text)
import Html.Attributes exposing (class, href, src)
import List
import Product exposing (Product(..))



-- Flag isn't used for now


main : Program Int Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type Topic
    = Top
    | Aboutme
    | Products
    | Projects
    | Blog


type alias Model =
    { topic : Topic
    }


init : flags -> ( Model, Cmd Msg )
init _ =
    ( Model Top, Cmd.none )



-- UPDATE


type Msg
    = ChangeTopic Topic



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        topicName =
            case model.topic of
                Top ->
                    "Top"

                Aboutme ->
                    "Aboutme"

                Products ->
                    "Products"

                Projects ->
                    "Projects"

                Blog ->
                    "Blog"

        viewTopic =
            case model.topic of
                Top ->
                    viewTop

                Aboutme ->
                    viewAboutme

                Products ->
                    viewProducts

                Projects ->
                    viewProjects

                Blog ->
                    viewBlog
    in
    { title = topicName ++ " -- Cj-bc HP"
    , body =
        [ viewHeader
        , viewTopic
        , viewFooter
        ]
    }


viewTop : Html Msg
viewTop =
    div [] [ text "nothing here yet" ]


viewAboutme : Html Msg
viewAboutme =
    div [ class "topic-aboutme" ]
        [ img [ src "asetts/icon/cj-bc.jpg" ] []
        , div [ class "aboutme-name" ] [ text "Cj.bc_sd a.k.a Cj-bc" ]
        , div [ class "aboutme-sns" ]
            [ a [ href "https://github.com/Cj-bc" ] [ text "@Cj-bc" ]
            , a [ href "https://twitter.com/Cj_bc_sd" ] [ text "@Cj_bc_sd" ]
            ]
        , div [ class "aboutme-details" ]
            [ text "hoge" ]
        ]


viewProducts : Html Msg
viewProducts =
    text "hoge"



--    div [] (List.map viewProduct products)


viewProduct : Product -> Html Msg
viewProduct (Product name url desc) =
    article []
        [ a [ href url ] [ text name ]
        , pre [] [ text desc ]
        ]


viewProjects : Html Msg
viewProjects =
    div [] [ text "work in progress..." ]


viewBlog : Html Msg
viewBlog =
    div [] [ text "work in progress..." ]


viewHeader : Html Msg
viewHeader =
    div [] [ text "work in progress..." ]


viewFooter : Html Msg
viewFooter =
    div [] [ text "work in progress..." ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
