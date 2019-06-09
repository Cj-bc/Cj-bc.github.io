module Main exposing (main)

import Browser
import FavCharacter exposing (Character(..))
import Html exposing (Html, a, article, button, div, footer, form, img, input, label, p, pre, text, textarea)
import Html.Attributes exposing (class, for, href, id, name, src, title, type_)
import Html.Events exposing (onClick)
import List
import Netlify exposing (netlify)
import Octicons as Oct
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



-- MODEL {{{


type Topic
    = Top
    | Aboutme
    | Products
    | Projects
    | Blog


type alias Model =
    { topic : Topic
    , popupCh : Maybe Character
    }


init : flags -> ( Model, Cmd Msg )
init _ =
    ( Model Top Nothing, Cmd.none )



-- UPDATE


type Msg
    = ChangeTopic Topic
    | CharacterClicked Character



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
                    case model.popupCh of
                        Nothing ->
                            viewAboutme

                        Just ch ->
                            viewCharacter ch

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
        [ img [ src "assets/icon/cj-bc.jpg" ] []
        , div [ class "aboutme-name" ] [ text "Cj.bc_sd a.k.a Cj-bc" ]
        , div [ class "aboutme-sns" ]
            [ Oct.markGithub Oct.defaultOptions
            , a [ href "https://github.com/Cj-bc" ] [ text "@Cj-bc" ]
            , img [ id "twitter-logo", src "assets/icon/twitter_blue.svg" ] []
            , a [ href "https://twitter.com/Cj_bc_sd" ] [ text "@Cj_bc_sd" ]
            ]
        , div [ class "aboutme-details" ]
            [ text "hoge" ]
        , viewFavs FavCharacter.characters
        ]




-- }}}
-- viewFavs : List Character -> Html Msg {{{


viewFavs : List Character -> Html Msg
viewFavs favs =
    div [] (List.map viewFav favs)



-- }}}
-- viewFav : Character -> Html Msg {{{


viewFav : Character -> Html Msg
viewFav fav =
    case fav of
        Person dic ->
            img [ src dic.pic, title dic.name ] []

        Character dic ->
            img [ src dic.pic, title dic.name, onClick (CharacterClicked fav) ] []

-- }}}
-- viewCharacter : Character -> Html Msg {{{


viewCharacter : Character -> Html Msg
viewCharacter ch =
    case ch of
        Person dic ->
            div []
                [ button [ onClick HideCharacter ] [ text "x" ]
                , img [ src dic.pic, title dic.name ] []
                , text dic.name
                , pre [] [ text dic.details ]
                ]

        Character dic ->
            div []
                [ img [ src dic.pic, title dic.name ] []
                , text dic.name
                , pre [] [ text dic.details ]
                ]



-- }}}
-- viewProducts : Html Msg {{{


viewProducts : Html Msg
viewProducts =
    text "hoge"



-- }}}
--    div [] (List.map viewProduct products)
-- viewProduct : Product -> Html Msg {{{


viewProduct : Product -> Html Msg
viewProduct (Product name url desc) =
    article []
        [ a [ href url ] [ text name ]
        , pre [] [ text desc ]
        ]



-- }}}
--- viewProjects : Html Msg {{{


viewProjects : Html Msg
viewProjects =
    div [] [ text "work in progress..." ]



-- }}}
-- viewBlog : Html Msg {{{


viewBlog : Html Msg
viewBlog =
    div [] [ text "work in progress..." ]



-- }}}
-- viewHeader : Html Msg {{{


viewHeader : Html Msg
viewHeader =
    div []
        [ button [ onClick (ChangeTopic Top) ] [ text "Cj-bc" ]
        , button [ onClick (ChangeTopic Aboutme) ] [ text "Aboutme" ]
        , button [ onClick (ChangeTopic Projects) ] [ text "Projects" ]
        , button [ onClick (ChangeTopic Products) ] [ text "Products" ]
        , button [ onClick (ChangeTopic Blog) ] [ text "Blog" ]
        ]



-- }}}
-- viewFooter : Html Msg {{{


viewFooter : Html Msg
viewFooter =
    footer []
        [ form [ name "contact", netlify "" ]
            [ p []
                [ label [ for "footer-name" ] [ text "name:" ]
                , input [ id "footer-name", name "Name", type_ "text" ] []
                ]
            , p
                []
                [ label [ for "footer-email" ] [ text "email:" ]
                , input [ id "footer-email", name "Email", type_ "text" ] []
                ]
            , p []
                [ label [ for "footer-message" ] [ text "message:" ]
                , textarea [ id "footer-message", name "message" ] []
                ]
            , button [ type_ "submit" ] [ text "submit" ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeTopic topic ->
            ( { model | topic = topic }, Cmd.none )

        CharacterClicked ch ->
            ( { model | popupCh = Just ch }, Cmd.none )
-- }}}
-- }}}
