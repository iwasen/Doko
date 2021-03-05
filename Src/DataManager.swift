//
//  DataManager.swift
//  DokoMorinonakanosagashimono
//
//  Created by 相沢伸一 on 2021/02/21.
//

import UIKit
import Foundation

let SCREEN_WIDTH: CGFloat = 1024      // 画面幅
let SCREEN_HEIGHT: CGFloat = 768      // 画面高さ
let LANG_JPN = 0             // 日本語
let LANG_ENG = 1             // 英語
let LANG_NUM = 2             // 言語数
let PAGE_NUM = 15            // ページ数
let FIND_ITEM_NUM = 6        // 見つけるアイテム数

class DataManager
{
    struct PlayItemData {
        var itemName: [String]
        var atariRect: CGRect
        var soundFile: [String]
    }

    struct PlayPageData {
        var itemData: [PlayItemData]
        var itemNum: Int
    }

    struct PlayFindItem: Codable {
        var itemIndex: Int = 0
        var findFlag: Bool = false
    }

    struct ReadZoomData {
        var point: CGPoint
        var ratio: CGFloat
    }

    // 1ページ
    private static let playItemDataP01 = [
        PlayItemData(itemName: ["あひる2ひき", "two ducks"],
                     atariRect: CGRect(x: 171, y: 51, width: 29, height: 26),
                     soundFile: ["kddk1j_wo0001_01ahirunihiki", "kddk1e_wo0001_01twoducks"]),
        PlayItemData(itemName: ["なかよしのうさぎ", "a chain of rabbits"],
                     atariRect: CGRect(x: 501, y: 347, width: 68, height: 35),
                     soundFile: ["kddk1j_wo0002_01nakayosinousagi", "kddk1e_wo0002_01achainofrabbits"]),
        PlayItemData(itemName: ["オレンジのかぼちゃ", "an orange pumpkin"],
                     atariRect: CGRect(x: 584, y: 219, width: 16, height: 17),
                     soundFile: ["kddk1j_wo0003_01orenjinokabocha", "kddk1e_wo0003_01anorangepumpkin"]),
        PlayItemData(itemName: ["あかずきん", "Little Red Riding Hood"],
                     atariRect: CGRect(x: 525, y: 268, width: 48, height: 69),
                     soundFile: ["kddk1j_wo0004_01akazukin", "kddk1e_wo0004_01littleredridinghood"]),
        PlayItemData(itemName: ["きいろいクレヨン", "a yellow crayon"],
                     atariRect: CGRect(x: 104, y: 267, width: 16, height: 23),
                     soundFile: ["kddk1j_wo0005_01kiiroikureyon", "kddk1e_wo0005_01ayellowcrayon"]),
        PlayItemData(itemName: ["さいころ", "a dice"],
                     atariRect: CGRect(x: 640, y: 395, width: 15, height: 13),
                     soundFile: ["kddk1j_wo0006_01saikoro", "kddk1e_wo0006_01adice"])
    ]

    // 2ページ
    private static let playItemDataP02 = [
        PlayItemData(itemName: ["ゆきだるま", "a snowman"],
                     atariRect: CGRect(x: 648, y: 311, width: 22, height: 34),
                     soundFile: ["kddk1j_wo0017_02yukidaruma", "kddk1e_wo0017_02asnowman"]),
        PlayItemData(itemName: ["バケツ", "a bucket"],
                     atariRect: CGRect(x: 347, y: 629, width: 48, height: 34),
                     soundFile: ["kddk1j_wo0018_02baketu", "kddk1e_wo0018_02abucket"]),
        PlayItemData(itemName: ["シャベル", "a shovel "],
                     atariRect: CGRect(x: 275, y: 692, width: 48, height: 42),
                     soundFile: ["kddk1j_wo0019_02shaberu", "kddk1e_wo0019_02ashovel"]),
        PlayItemData(itemName: ["タイヤ", "a tire"],
                     atariRect: CGRect(x: 546, y: 225, width: 38, height: 41),
                     soundFile: ["kddk1j_wo0020_02taiya", "kddk1e_wo0020_02atire"]),
        PlayItemData(itemName: ["ひこうき", "a plane"],
                     atariRect: CGRect(x: 592, y: 109, width: 41, height: 38),
                     soundFile: ["kddk1j_wo0021_02hikouki", "kddk1e_wo0021_02aplane"]),
        PlayItemData(itemName: ["ぼうし", "a hat "],
                     atariRect: CGRect(x: 729, y: 325, width: 28, height: 36),
                     soundFile: ["kddk1j_wo0023_02bousi", "kddk1e_wo0023_02ahat"]),
        PlayItemData(itemName: ["にんじん", "a carrot"],
                     atariRect: CGRect(x: 235, y: 555, width: 59, height: 28),
                     soundFile: ["kddk1j_wo0025_02ninjin", "kddk1e_wo0025_02acarrot"]),
        PlayItemData(itemName: ["たまねぎ", "an onion"],
                     atariRect: CGRect(x: 568, y: 312, width: 20, height: 25),
                     soundFile: ["kddk1j_wo0026_02tamanegi", "kddk1e_wo0026_02anonion"]),
        PlayItemData(itemName: ["じゃがいも", "a potato"],
                     atariRect: CGRect(x: 345, y: 601, width: 45, height: 26),
                     soundFile: ["kddk1j_wo0027_02jagaimo", "kddk1e_wo0027_02apotato"]),
        PlayItemData(itemName: ["しろいベンチ", "a white bench"],
                     atariRect: CGRect(x: 308, y: 331, width: 47, height: 30),
                     soundFile: ["kddk1j_wo0028_02siroibenti", "kddk1e_wo0028_02awhitebench"])
    ]

    // 3ページ
    private static let playItemDataP03 = [
        PlayItemData(itemName: ["しか", "a deer"],
                     atariRect: CGRect(x: 472, y: 506, width: 68, height: 95),
                     soundFile: ["kddk1j_wo0033_03sika", "kddk1e_wo0033_03adeer"]),
        PlayItemData(itemName: ["なかよしのりす", "a chain of squirrels"],
                     atariRect: CGRect(x: 541, y: 555, width: 172, height: 55),
                     soundFile: ["kddk1j_wo0035_03nakayosinorisu", "kddk1e_wo0035_03achainofsquirrels"]),
        PlayItemData(itemName: ["どんぐり", "an acorn"],
                     atariRect: CGRect(x: 452, y: 590, width: 18, height: 28),
                     soundFile: ["kddk1j_wo0036_03donguri", "kddk1e_wo0036_03anacorm"]),
        PlayItemData(itemName: ["てんとうむし", "a ladybug"],
                     atariRect: CGRect(x: 195, y: 640, width: 30, height: 22),
                     soundFile: ["kddk1j_wo0037_03tentoumusi", "kddk1e_wo0037_03aladybug"]),
        PlayItemData(itemName: ["ハートのマーク", "a heart"],
                     atariRect: CGRect(x: 454, y: 317, width: 56, height: 49),
                     soundFile: ["kddk1j_wo0038_03haatonomaaku", "kddk1e_wo0038_03aheart"]),
        PlayItemData(itemName: ["きつつき", "a woodpecker"],
                     atariRect: CGRect(x: 371, y: 194, width: 35, height: 58),
                     soundFile: ["kddk1j_wo0039_03kitutuki", "kddk1e_wo0039_03awoodpecker"]),
        PlayItemData(itemName: ["へび", "a snake"],
                     atariRect: CGRect(x: 754, y: 531, width: 168, height: 51),
                     soundFile: ["kddk1j_wo0041_03hebi", "kddk1e_wo0041_03asnake"])
    ]

    // 4ページ
    private static let playItemDataP04 = [
        PlayItemData(itemName: ["とりのはね", "a bird feather"],
                     atariRect: CGRect(x: 705, y: 231, width: 80, height: 73),
                     soundFile: ["kddk1j_wo0043_04torinohane", "kddk1e_wo0043_04abirdfeather"]),
        PlayItemData(itemName: ["あしあと", "a footprint"],
                     atariRect: CGRect(x: 276, y: 672, width: 55, height: 37),
                     soundFile: ["kddk1j_wo0044_04asiato", "kddk1e_wo0044_04footprint"]),
        PlayItemData(itemName: ["ネックレス", "a necklace"],
                     atariRect: CGRect(x: 700, y: 336, width: 51, height: 44),
                     soundFile: ["kddk1j_wo0045_04nekkuresu", "kddk1e_wo0045_04anecklace"]),
        PlayItemData(itemName: ["いつつぼしのてんとうむし", "a ladybug with five dots"],
                     atariRect: CGRect(x: 357, y: 138, width: 22, height: 22),
                     soundFile: ["kddk1j_wo0046_04itutubosinotentoumusi", "kddk1e_wo0046_04aladybugwithfivedots"]),
        PlayItemData(itemName: ["ほしじるしのてんとうむし", "a ladybug with stars on it"],
                     atariRect: CGRect(x: 284, y: 520, width: 19, height: 21),
                     soundFile: ["kddk1j_wo0047_04hosijirusinotentoumusi", "kddk1e_wo0047_04aladybugwithstarsonit"]),
        PlayItemData(itemName: ["くわがたむし", "a horned beetle"],
                     atariRect: CGRect(x: 740, y: 407, width: 55, height: 57),
                     soundFile: ["kddk1j_wo0048_04kuwagatamusi", "kddk1e_wo0048_04ahornedbeetle"]),
        PlayItemData(itemName: ["かえる", "a frog"],
                     atariRect: CGRect(x: 89, y: 401, width: 55, height: 61),
                     soundFile: ["kddk1j_wo0049_04kaeru", "kddk1e_wo0049_04sfrog"]),
        PlayItemData(itemName: ["ヘリコプター", "a helicopter"],
                     atariRect: CGRect(x: 59, y: 366, width: 38, height: 38),
                     soundFile: ["kddk1j_wo0050_04herikoputaa", "kddk1e_wo0050_04ahelcopter"])
    ]

    // 5ページ
    private static let playItemDataP05 = [
        PlayItemData(itemName: ["ピザ", "a pizza"],
                     atariRect: CGRect(x: 529, y: 516, width: 53, height: 32),
                     soundFile: ["kddk1j_wo0051_05piza", "kddk1e_wo0051_05apizza"]),
        PlayItemData(itemName: ["オムライス", "an omelette"],
                     atariRect: CGRect(x: 502, y: 491, width: 57, height: 23),
                     soundFile: ["kddk1j_wo0052_05omuraisu", "kddk1e_wo0052_05aomelette"]),
        PlayItemData(itemName: ["サンドイッチ", "a sandwich"],
                     atariRect: CGRect(x: 776, y: 517, width: 52, height: 34),
                     soundFile: ["kddk1j_wo0053_05sandoitti", "kddk1e_wo0053_05asandwich"]),
        PlayItemData(itemName: ["かたつむりのおやこ", "a snail and its little one"],
                     atariRect: CGRect(x: 423, y: 671, width: 95, height: 36),
                     soundFile: ["kddk1j_wo0054_05katatumurinooyako", "kddk1e_wo0054_05asnailanditslittleone"]),
        PlayItemData(itemName: ["かぼちゃのティーセット", "a lovely pumpkin tea set"],
                     atariRect: CGRect(x: 327, y: 615, width: 69, height: 60),
                     soundFile: ["kddk1j_wo0057_05kabochanotiisetto", "kddk1e_wo0057_05alovelypumpkinteaset"]),
        PlayItemData(itemName: ["むしくいりんご", "an apple with a worm in it"],
                     atariRect: CGRect(x: 409, y: 452, width: 53, height: 45),
                     soundFile: ["kddk1j_wo0058_05musikuiringo", "kddk1e_wo0058_05anapplewithaworminit"]),
        PlayItemData(itemName: ["？のマーク", "a question mark"],
                     atariRect: CGRect(x: 631, y: 645, width: 11, height: 24),
                     soundFile: ["kddk1j_wo0059_05hatenanomaaku", "kddk1e_wo0059_05aquestionmark"]),
        PlayItemData(itemName: ["トランプ", "a playing card"],
                     atariRect: CGRect(x: 671, y: 497, width: 22, height: 18),
                     soundFile: ["kddk1j_wo0060_05toranpu", "kddk1e_wo0060_05aplayingcard"]),
        PlayItemData(itemName: ["よつばのクローバー", "a four-leaf clover"],
                     atariRect: CGRect(x: 575, y: 75, width: 32, height: 33),
                     soundFile: ["kddk1j_wo0061_05yotubanokuroobaa", "kddk1e_wo0061_05afourleafclover"])
    ]

    // 6ページ
    private static let playItemDataP06 = [
        PlayItemData(itemName: ["うさぎ", "a rabbit"],
                     atariRect: CGRect(x: 456, y: 514, width: 62, height: 51),
                     soundFile: ["kddk1j_wo0062_06usagi", "kddk1e_wo0062_06arabbit"]),
        PlayItemData(itemName: ["さる", "a monkey"],
                     atariRect: CGRect(x: 560, y: 317, width: 121, height: 65),
                     soundFile: ["kddk1j_wo0063_06saru", "kddk1e_wo0063_06amonkey"]),
        PlayItemData(itemName: ["へび", "a snake"],
                     atariRect: CGRect(x: 267, y: 300, width: 114, height: 93),
                     soundFile: ["kddk1j_wo0064_06hebi", "kddk1e_wo0064_06asnake"]),
        PlayItemData(itemName: ["くじら", "a whale"],
                     atariRect: CGRect(x: 406, y: 93, width: 56, height: 24),
                     soundFile: ["kddk1j_wo0065_06kujira", "kddk1e_wo0065_06awhale"]),
        PlayItemData(itemName: ["かめ", "a turtle"],
                     atariRect: CGRect(x: 424, y: 327, width: 33, height: 43),
                     soundFile: ["kddk1j_wo0066_06kame", "kddk1e_wo0066_06atuetle"]),
        PlayItemData(itemName: ["ねこ", "a cat"],
                     atariRect: CGRect(x: 604, y: 128, width: 58, height: 65),
                     soundFile: ["kddk1j_wo0068_06neko", "kddk1e_wo0068_06acat"]),
        PlayItemData(itemName: ["ねずみ", "a mouse"],
                     atariRect: CGRect(x: 527, y: 466, width: 64, height: 54),
                     soundFile: ["kddk1j_wo0069_06nezumi", "kddk1e_wo0069_06amouse"]),
        PlayItemData(itemName: ["ペリカン", "a pelican"],
                     atariRect: CGRect(x: 271, y: 401, width: 68, height: 54),
                     soundFile: ["kddk1j_wo0070_06perikan", "kddk1e_wo0070_06apelican"]),
        PlayItemData(itemName: ["きりん", "a giraffe"],
                     atariRect: CGRect(x: 338, y: 408, width: 102, height: 148),
                     soundFile: ["kddk1j_wo0072_06kirin", "kddk1e_wo0072_06agiraffe"]),
        PlayItemData(itemName: ["しか", "a deer"],
                     atariRect: CGRect(x: 614, y: 442, width: 95, height: 126),
                     soundFile: ["kddk1j_wo0074_06sika", "kddk1e_wo0074_06adeer"])
    ]

    // 7ページ
    private static let playItemDataP07 = [
        PlayItemData(itemName: ["つくえ", "a desk"],
                     atariRect: CGRect(x: 687, y: 597, width: 27, height: 24),
                     soundFile: ["kddk1j_wo0080_07tukue", "kddk1e_wo0080_07adesk"]),
        PlayItemData(itemName: ["とびら", "a door"],
                     atariRect: CGRect(x: 41, y: 470, width: 39, height: 39),
                     soundFile: ["kddk1j_wo0081_07tobira", "kddk1e_wo0081_07adoor"]),
        PlayItemData(itemName: ["かぎ", "a key"],
                     atariRect: CGRect(x: 474, y: 638, width: 85, height: 48),
                     soundFile: ["kddk1j_wo0082_07kagi", "kddk1e_wo0082_07akey"]),
        PlayItemData(itemName: ["とんぼ", "a dragonfly"],
                     atariRect: CGRect(x: 784, y: 320, width: 24, height: 19),
                     soundFile: ["kddk1j_wo0084_07tonbo", "kddk1e_wo0084_07adragonfly"]),
        PlayItemData(itemName: ["どんぐり", "an acorn"],
                     atariRect: CGRect(x: 266, y: 422, width: 41, height: 42),
                     soundFile: ["kddk1j_wo0085_07donguri", "kddk1e_wo0085_07anacorn"]),
        PlayItemData(itemName: ["まつぼっくり", "a pinecone"],
                     atariRect: CGRect(x: 51, y: 627, width: 80, height: 73),
                     soundFile: ["kddk1j_wo0086_07matubokkuri", "kddk1e_wo0086_07apinecone"]),
        PlayItemData(itemName: ["くろいきのこ", "a black mushroom"],
                     atariRect: CGRect(x: 923, y: 526, width: 21, height: 21),
                     soundFile: ["kddk1j_wo0087_07kuroikinoko", "kddk1e_wo0087_07ablackmushroom"]),
        PlayItemData(itemName: ["ぼうし", "a hat"],
                     atariRect: CGRect(x: 281, y: 177, width: 35, height: 15),
                     soundFile: ["kddk1j_wo0088_07bousi", "kddk1e_wo0088_07ahat"]),
        PlayItemData(itemName: ["かごのなかのきのこ", "a mushroom in the basket"],
                     atariRect: CGRect(x: 876, y: 484, width: 45, height: 45),
                     soundFile: ["kddk1j_wo0089_07kagononakanokinoko", "kddk1e_wo0089_07amushroominthebasket"])
    ]

    // 8ページ
    private static let playItemDataP08 = [
        PlayItemData(itemName: ["フォーク", "a fork"],
                     atariRect: CGRect(x: 302, y: 352, width: 35, height: 30),
                     soundFile: ["kddk1j_wo0092_08fouku", "kddk1e_wo0092_08afork"]),
        PlayItemData(itemName: ["ドーナツ", "a doughnut"],
                     atariRect: CGRect(x: 116, y: 411, width: 38, height: 27),
                     soundFile: ["kddk1j_wo0093_08dounatu", "kddk1e_wo0093_08adoughnut"]),
        PlayItemData(itemName: ["とけい", "a clock"],
                     atariRect: CGRect(x: 644, y: 679, width: 54, height: 58),
                     soundFile: ["kddk1j_wo0094_08tokei", "kddk1e_wo0094_08aclock"]),
        PlayItemData(itemName: ["にんぎょひめ", "a mermaid"],
                     atariRect: CGRect(x: 800, y: 430, width: 30, height: 34),
                     soundFile: ["kddk1j_wo0095_08ningyohime", "kddk1e_wo0095_08amermaid"]),
        PlayItemData(itemName: ["きんのりんご", "a golden apple"],
                     atariRect: CGRect(x: 832, y: 404, width: 30, height: 30),
                     soundFile: ["kddk1j_wo0096_08kinnoringo", "kddk1e_wo0096_08agoldenapple"]),
        PlayItemData(itemName: ["かさ", "an umbrella"],
                     atariRect: CGRect(x: 784, y: 270, width: 30, height: 107),
                     soundFile: ["kddk1j_wo0097_08kasa", "kddk1e_wo0097_08anumbrella"]),
        PlayItemData(itemName: ["やかん", "a tea kettle"],
                     atariRect: CGRect(x: 240, y: 220, width: 49, height: 53),
                     soundFile: ["kddk1j_wo0098_08yakan", "kddk1e_wo0098_08ateakettle"]),
        PlayItemData(itemName: ["ろうそく", "a candle"],
                     atariRect: CGRect(x: 360, y: 270, width: 44, height: 55),
                     soundFile: ["kddk1j_wo0099_08rousoku", "kddk1e_wo0099_08acandle"]),
        PlayItemData(itemName: ["たからばこ", "a treasure chest"],
                     atariRect: CGRect(x: 684, y: 341, width: 90, height: 80),
                     soundFile: ["kddk1j_wo0100_08takarabako", "kddk1e_wo0100_08atreasurechest"])
    ]

    // 9ページ
    private static let playItemDataP09 = [
        PlayItemData(itemName: ["さんかくのまど", "a triangular window "],
                     atariRect: CGRect(x: 696, y: 511, width: 29, height: 28),
                     soundFile: ["kddk1j_wo0101_09sankakunomado", "kddk1e_wo0101_09atriangularwindow"]),
        PlayItemData(itemName: ["むらさきのとびら", "a purple door"],
                     atariRect: CGRect(x: 272, y: 562, width: 24, height: 34),
                     soundFile: ["kddk1j_wo0102_09murasakinotobira", "kddk1e_wo0102_09apurpledoor"]),
        PlayItemData(itemName: ["フォーク", "a fork"],
                     atariRect: CGRect(x: 63, y: 485, width: 31, height: 12),
                     soundFile: ["kddk1j_wo0103_09fouku", "kddk1e_wo0103_09afork"]),
        PlayItemData(itemName: ["コーヒーカップ", "a coffee cup"],
                     atariRect: CGRect(x: 36, y: 559, width: 25, height: 13),
                     soundFile: ["kddk1j_wo0104_09koohiikappu", "kddk1e_wo0104_09acoffeecup"]),
        PlayItemData(itemName: ["パラソル", "a parasol"],
                     atariRect: CGRect(x: 953, y: 444, width: 29, height: 31),
                     soundFile: ["kddk1j_wo0105_09parasoru", "kddk1e_wo0105_09aparasol"]),
        PlayItemData(itemName: ["みずたまドア", "a door with the polka-dots"],
                     atariRect: CGRect(x: 824, y: 507, width: 19, height: 23),
                     soundFile: ["kddk1j_wo0106_09mizutamadoa", "kddk1e_wo0106_09adoorwiththepolkadots"]),
        PlayItemData(itemName: ["しましまドア", "a door with the stripes"],
                     atariRect: CGRect(x: 387, y: 418, width: 22, height: 37),
                     soundFile: ["kddk1j_wo0107_09simasimadoa", "kddk1e_wo0107_09adoorwiththestripes"]),
        PlayItemData(itemName: ["ボート", "a row boat"],
                     atariRect: CGRect(x: 325, y: 613, width: 40, height: 19),
                     soundFile: ["kddk1j_wo0108_09bouto", "kddk1e_wo0108_09arowboat"]),
        PlayItemData(itemName: ["ボール", "a ball"],
                     atariRect: CGRect(x: 596, y: 398, width: 13, height: 14),
                     soundFile: ["kddk1j_wo0109_09bouru", "kddk1e_wo0109_09aball"]),
        PlayItemData(itemName: ["ひまわり", "a sunflower"],
                     atariRect: CGRect(x: 844, y: 432, width: 21, height: 41),
                     soundFile: ["kddk1j_wo0110_09himawari", "kddk1e_wo0110_09asunflower"])
    ]

    // 10ページ
    private static let playItemDataP10 = [
        PlayItemData(itemName: ["つき", "a moon"],
                     atariRect: CGRect(x: 24, y: 473, width: 125, height: 81),
                     soundFile: ["kddk1j_wo0111_10tuki", "kddk1e_wo0111_10amoon"]),
        PlayItemData(itemName: ["さかな", "a fish"],
                     atariRect: CGRect(x: 227, y: 509, width: 76, height: 50),
                     soundFile: ["kddk1j_wo0114_10sakana", "kddk1e_wo0114_10afish"]),
        PlayItemData(itemName: ["こうもり", "a bat"],
                     atariRect: CGRect(x: 831, y: 67, width: 43, height: 23),
                     soundFile: ["kddk1j_wo0115_10koumori", "kddk1e_wo0115_10abat"]),
        PlayItemData(itemName: ["あかいくつ", "a red shoe"],
                     atariRect: CGRect(x: 413, y: 60, width: 26, height: 16),
                     soundFile: ["kddk1j_wo0116_10akaikutu", "kddk1e_wo0116_10aredshoe"]),
        PlayItemData(itemName: ["りんご", "an apple"],
                     atariRect: CGRect(x: 349, y: 481, width: 58, height: 34),
                     soundFile: ["kddk1j_wo0118_10ringo", "kddk1e_wo0118_10anapple"]),
        PlayItemData(itemName: ["じゃぐち", "a water spigot"],
                     atariRect: CGRect(x: 564, y: 426, width: 26, height: 31),
                     soundFile: ["kddk1j_wo0121_10jaguti", "kddk1e_wo0121_10awaterspigot"]),
        PlayItemData(itemName: ["ＵＦＯ", "an UFO"],
                     atariRect: CGRect(x: 341, y: 169, width: 20, height: 17),
                     soundFile: ["kddk1j_wo0122_10yufo", "kddk1e_wo0122_10anufo"]),
        PlayItemData(itemName: ["ひこうき", "an airplane"],
                     atariRect: CGRect(x: 626, y: 204, width: 40, height: 34),
                     soundFile: ["kddk1j_wo0123_10hikouki", "kddk1e_wo0123_10anairplane"]),
        PlayItemData(itemName: ["くま", "a bear"],
                     atariRect: CGRect(x: 581, y: 378, width: 38, height: 41),
                     soundFile: ["kddk1j_wo0124_10kuma", "kddk1e_wo0124_10abear"])
    ]

    // 11ページ
    private static let playItemDataP11 = [
        PlayItemData(itemName: ["めんどり", "a hen"],
                     atariRect: CGRect(x: 259, y: 100, width: 73, height: 53),
                     soundFile: ["kddk1j_wo0125_11mendori", "kddk1e_wo0125_11ahen"]),
        PlayItemData(itemName: ["あわだてき", "a wire whisk"],
                     atariRect: CGRect(x: 227, y: 366, width: 91, height: 86),
                     soundFile: ["kddk1j_wo0126_11awadateki", "kddk1e_wo0126_11awirewhisk"]),
        PlayItemData(itemName: ["とけい", "a clock"],
                     atariRect: CGRect(x: 208, y: 453, width: 55, height: 58),
                     soundFile: ["kddk1j_wo0127_11tokei", "kddk1e_wo0127_11aclock"]),
        PlayItemData(itemName: ["ショベルカー", "a steam shovel"],
                     atariRect: CGRect(x: 599, y: 632, width: 130, height: 94),
                     soundFile: ["kddk1j_wo0128_11shoberukaa", "kddk1e_wo0128_11asteamshovel"]),
        PlayItemData(itemName: ["しかくいいちご", "a square strawberry"],
                     atariRect: CGRect(x: 507, y: 489, width: 33, height: 34),
                     soundFile: ["kddk1j_wo0129_11sikakuiitigo", "kddk1e_wo0129_11asquarestrawberry"]),
        PlayItemData(itemName: ["さくらんぼ", "cherries"],
                     atariRect: CGRect(x: 108, y: 263, width: 14, height: 14),
                     soundFile: ["kddk1j_wo0130_11sakuranbo", "kddk1e_wo0130_11cherries"]),
        PlayItemData(itemName: ["カスタネット", "a pair of castanets "],
                     atariRect: CGRect(x: 740, y: 601, width: 22, height: 21),
                     soundFile: ["kddk1j_wo0131_11kasutanetto", "kddk1e_wo0131_11apairofcastanets"]),
        PlayItemData(itemName: ["らっぱ", "a trumpet"],
                     atariRect: CGRect(x: 622, y: 511, width: 53, height: 64),
                     soundFile: ["kddk1j_wo0132_11rappa", "kddk1e_wo0132_11atrumpet"]),
        PlayItemData(itemName: ["われたたまご", "a broken egg"],
                     atariRect: CGRect(x: 130, y: 404, width: 34, height: 43),
                     soundFile: ["kddk1j_wo0133_11waretatamago", "kddk1e_wo0133_11abrokenegg"]),
        PlayItemData(itemName: ["なべつかみ", "a potholder"],
                     atariRect: CGRect(x: 851, y: 368, width: 51, height: 44),
                     soundFile: ["kddk1j_wo0135_11nabetukami", "kddk1e_wo0135_11apotholder"])
    ]

    // 12ページ
    private static let playItemDataP12 = [
        PlayItemData(itemName: ["ちきゅうぎ", "a globe"],
                     atariRect: CGRect(x: 384, y: 316, width: 55, height: 99),
                     soundFile: ["kddk1j_wo0139_12tikyuugi", "kddk1e_wo0139_12aglobe"]),
        PlayItemData(itemName: ["けんびきょう", "a microscope"],
                     atariRect: CGRect(x: 442, y: 394, width: 35, height: 95),
                     soundFile: ["kddk1j_wo0140_12kenbikyou", "kddk1e_wo0140_12amicroscope"]),
        PlayItemData(itemName: ["あおえんぴつ", "a blue pencil"],
                     atariRect: CGRect(x: 396, y: 419, width: 16, height: 68),
                     soundFile: ["kddk1j_wo0141_12aoenpitu", "kddk1e_wo0141_12abluepencil"]),
        PlayItemData(itemName: ["さんかくじょうぎ", "a triangle"],
                     atariRect: CGRect(x: 687, y: 21, width: 63, height: 55),
                     soundFile: ["kddk1j_wo0142_12sankakujougi", "kddk1e_wo0142_12atriangle"]),
        PlayItemData(itemName: ["りんご", "an apple"],
                     atariRect: CGRect(x: 903, y: 658, width: 43, height: 49),
                     soundFile: ["kddk1j_wo0143_12ringo", "kddk1e_wo0143_12anapple"]),
        PlayItemData(itemName: ["バナナ", "a banana"],
                     atariRect: CGRect(x: 671, y: 365, width: 34, height: 16),
                     soundFile: ["kddk1j_wo0144_12banana", "kddk1e_wo0144_12abanana"]),
        PlayItemData(itemName: ["みどりのながぐつ", "a pair of green rain boots"],
                     atariRect: CGRect(x: 111, y: 317, width: 40, height: 35),
                     soundFile: ["kddk1j_wo0145_12midorinonagagutu", "kddk1e_wo0145_12apairofgreenrainboots"]),
        PlayItemData(itemName: ["ピアノ", "a piano"],
                     atariRect: CGRect(x: 1, y: 382, width: 160, height: 238),
                     soundFile: ["kddk1j_wo0147_12piano", "kddk1e_wo0147_12apiano"]),
        PlayItemData(itemName: ["かめ", "a turtle"],
                     atariRect: CGRect(x: 252, y: 617, width: 43, height: 33),
                     soundFile: ["kddk1j_wo0148_12kame", "kddk1e_wo0148_12aturtle"]),
        PlayItemData(itemName: ["リボン", "a ribbon"],
                     atariRect: CGRect(x: 604, y: 184, width: 26, height: 17),
                     soundFile: ["kddk1j_wo0149_12ribon", "kddk1e_wo0149_12aribbon"])
    ]

    // 13ページ
    private static let playItemDataP13 = [
        PlayItemData(itemName: ["ふくろう", "an owl"],
                     atariRect: CGRect(x: 701, y: 504, width: 86, height: 52),
                     soundFile: ["kddk1j_wo0150_13hukurou", "kddk1e_wo0150_13anowl"]),
        PlayItemData(itemName: ["がいこつ", "a skeleton"],
                     atariRect: CGRect(x: 34, y: 380, width: 176, height: 159),
                     soundFile: ["kddk1j_wo0152_13gaikotu", "kddk1e_wo0152_13askeleton"]),
        PlayItemData(itemName: ["くるま", "a car"],
                     atariRect: CGRect(x: 301, y: 251, width: 25, height: 26),
                     soundFile: ["kddk1j_wo0154_13kuruma", "kddk1e_wo0154_13acar"]),
        PlayItemData(itemName: ["かさ", "an umbrella"],
                     atariRect: CGRect(x: 935, y: 387, width: 49, height: 50),
                     soundFile: ["kddk1j_wo0155_13kasa", "kddk1e_wo0155_13anumbrella"]),
        PlayItemData(itemName: ["えんぴつ", "a pencil"],
                     atariRect: CGRect(x: 786, y: 141, width: 45, height: 54),
                     soundFile: ["kddk1j_wo0156_13enpitu", "kddk1e_wo0156_13apencil"]),
        PlayItemData(itemName: ["けんびきょう", "a microscope"],
                     atariRect: CGRect(x: 521, y: 643, width: 39, height: 62), soundFile: ["kddk1j_wo0157_13kenbikyou", "kddk1e_wo0157_13amicroscope"]),
        PlayItemData(itemName: ["あかいきのこ", "a red mushroom"],
                     atariRect: CGRect(x: 286, y: 595, width: 34, height: 35),
                     soundFile: ["kddk1j_wo0158_13akaikinoko", "kddk1e_wo0158_13aredmushroom"]),
        PlayItemData(itemName: ["とけい", "a clock"],
                     atariRect: CGRect(x: 862, y: 385, width: 69, height: 104),
                     soundFile: ["kddk1j_wo0159_13tokei", "kddk1e_wo0159_13aclock"]),
        PlayItemData(itemName: ["とりかご", "a bird cage"],
                     atariRect: CGRect(x: 706, y: 596, width: 53, height: 80),
                     soundFile: ["kddk1j_wo0160_13torikago", "kddk1e_wo0160_13abirdcage"]),
        PlayItemData(itemName: ["てんとうむし", "a ladybug"],
                     atariRect: CGRect(x: 112, y: 315, width: 15, height: 17),
                     soundFile: ["kddk1j_wo0161_13tentoumusi", "kddk1e_wo0161_13aladybug"])
    ]

    // 14ページ
    private static let playItemDataP14 = [
        PlayItemData(itemName: ["5", "the number of five"],
                     atariRect: CGRect(x: 201, y: 415, width: 78, height: 54),
                     soundFile: ["kddk1j_wo0162_14go", "kddk1e_wo0162_14thenumberoffive"]),
        PlayItemData(itemName: ["りす", "the kissing squirrels"],
                     atariRect: CGRect(x: 825, y: 280, width: 77, height: 126),
                     soundFile: ["kddk1j_wo0163_14risu", "kddk1e_wo0163_14thekissingsquirrels"]),
        PlayItemData(itemName: ["かえる", "a frog"],
                     atariRect: CGRect(x: 725, y: 1, width: 103, height: 104),
                     soundFile: ["kddk1j_wo0164_14kaeru", "kddk1e_wo0164_14afrog"]),
        PlayItemData(itemName: ["うさぎ", "a rabbit"],
                     atariRect: CGRect(x: 228, y: 236, width: 52, height: 62),
                     soundFile: ["kddk1j_wo0166_14usagi", "kddk1e_wo0166_14arabbit"]),
        PlayItemData(itemName: ["きのこ", "a mushroom"],
                     atariRect: CGRect(x: 496, y: 458, width: 32, height: 42),
                     soundFile: ["kddk1j_wo0167_14kinoko", "kddk1e_wo0167_14amushroom"]),
        PlayItemData(itemName: ["ねずみ", "a mouse"],
                     atariRect: CGRect(x: 863, y: 198, width: 70, height: 39),
                     soundFile: ["kddk1j_wo0168_14nezumi", "kddk1e_wo0168_14amouse"]),
        PlayItemData(itemName: ["パラソル", "a parasol"],
                     atariRect: CGRect(x: 253, y: 155, width: 58, height: 77),
                     soundFile: ["kddk1j_wo0169_14parasoru", "kddk1e_wo0169_14aparasol"]),
        PlayItemData(itemName: ["ボール", "a ball"],
                     atariRect: CGRect(x: 160, y: 281, width: 66, height: 74),
                     soundFile: ["kddk1j_wo0170_14bouru", "kddk1e_wo0170_14aball"]),
        PlayItemData(itemName: ["カスタネット", "a pair of castanets"],
                     atariRect: CGRect(x: 360, y: 414, width: 30, height: 30),
                     soundFile: ["kddk1j_wo0171_14kasutanetto", "kddk1e_wo0171_14apairofcastanets"]),
        PlayItemData(itemName: ["かめ", "a turtle"],
                     atariRect: CGRect(x: 740, y: 468, width: 85, height: 86),
                     soundFile: ["kddk1j_wo0172_14kame", "kddk1e_wo0172_14aturtle"])
    ]

    // 15ページ
    private static let playItemDataP15 = [
        PlayItemData(itemName: ["Ａ", "a striped letter Ａ"],
                     atariRect: CGRect(x: 32, y: 557, width: 36, height: 44),
                     soundFile: ["kddk1j_wo0173_15a", "kddk1e_wo0173_15astripedlettera"]),
        PlayItemData(itemName: ["あおいとり", "a blue bird"],
                     atariRect: CGRect(x: 161, y: 51, width: 36, height: 25),
                     soundFile: ["kddk1j_wo0174_15aoitori", "kddk1e_wo0174_15abluebird"]),
        PlayItemData(itemName: ["ヘリコプター", "a helicopter"],
                     atariRect: CGRect(x: 36, y: 281, width: 40, height: 27),
                     soundFile: ["kddk1j_wo0175_15herikoputaa", "kddk1e_wo0175_15ahelicopter"]),
        PlayItemData(itemName: ["ハンバーガー", "a hamburger"],
                     atariRect: CGRect(x: 613, y: 363, width: 41, height: 68),
                     soundFile: ["kddk1j_wo0176_15hanbaagaa", "kddk1e_wo0176_15ahamburger"]),
        PlayItemData(itemName: ["きしゃ", "a train"],
                     atariRect: CGRect(x: 581, y: 504, width: 80, height: 51),
                     soundFile: ["kddk1j_wo0178_15kisha", "kddk1e_wo0178_15atrain"]),
        PlayItemData(itemName: ["きんのりんご", "a golden apple"],
                     atariRect: CGRect(x: 703, y: 340, width: 25, height: 26),
                     soundFile: ["kddk1j_wo0179_15kinnoringo", "kddk1e_wo0179_15agoldenapple"]),
        PlayItemData(itemName: ["ひまわり", "a sunflower"],
                     atariRect: CGRect(x: 535, y: 203, width: 39, height: 104),
                     soundFile: ["kddk1j_wo0180_15himawari", "kddk1e_wo0180_15asunflower"]),
        PlayItemData(itemName: ["なべつかみ", "a potholder"],
                     atariRect: CGRect(x: 659, y: 178, width: 41, height: 37),
                     soundFile: ["kddk1j_wo0182_15nabetukami", "kddk1e_wo0182_15apotholder"]),
        PlayItemData(itemName: ["ちきゅうぎ", "a globe"],
                     atariRect: CGRect(x: 454, y: 255, width: 53, height: 85),
                     soundFile: ["kddk1j_wo0183_15tikyuugi", "kddk1e_wo0183_15aglobe"]),
        PlayItemData(itemName: ["いろえんぴつ", "a colored pencil"],
                     atariRect: CGRect(x: 336, y: 370, width: 44, height: 11),
                     soundFile: ["kddk1j_wo0184_15iroenpitu", "kddk1e_wo0184_15acoloredpencil"])
    ]

    // ページ毎アイテムデータ
    private static let playPageData = [
        PlayPageData(itemData: playItemDataP01, itemNum: playItemDataP01.count),
        PlayPageData(itemData: playItemDataP02, itemNum: playItemDataP02.count),
        PlayPageData(itemData: playItemDataP03, itemNum: playItemDataP03.count),
        PlayPageData(itemData: playItemDataP04, itemNum: playItemDataP04.count),
        PlayPageData(itemData: playItemDataP05, itemNum: playItemDataP05.count),
        PlayPageData(itemData: playItemDataP06, itemNum: playItemDataP06.count),
        PlayPageData(itemData: playItemDataP07, itemNum: playItemDataP07.count),
        PlayPageData(itemData: playItemDataP08, itemNum: playItemDataP08.count),
        PlayPageData(itemData: playItemDataP09, itemNum: playItemDataP09.count),
        PlayPageData(itemData: playItemDataP10, itemNum: playItemDataP10.count),
        PlayPageData(itemData: playItemDataP11, itemNum: playItemDataP11.count),
        PlayPageData(itemData: playItemDataP12, itemNum: playItemDataP12.count),
        PlayPageData(itemData: playItemDataP13, itemNum: playItemDataP13.count),
        PlayPageData(itemData: playItemDataP14, itemNum: playItemDataP14.count),
        PlayPageData(itemData: playItemDataP15, itemNum: playItemDataP15.count)
    ]

    // よむモード（中心座標xy,倍率）
    private static let readZoomData = [
        ReadZoomData(point: CGPoint(x: 397, y: 158), ratio: 2.56),  // 1ページ
        ReadZoomData(point: CGPoint(x: 333, y: 494), ratio: 2.56),  // 2ページ
        ReadZoomData(point: CGPoint(x: 815, y: 156), ratio: 2.56),  // 3ページ
        ReadZoomData(point: CGPoint(x: 249, y: 186), ratio: 2.08),  // 4ページ
        ReadZoomData(point: CGPoint(x: 216, y: 370), ratio: 2.56),  // 5ページ
        ReadZoomData(point: CGPoint(x: 150, y: 648), ratio: 3.51),  // 6ページ
        ReadZoomData(point: CGPoint(x: 833, y: 192), ratio: 2.75),  // 7ページ
        ReadZoomData(point: CGPoint(x: 515, y: 215), ratio: 2.11),  // 8ページ
        ReadZoomData(point: CGPoint(x: 381, y: 120), ratio: 3.53),  // 9ページ
        ReadZoomData(point: CGPoint(x: 822, y: 604), ratio: 2.56),  // 10ページ
        ReadZoomData(point: CGPoint(x: 556, y: 337), ratio: 2.10),  // 11ページ
        ReadZoomData(point: CGPoint(x: 483, y: 631), ratio: 3.20),  // 12ページ
        ReadZoomData(point: CGPoint(x: 317, y: 158), ratio: 2.56),  // 13ページ
        ReadZoomData(point: CGPoint(x: 770, y: 580), ratio: 2.40),  // 14ページ
        ReadZoomData(point: CGPoint(x: 419, y: 347), ratio: 3.40)   // 15ページ
    ]

    static var lang: Int = 0
    static var readContinueFlag: Bool = false
    static var readCurrentPage: Int = 0
    static var playContinueFlag: Bool = false
    static var playCurrentPage: Int = 0

    static var dataExistFlag: Bool = false
    static var playFindItem = [[PlayFindItem]](repeating: [PlayFindItem](repeating: PlayFindItem(), count: FIND_ITEM_NUM), count: PAGE_NUM)

    class func initialize()
    {
        readUserDefault()
    }

    class private func readUserDefault()
    {
        let ud = UserDefaults.standard

        dataExistFlag = ud.bool(forKey: "DataExistFlag")
        lang = ud.integer(forKey: "Lang")
        readContinueFlag = ud.bool(forKey: "ReadContinueFlag")
        readCurrentPage = ud.integer(forKey: "ReadCurrentPage")
        playContinueFlag = ud.bool(forKey: "PlayContinueFlag")
        playCurrentPage = ud.integer(forKey: "PlayCurrentPage")
        if let data = UserDefaults.standard.value(forKey:"PlayFindItem") as? Data {
            playFindItem = try! PropertyListDecoder().decode([[PlayFindItem]].self, from: data) as [[PlayFindItem]]
        } else {
            initPlayFindData()
        }

        // 初回は本体のロケール設定に合わせる
        if !dataExistFlag {
            let languages = NSLocale.preferredLanguages
            lang = languages[0].prefix(2) == "ja" ? LANG_JPN : LANG_ENG
        }
    }

    class func initPlayFindData()
    {
        // 各ページ毎に６つ選択
        for i in 0 ..< PAGE_NUM {
            initPlayFindPage(page: i)
        }
    }

    class func initPlayFindPage(page: Int)
    {
        var r = 0

        // 乱数初期化
        //srand((uint)time(NULL))
        
        for i in 0 ..< FIND_ITEM_NUM {
            while true {
                r = Int.random(in: 0 ..< playPageData[page].itemNum)
                var j = 0
                while j < i {
                    if r == playFindItem[page][j].itemIndex {
                        break
                    }
                    j += 1
                }
                if j == i {
                    break
                }
            }
            playFindItem[page][i].itemIndex = r
            playFindItem[page][i].findFlag = false
        }
    }

    class func saveData()
    {
        dataExistFlag = true
        let ud = UserDefaults.standard
        ud.set(dataExistFlag, forKey:"DataExistFlag")
        ud.set(lang, forKey:"Lang")
        ud.set(readContinueFlag, forKey:"ReadContinueFlag")
        ud.set(readCurrentPage, forKey:"ReadCurrentPage")
        ud.set(playContinueFlag, forKey:"PlayContinueFlag")
        ud.set(playCurrentPage, forKey:"PlayCurrentPage")
        ud.set(try? PropertyListEncoder().encode(playFindItem), forKey:"PlayFindItem")
    }

    class func clearData()
    {
        readContinueFlag = false
        readCurrentPage = 0
        playContinueFlag = false
        playCurrentPage = 0
        initPlayFindData()
        saveData()
    }

    class func getBgMovieFile(page: Int) -> String
    {
        return String(format: "kddk1a_loop_p%02d", page + 1)
    }

    class func getBgImageFile(page: Int) -> String
    {
        return String(format: "kddk1a_loop_p%02d_stl", page + 1)
    }

    class func getBgSoundFile(page: Int) -> String
    {
        return String(format: "kddk1a_loop_p%02d", page + 1)
    }

    class func getCompleteMovieFile(page: Int) -> String
    {
        let page = 8
        return String(format: "doko_%02dbg_complete", page + 1)
    }

    class func getPlayItemName(page: Int, index: Int) -> String
    {
        return DataManager.playPageData[page].itemData[index].itemName[lang]
    }

    class func getPlayAtariRect(page: Int, index: Int) -> CGRect
    {
        return DataManager.playPageData[page].itemData[index].atariRect
    }

    class func getPlaySoundFile(page: Int, index: Int) -> String
    {
        return DataManager.playPageData[page].itemData[index].soundFile[lang]
    }

    class func getReadSentenceSoundFile(page: Int, viewIndex: Int, lineIndex: Int, sentenceIndex: Int) -> String
    {
        return String(format: "kddk1%@_re%02d_%d%@%d", lang == LANG_JPN ? "j" : "e", page + 1, viewIndex + 1, lineIndex == 0 ? "a" : "b", sentenceIndex + 1)
    }

    class func getReadTextFile(page: Int) -> String
    {
        return String(format: "kddk1%@_re%02d", lang == LANG_JPN ? "j" : "e", page + 1)
    }

    class func getReadZoomPoint(page: Int) -> CGPoint
    {
        return DataManager.readZoomData[page].point
    }

    class func getReadZoomRatio(page: Int) -> CGFloat
    {
        return DataManager.readZoomData[page].ratio
    }

    class func getImage(jpnFileName: String, engFileName: String) -> UIImage
    {
        let path = Bundle.main.path(forResource: (lang == LANG_JPN ? jpnFileName : engFileName), ofType: "png")!
        return UIImage(contentsOfFile: path)!
    }
}
