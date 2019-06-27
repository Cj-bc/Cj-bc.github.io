port module Main exposing (main)

import Browser
import Html exposing (Html, a, article, button, div, footer, form, h1, h2, h3, header, img, input, label, nav, p, pre, text, textarea)
import Html.Attributes exposing (class, for, href, id, name, src, style, title, type_)
import Html.Events exposing (onClick)
import List as L
import Octicons as Oct
import Svg as S
import Svg.Attributes as SvA
import Svg.Events as SvE
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


type Theme
    = Dark
    | White


showTheme : Theme -> String
showTheme t =
    case t of
        Dark ->
            "theme-dark"

        White ->
            "theme-white"


type PopUp
    = ShowCh Character
    | ThemePicker
    | NoPopUp


type alias Model =
    { topic : Topic
    , popUp : PopUp
    , theme : Theme
    }


init : flags -> ( Model, Cmd Msg )
init _ =
    ( Model Top NoPopUp White, Cmd.none )



-- }}}
-- UPDATE {{{


type Msg
    = ChangeTopic Topic
    | CharacterClicked Character
    | HideCharacter
    | ThemeChanged Theme
    | ThemePickerClicked


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeTopic topic ->
            ( { model | topic = topic }, Cmd.none )

        CharacterClicked ch ->
            ( { model | popUp = ShowCh ch }, renderYouTubeButton () )

        HideCharacter ->
            ( { model | popUp = NoPopUp }, Cmd.none )

        ThemePickerClicked ->
            ( { model | popUp = ThemePicker }, Cmd.none )

        ThemeChanged t ->
            ( { model | theme = t, popUp = NoPopUp }, Cmd.none )



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
                    viewTop model

                Aboutme ->
                    viewAboutme model

                Products ->
                    viewProducts model

                Projects ->
                    viewProjects model

                Blog ->
                    viewBlog model
    in
    { title = topicName ++ " -- Cj-bc HP"
    , body =
        [ viewHeader model
        , viewTopic
        , viewFooter model
        , viewTools model
        , viewPopUp model
        ]
    }



-- viewWIP : Html Msg {{{


viewWIP : Model -> Html Msg
viewWIP model =
    div [ class ("WIP" ++ " " ++ showTheme model.theme) ]
        [ text "Work in progress..." ]



-- }}}
--- viewPopUp : Model -> Html Msg {{{


viewPopUp : Model -> Html Msg
viewPopUp model =
    case model.popUp of
        ShowCh ch ->
            div [ class "popUp" ] [ viewCharacter model ch ]

        ThemePicker ->
            div [ class "popUp" ] [ viewThemePicker model ]

        NoPopUp ->
            div [ class "popUp", style "display" "none" ] []



-- }}}
-- viewTop : Html Msg {{{


viewTop : Model -> Html Msg
viewTop model =
    viewWIP model



--- }}}
-- viewAboutme : Model -> Html Msg {{{


viewAboutme : Model -> Html Msg
viewAboutme model =
    let
        (Character dic) =
            me

        myProfile =
            div [ class "aboutme d-flex flex-column" ]
                [ img [ class "CircleBadge", id "icon-me", src dic.pic, title dic.name ] []
                , h1 [ class "character-name" ] [ text dic.name ]
                , div [ class "character-links d-flex flex-justify-between" ] (List.map viewLink dic.links)
                , pre [ class "character-details" ] [ h3 [] [ text dic.details ] ]
                , pre [ class "character-comments" ] [ h3 [] [ text dic.comments ] ]
                ]

        characterProfiles =
            viewFavs characters
    in
    div [ class ("topic-aboutme d-flex flex-column" ++ " " ++ showTheme model.theme) ] [ myProfile, characterProfiles ]



-- }}}
-- viewFavs : List Character -> Html Msg {{{


viewFavs : List Character -> Html Msg
viewFavs favs =
    div [ class "aboutme-favs d-flex flex-justify-around" ] (List.map viewFav favs)



-- }}}
-- viewFav : Character -> Html Msg {{{


viewFav : Character -> Html Msg
viewFav fav =
    let
        (Character dic) =
            fav
    in
    input [ class "fav-selectIcon CircleBadge", type_ "image", src dic.pic, title dic.name, onClick (CharacterClicked fav) ] []



-- }}}
-- viewCharacter : Character -> Html Msg {{{
-- TODO: This should show more details


viewCharacter : Model -> Character -> Html Msg
viewCharacter model (Character dic) =
    div [ class ("character border d-flex flex-column" ++ " " ++ showTheme model.theme) ]
        [ button [ class "flex-justify-start", onClick HideCharacter ] [ text "x" ]
        , img [ class "CircleBadge", src dic.pic, title dic.name ] []
        , h1 [ class "character-name" ] [ text dic.name ]
        , div [ class "character-links d-flex flex-justify-center" ] (List.map viewLink dic.links)
        , pre [ class "character-details" ] [ h3 [] [ text dic.details ] ]
        , pre [ class "character-comments" ] [ h3 [] [ text dic.comments ] ]
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
                [ Oct.defaultOptions |> Oct.size githubSize |> Oct.markGithub
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


viewProducts : Model -> Html Msg
viewProducts model =
    div [ class ("" ++ " " ++ showTheme model.theme) ] (List.map viewProduct products)



-- }}}
-- viewProduct : Product -> Html Msg {{{


viewProduct : Product -> Html Msg
viewProduct (Product name desc) =
    div [ class "border d-flex flex-items-center p-4" ]
        [ a [ class "border product", href ("https://github.com/Cj-bc/" ++ name) ]
            [ h2 [ class "product-name" ] [ text name ]
            , pre [ class "product-description" ] [ h3 [] [ text desc ] ]
            ]
        ]



-- }}}
--- viewProjects : Html Msg {{{


viewProjects : Model -> Html Msg
viewProjects model =
    div [ class ("projects" ++ " " ++ showTheme model.theme) ] (List.map viewProject projects)



-- }}}
-- viewProject : Project -> Html Msg {{{


viewProject : Project -> Html Msg
viewProject project =
    div [ class "project border d-flex flex-items-center p-4" ]
        [ a [ href project.url ]
            [ h2 [] [ text project.name ]
            , pre [ class "project-description" ] [ h3 [] [ text project.description ] ]
            ]
        ]



-- }}}
-- viewBlog : Html Msg {{{


viewBlog : Model -> Html Msg
viewBlog model =
    viewWIP model



--    div [] [ text "work in progress..." ]
-- }}}
-- viewHeader : Html Msg {{{


viewHeader : Model -> Html Msg
viewHeader model =
    header [ class ("header" ++ " " ++ showTheme model.theme) ]
        [ nav [ class "header-nav" ]
            [ button [ onClick (ChangeTopic Top) ] [ text "Cj-bc" ]
            , button [ onClick (ChangeTopic Aboutme) ] [ text "Aboutme" ]
            , button [ onClick (ChangeTopic Projects) ] [ text "Projects" ]
            , button [ onClick (ChangeTopic Products) ] [ text "Products" ]
            , button [ onClick (ChangeTopic Blog) ] [ text "Blog" ]
            ]
        ]



-- }}}
-- viewFooter : Html Msg {{{


viewFooter : Model -> Html Msg
viewFooter model =
    footer [ class ("footer" ++ " " ++ showTheme model.theme) ]
        [ form [ name "contact", netlify "" ]
            [ p []
                [ label [ for "footer-name" ] [ text "name:" ]
                , input [ class "form-control", id "footer-name", name "Name", type_ "text" ] []
                ]
            , p
                []
                [ label [ for "footer-email" ] [ text "email:" ]
                , input [ class "form-control", id "footer-email", name "Email", type_ "text" ] []
                ]
            , p []
                [ label [ for "footer-message" ] [ text "message:" ]
                , textarea [ class "form-control", id "footer-message", name "message" ] []
                ]
            , button [ type_ "submit" ] [ text "submit" ]
            ]
        , a [ href "https://github.com/Cj-bc/cj-bc.github.io" ]
            [ Oct.defaultOptions |> Oct.size githubSize |> Oct.markGithub
            , text "show this site in Github"
            ]
        ]



-- }}}
-- viewTools {{{


viewTools : Model -> Html Msg
viewTools model =
    let
        viewthemePickerIcon =
            if model.popUp == ThemePicker then
                div [ style "display" "none" ] []

            else
                S.svg
                    [ SvA.class (showTheme model.theme)
                    , SvA.id "icon-colorscheme"
                    , SvE.onClick ThemePickerClicked
                    , SvA.viewBox "0 0 512 512"
                    , SvA.xmlSpace "preserve"
                    ]
                    svgColorPickerIcon
    in
    div [ class "tools" ] [ viewthemePickerIcon ]



-- }}}
-- viewThemePicker {{{


viewThemePicker : Model -> Html Msg
viewThemePicker model =
    let
        viewThemeIcon d =
            button
                [ class "theme-icon"
                , onClick (ThemeChanged d)
                ]
                [ text (showTheme d) ]
    in
    div [ class ("theme-picker border" ++ " " ++ showTheme model.theme) ]
        ([ h1 [] [ text "Themes Picker" ] ] ++ List.map viewThemeIcon [ Dark, White ])



-- }}}
-- }}}
--
-- Utils {{{


type alias Name =
    String


type alias Url =
    String


type alias Id =
    String


type alias Description =
    String



-- }}}
--
-- Netlify {{{


netlify : String -> Html.Attribute msg
netlify =
    VirtualDom.attribute "netlify"



-- }}}
--
-- Product {{{


type Product
    = Product Name Description


products : List Product
products =
    [ Product "blib"
        (unlines
            [ "bash用ライブラリマネージャー"
            , "bash-oo-frameworkと併用する形になっているが、内部に含んでいるため別途インストールは不要。"
            ]
        )
    , Product "check256"
        (unlines
            [ "homebrewのformula作成支援用ツール"
            , "githubのレポジトリ名とバージョン(tag名)を指定すると、そのファイルのsha256ハッシュを表示する。"
            , "簡単な作りだが、いちいちwgetしてopenssl使って...とする手間が省けると意外と便利。 "
            ]
        )
    , Product "shgif"
        (unlines
            [ "AAのGifを表示する"
            , "独自形式(READMEに記載)で書かれたファイルを読み込み、アニメーション表示をする。"
            , "ShellScript(bash)製なので大量に動かそうとするとかなりかくつくがそれがいいという評判あるとかないとか。"
            , "そろそろ綺麗に書き直そうと思いつつ放置されている。"
            ]
        )
    ]



-- }}}
--
-- Project {{{


type alias Project =
    { name : String
    , description : String
    , url : String
    }


projects : List Project
projects =
    [ Project "mcUI"
        (unlines
            [ "マイクラからshellを操作するプロジェクト"
            , "各ファイルをオブジェクトとして3D表現し、それぞれに視覚的なインタラクションを行うことでshellの操作をする。"
            , "名前の由来はマインクラフトから'mc'を、`GUI`/`CUI`から`UI`をとっている。決してUIフレームワークではない"
            , "尚これは実験的なプロジェクトであり、いつか「3D表示がデフォなOS」を作ってみたいなと思っているがまだ未来の話。"
            ]
        )
        "https://github.com/Cj-bc/mcUI"
    , Project
        "Yozakura Project"
        (unlines
            [ "「Vtuberシステム再発明プロジェクト」"
            , "動画撮影はもちろんのこと、アップロードやライブストリーミング、できれば動画編集等まで再発明しようというプロジェクト。"
            , "尚自分がバ美肉おじさんに傾倒しているため、ボイチェンも候補のうちに入る。"
            , "まだまだ始めたばかりで年単位のプロジェクトだが、徐々に進めていきたいと思っている。"
            ]
        )
        "https://github.com/Cj-bc/yozakura-project"
    ]



-- }}}
--
-- FavCharacter {{{


type Link
    = Twitter Name
    | Github Name
    | Youtube Name Id
    | Marshmallow Name
    | Fanbox Name Id
    | Other String Url


type alias SrcPath =
    String


type Character
    = Character
        { name : String
        , links : List Link
        , details : String
        , comments : String
        , pic : SrcPath
        }


unlines : List String -> String
unlines xs =
    List.foldr (++) "" (List.intersperse "\n" xs)


characters : List Character
characters =
    [ Character
        { name = "魔王マグロナ"
        , links =
            [ Twitter "ukyo_rst"
            , Youtube "まぐろなちゃんねる" "UCPf-EnX70UM7jqjKwhDmS8g"
            , Marshmallow "ukyo_rst"
            , Fanbox "ukyo_rst" "169083"
            , Other "ukyoさんWiki" "https://dic.nicovideo.jp/a/ukyo%20rst"
            ]
        , details = "『バーチャルボイスチェンジお絵かきYoutuber魔王おじさんです。』"
        , comments =
            unlines
                [ "とにかく超絶かわいいバ美肉元祖。"
                , "バ美肉という概念をこの世に生み出してしまった元凶。彼女のおかげでどれだけの人の性癖が歪められたことか..."
                , "数少ない「ボイスチェンジャー適合者」であり、初めてボイチェンをかけた時からかわいい女の子の声にしか聞こえないという神がかった声を持つおじさんである。"
                , "本職は絵師(神絵師)だがVtuberとなったことで、ボイチェンの調整をし始め音屋さん並みに音響の話をする。"
                , "魂のukyoさんは数年間もの生放送歴を持つベテランなのでめちゃくちゃ楽しい。普通に配信者としての面白さが半端ない。"
                , "また、本職がクリエイターなのもあり、「コンテンツ」に対する考え方は尊敬に値する。というかそこだけじゃなく全てにおいてめっちゃ尊敬してますあのすごい"
                ]
        , pic = "https://yt3.ggpht.com/a/AGF-l7-nbjPwvmOOyrp7KlRKX9Xh5oiInNQFOSWCIg=s288-mo-c-c0xffffffff-rj-k-no"
        }
    , Character
        { name = "兎鞠まり"
        , links =
            [ Twitter "tomari_mari"
            , Youtube "Tomari Mari channel/兎鞠まりちゃんねる" "UCkPIfBOLoO0hVPG-tI2YeGg"
            , Marshmallow "tomari_mari"
            , Fanbox "兎鞠まり" "33648062"
            , Other "Booth" "tomari-mari.booth.pm"
            , Other "OpenREC" "https://www.openrec.tv/user/tomari_mari"
            ]
        , details = "『ボイチェンVTuberの兎鞠（とまり）まりです お菓子とげーむだいすき！』"
        , comments =
            unlines
                [ "ロリ系バ美肉おじさんの筆頭。"
                , "まぐろなちゃんの次くらいに出現した「ボイチェン適合者」。その可愛い声とあざとい仕草は人々を捉えて離さない。"
                , "まぐろなちゃんの力でボイチェンが進化している「子供部屋」メンバーの一人。 まぐろなちゃんと同じく本職は絵師。"
                , "ukyoさん(まぐろなちゃんの魂)の配信の古参リスナーであり、ukyoさんをとても尊敬していた。絵師になったのもその影響のようである。かつて尊敬したukyoさんと今や仲良くコラボ配信等を行なっており、とても幸せそうでファンとしては本当に嬉しい。ちなみにまぐろなちゃんの(ukyoさんの)家と徒歩数分圏内に住んでいる。てぇてぇな。"
                , "普段は所謂「メスガキ」ムーヴでイキリ散らかしているが、コンテンツへの考え方等しっかりしてるところはしっかりしており、とても安心できる。"
                ]
        , pic = "https://yt3.ggpht.com/a/AGF-l78KDm0T_7A0Kf9Fy9Z1nIgAYlyBr0IJ8sNprQ=s288-mo-c-c0xffffffff-rj-k-no"
        }
    ]


me : Character
me =
    Character
        { name = "Cj.bc_sd a.k.a Cj-bc"
        , links =
            [ Twitter "Cj_bc_sd"
            , Github "Cj-bc"
            , Other "Qiita" "https://qiita.com/Cj-bc"
            ]
        , details = " N odetails here"
        , comments = "It's me! Obviously"
        , pic = "assets/icon/cj-bc.jpg"
        }



-- }}}
--
-- Consts {{{


githubSize : Int
githubSize =
    40



-- }}}
--
--
-- SVG icon {{{


svgColorPickerIcon : List (S.Svg Msg)
svgColorPickerIcon =
    [ S.style [ SvA.type_ "text/css" ] [ S.text ".st0{fill:#4B4B4B;}" ]
    , S.g []
        [ S.path
            [ SvA.class "st0"
            , SvA.style "fill: rgb(75, 75, 75);"
            , SvA.d
                (L.foldr (++)
                    ""
                    [ "M423.633,185.47l0.07-0.78l-0.442-0.203c0.053-1.726,0.23-3.391,0.23-5.126"
                    , "c0-92.494-74.98-167.5-167.491-167.5c-92.494,0-167.508,75.006-167.508,167.5c0,1.762,0.177,3.4,0.23,5.126l-0.425,0.203"
                    , "l0.089,0.78C35.914,213.777,0,268.853,0,332.63c0,92.503,75.016,167.509,167.509,167.509c32.283,0,62.228-9.59,87.818-25.422"
                    , "l0.673,0.488l0.673-0.488c25.59,15.832,55.535,25.422,87.819,25.422C437.021,500.139,512,425.133,512,332.63"
                    , "C512,268.853,476.087,213.777,423.633,185.47z M353.966,81.412c23.589,23.606,38.198,55.739,39.916,91.342"
                    , "c-5.702-1.762-11.528-3.241-17.443-4.418l-66.886-116.79C326.269,58.568,341.304,68.759,353.966,81.412z M392.253,202.718"
                    , "c-6.659,39.048-29.415,72.526-61.432,93.131c-7.615-33.753-25.359-63.584-49.886-86.198c19.072-9.89,40.571-15.549,63.558-15.549"
                    , "C361.316,194.103,377.341,197.237,392.253,202.718z M256,40.806c10.466,0,20.631,1.204,30.424,3.391l69.489,121.376"
                    , "c-3.772-0.266-7.579-0.424-11.422-0.424c-7.526,0-14.929,0.567-22.19,1.567l-72.004-125.76"
                    , "C252.175,40.877,254.088,40.806,256,40.806z M232.43,42.842l72.837,127.212c-8.943,2.222-17.62,5.162-25.962,8.748L205.706,50.254"
                    , "C214.242,46.933,223.168,44.436,232.43,42.842z M190.725,57.143l73.793,128.885c-2.638,1.46-5.278,2.93-7.846,4.507L256,190.056"
                    , "l-0.673,0.479c-9.74-6.012-20.118-11.113-31.008-15.141l-58.103-101.49C173.743,67.493,181.941,61.853,190.725,57.143z"
                    , "M153.997,85.645l47.62,83.161c-10.945-2.356-22.278-3.64-33.913-3.648l-31.521-55.056"
                    , "C141.212,101.281,147.161,93.082,153.997,85.645z M127.558,128.12l21.818,38.065c-10.767,1.213-21.198,3.463-31.256,6.57"
                    , "C118.862,157.056,122.138,142.038,127.558,128.12z M119.766,202.718c14.858-5.481,30.902-8.616,47.744-8.616"
                    , "c22.986,0,44.502,5.659,63.557,15.549c-24.527,22.614-42.288,52.462-49.868,86.198"
                    , "C149.127,275.245,126.371,241.767,119.766,202.718z M256,438.929c-28.954-24.172-47.778-59.652-49.673-99.772"
                    , "c15.726,4.922,32.336,7.72,49.673,7.72c17.284,0,33.93-2.798,49.656-7.72C303.761,379.311,284.954,414.782,256,438.929z"
                    , "M442.475,430.588c-25.129,25.102-59.679,40.597-97.983,40.597c-22.951,0-44.467-5.658-63.504-15.512"
                    , "C314.138,425.115,335,381.286,335,332.63c0-1.726-0.177-3.426-0.23-5.144l0.442-0.221l-0.035-0.718"
                    , "c42.059-22.64,73.403-62.503,84.188-110.476c38.304,24.678,63.681,67.621,63.681,116.559"
                    , "C483.046,370.935,467.55,405.485,442.475,430.588z"
                    ]
                )
            ]
            []
        ]
    ]



-- }}}
