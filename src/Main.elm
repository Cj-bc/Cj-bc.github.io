port module Main exposing (main)

import Browser
import Html exposing (Html, a, article, button, div, footer, form, header, img, input, label, nav, p, pre, text, textarea)
import Html.Attributes exposing (class, for, href, id, name, src, title, type_)
import Html.Events exposing (onClick)
import List
import Octicons as Oct
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
            me

        base =
            [ img [ class "CircleBadge", src dic.pic, title dic.name ] []
            , text dic.name
            , div [ class "character-links" ] (List.map viewLink dic.links)
            , pre [ class "character-details" ] [ text dic.details ]
            , pre [ class "character-comments" ] [ text dic.comments ]
            , viewFavs characters
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
    input [ class "fav-selectIcon CircleBadge", type_ "image", src dic.pic, title dic.name, onClick (CharacterClicked fav) ] []



-- }}}
-- viewCharacter : Character -> Html Msg {{{
-- TODO: This should show more details


viewCharacter : Character -> Html Msg
viewCharacter (Character dic) =
    div [ class "character" ]
        [ button [ onClick HideCharacter ] [ text "x" ]
        , img [ class "CircleBadge", src dic.pic, title dic.name ] []
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
    div [] (List.map viewProduct products)



-- }}}
-- viewProduct : Product -> Html Msg {{{


viewProduct : Product -> Html Msg
viewProduct (Product name desc) =
    div [ class "border d-flex flex-items-center p-4" ]
        [ a [ class "border product", href ("https://github.com/Cj-bc/" ++ name) ]
            [ div [ class "product-name" ] [ text name ]
            , pre [ class "product-description" ] [ text desc ]
            ]
        ]



-- }}}
--- viewProjects : Html Msg {{{


viewProjects : Html Msg
viewProjects =
    div [ class "projects" ] (List.map viewProject projects)



-- }}}
-- viewProject : Project -> Html Msg {{{


viewProject : Project -> Html Msg
viewProject project =
    div [ class "project border d-flex flex-items-center p-4" ]
        [ a [ href project.url ]
            [ div [] [ text project.name ]
            , pre [ class "project-description" ] [ text project.description ]
            ]
        ]



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
        , a [ href "https://github.com/Cj-bc/cj-bc.github.io" ]
            [ Oct.markGithub Oct.defaultOptions
            , text "show this site in Github"
            ]
        ]



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
                , "まぐろなちゃんの力でボイチェンが進化している「子供部屋」メンバーの一人。"
                , "まぐろなちゃんと同じく本職は絵師。"
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
