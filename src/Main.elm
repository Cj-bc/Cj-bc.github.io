port module Main exposing (main)

import Browser
import FavCharacter exposing (Character(..), Link(..))
import Html exposing (Html, a, article, button, div, footer, form, header, img, input, label, li, nav, p, pre, text, textarea)
import Html.Attributes exposing (class, for, href, id, name, src, title, type_)
import Html.Events exposing (onClick)
import List
import Netlify exposing (netlify)
import Octicons as Oct
import Product exposing (Product(..))
import VirtualDom


port renderYouTubeButton : () -> Cmd msg



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



-- }}}
-- UPDATE {{{


type Msg
    = ChangeTopic Topic
    | CharacterClicked Character
    | HideCharacter


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeTopic topic ->
            ( { model | topic = topic }, Cmd.none )

        CharacterClicked ch ->
            ( { model | popupCh = Just ch }, renderYouTubeButton () )

        HideCharacter ->
            ( { model | popupCh = Nothing }, Cmd.none )



-- }}}
-- VIEW {{{


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
                    viewAboutme model

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



-- viewWIP : Html Msg {{{


viewWIP : Html Msg
viewWIP =
    div [ class "WIP" ]
        [ text "Work in progress..." ]



-- }}}
-- viewTop : Html Msg {{{


viewTop : Html Msg
viewTop =
    viewWIP



--- }}}
-- viewAboutme : Model -> Html Msg {{{


viewAboutme : Model -> Html Msg
viewAboutme model =
    let
        (Character dic) =
            FavCharacter.me

        base =
            [ img [ src dic.pic, title dic.name ] []
            , text dic.name
            , div [ class "character-links" ] (List.map viewLink dic.links)
            , pre [ class "character-details" ] [ text dic.details ]
            , pre [ class "character-comments" ] [ text dic.comments ]
            , viewFavs FavCharacter.characters
            ]
    in
    case model.popupCh of
        Nothing ->
            div [ class "topic-aboutme" ] base

        Just character ->
            div [ class "topic-aboutme" ] (List.append base [ viewCharacter character ])



-- }}}
-- viewFavs : List Character -> Html Msg {{{


viewFavs : List Character -> Html Msg
viewFavs favs =
    div [ class "aboutme-favs" ] (List.map viewFav favs)



-- }}}
-- viewFav : Character -> Html Msg {{{


viewFav : Character -> Html Msg
viewFav fav =
    let
        (Character dic) =
            fav
    in
    input [ class "fav-selectIcon", type_ "image", src dic.pic, title dic.name, onClick (CharacterClicked fav) ] []



-- }}}
-- viewCharacter : Character -> Html Msg {{{
-- TODO: This should show more details


viewCharacter : Character -> Html Msg
viewCharacter (Character dic) =
    div [ class "character" ]
        [ button [ onClick HideCharacter ] [ text "x" ]
        , img [ src dic.pic, title dic.name ] []
        , text dic.name
        , div [ class "character-links" ] (List.map viewLink dic.links)
        , pre [ class "character-details" ] [ text dic.details ]
        , pre [ class "character-comments" ] [ text dic.comments ]
        ]



-- }}}
-- YouTube custom attributes {{{
--
-- Usage example:
--  <div class="g-ytsubscribe" data-channelid="UCPf-EnX70UM7jqjKwhDmS8g" data-layout="full" data-count="default"></div>
--
-- Those codes are generated by: https://developers.google.com/youtube/youtube_subscribe_button


dataChannelid : String -> Html.Attribute msg
dataChannelid id =
    VirtualDom.attribute "data-channelid" id


dataLayout : String -> Html.Attribute msg
dataLayout str =
    VirtualDom.attribute "data-layout" str


dataCount : String -> Html.Attribute msg
dataCount str =
    VirtualDom.attribute "data-count" str



-- }}}
-- viewLink : Link -> Html Msg {{{
-- TODO: replace {Marshmallow,Fanbox,Other} images to official, or better one.
--       Currently I'm using
--         - Twitter icon for Marshmallow
--         - Just text for FANBOX
--         - Simple SVG for Other


viewLink : Link -> Html Msg
viewLink ln =
    case ln of
        Twitter name ->
            a [ class "link-twitter", href ("https://twitter.com/" ++ name) ]
                [ img [ id "twitter-logo", src "assets/icon/twitter_blue.svg", title name ] []
                ]

        Github name ->
            a [ class "link-github", href ("https://github.com/" ++ name) ]
                [ Oct.markGithub Oct.defaultOptions
                ]

        Youtube name id_ ->
            div
                [ class "g-ytsubscribe", dataChannelid id_, dataLayout "full", dataCount "default" ]
                []

        Marshmallow name ->
            a [ class "link-marshmallow", href ("https://marshmallow-qa.com/" ++ name) ]
                [ img [ id "marshmallow-logo", src "https://pbs.twimg.com/profile_images/938296751437615104/vi3FxQJ7_400x400.jpg", title ("マシュマロ: " ++ name) ] [] ]

        Fanbox name id ->
            a [ class "link-fanbox", href ("https://www.pixiv.net/fanbox/creator/" ++ id) ]
                [ text ("fanbox: " ++ name) ]

        Other name url ->
            a [ class "link-other", href url ]
                [ img [ id "other-logo", src "assets/icon/other_logo.svg", title name ] [] ]



-- }}}
-- viewProducts : Html Msg {{{


viewProducts : Html Msg
viewProducts =
    viewWIP



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
    viewWIP



-- }}}
-- viewBlog : Html Msg {{{


viewBlog : Html Msg
viewBlog =
    viewWIP



--    div [] [ text "work in progress..." ]
-- }}}
-- viewHeader : Html Msg {{{


viewHeader : Html Msg
viewHeader =
    header []
        [ nav []
            [ li [] [ button [ onClick (ChangeTopic Top) ] [ text "Cj-bc" ] ]
            , li [] [ button [ onClick (ChangeTopic Aboutme) ] [ text "Aboutme" ] ]
            , li [] [ button [ onClick (ChangeTopic Projects) ] [ text "Projects" ] ]
            , li [] [ button [ onClick (ChangeTopic Products) ] [ text "Products" ] ]
            , li [] [ button [ onClick (ChangeTopic Blog) ] [ text "Blog" ] ]
            ]
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



-- }}}
-- }}}
