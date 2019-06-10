module FavCharacter exposing (Character(..), Link(..), characters)

import List


type alias Name =
    String


type alias Url =
    String


type alias Id =
    String


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


unlines : List String -> String
unlines xs =
    List.foldr (++) "" (List.intersperse "\n" xs)


characters : List Character
characters =
    [ Person
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
    , Person
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
