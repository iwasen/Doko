//
//  DokoViewController.swift
//  DokoMorinonakanosagashimono
//
//  Created by 相沢伸一 on 2021/02/21.
//

import UIKit
import AVKit

class DokoViewController: UIViewController
{
    @IBOutlet var titleBaseView: UIView!
    @IBOutlet var titleImageView: UIImageView!
    @IBOutlet var submenuView: SubmenuView!
    @IBOutlet var aboutView: UIView!
    @IBOutlet var howtoView: UIImageView!
    @IBOutlet var optionView: UIView!
    @IBOutlet var playModeButton: UIButton!
    @IBOutlet var readModeButton: UIButton!
    @IBOutlet var aboutButton: UIButton!
    @IBOutlet var howtoButton: UIButton!
    @IBOutlet var optionButton: UIButton!
    @IBOutlet var nihongoButton: UIButton!
    @IBOutlet var eigoButton: UIButton!
    @IBOutlet var shokyoButton: UIButton!
    @IBOutlet var shokyoView: UIView!
    @IBOutlet var shokyoSuruButton: UIButton!
    @IBOutlet var shokyoShinaiButton: UIButton!
    @IBOutlet var aboutImageView: UIImageView!
    @IBOutlet var optionImageView: UIImageView!
    @IBOutlet var shokyoImageView: UIImageView!
    @IBOutlet var shokyoShimashitaView: UIImageView!
    @IBOutlet var websiteButton: UIButton!
    @IBOutlet var submenuImageView: UIImageView!

    private var openingMovieLayer: AVPlayerLayer!
    private var bgAudio: AVAudioPlayer!
    private var inOpeningMovie: Bool = false
    private var openingSkipFlag: Bool = false

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setLanguage()
        
        // サブメニュー消去
        submenuView.closeSubmenu(animation: false)

        if openingSkipFlag {
            // メモリ不足で２度目に呼ばれた場合
            view.addSubview(titleBaseView)
            animationSubmenuButton()
        } else {
            openingSkipFlag = true

            startOpeningMovie()
/*
            // ロゴ表示
            view.addSubview(logoView)

            // ロゴをフェードアウト
            UIView.animate(withDuration: 0.5,
                           delay: 0.5,
                           options: [],
                           animations: {self.logoView.alpha = 0.0},
                           completion: {_ in
                            self.startOpeningMovie()
                           })
 */
        }

    }
    // オープニングムービー開始
    private func startOpeningMovie()
    {
/*
        // ロゴを消去
        logoView.removeFromSuperview()
*/
        // オープニングムービー再生
        let moviePath = Bundle.main.path(forResource: DataManager.lang == LANG_JPN ? "kddk1j_op" : "kddk1e_op", ofType: "mp4")!
        let openingMovie = AVPlayer(url: URL(fileURLWithPath: moviePath))
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: openingMovie.currentItem, queue: nil, using: {_ in self.endOpeningMovie()})
        openingMovieLayer = AVPlayerLayer(player: openingMovie)
        openingMovieLayer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        view.layer.addSublayer(openingMovieLayer)
        openingMovie.play()

        // オープニングムービー再生中フラグセット
        inOpeningMovie = true
    }

    // オープニングムービー終了
    private func endOpeningMovie()
    {
        // オープニングムービー再生中フラグリセット
        inOpeningMovie = false
        
        view.isUserInteractionEnabled = true

        // タイトル画面を表示
        titleBaseView.alpha = 0.0
        view.addSubview(titleBaseView)

        // タイトル画面フェードイン
        UIView.animate(withDuration: 1.0,
                       animations: {self.titleBaseView.alpha = 1.0},
                       completion: {_ in
                        self.openingMovieLayer.removeFromSuperlayer()
                        self.openingMovieLayer = nil
                       })
        
        // BGM再生
        playMenuBgSound()
        
        // サブメニューボタンアニメーション
        animationSubmenuButton()
    }

    // 画面タッチ
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // オープニングムービー再生中なら停止
        if inOpeningMovie {
            endOpeningMovie()
        }

        // サブメニュー表示中なら消去
        if aboutButton.isSelected {
            
        } else if howtoButton.isSelected {
            closeHowtoView()
        } else if optionButton.isSelected {
            closeOptionView()
        } else if submenuView.openFlag {
            SoundManager.playCloseSound()
            submenuView.closeSubmenu(animation: true)
        }
    }

    // 言語設定
    private func setLanguage()
    {
        titleImageView.image = DataManager.getImage(
            jpnFileName: "kddk1j_op",
            engFileName: "kddk1e_op")
        playModeButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_btn_asob___x100y340w376h229",
                engFileName: "kddk1e_btn_asob___x100y340w376h229"),
            for: UIControl.State.normal)
        playModeButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_btn_asob_r___x100y340w376h229",
                engFileName: "kddk1e_btn_asob_r___x100y340w376h229"),
            for:UIControl.State.highlighted)
        readModeButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_btn_yomu___x532y340w376h229",
                engFileName: "kddk1e_btn_yomu___x100y340w376h229"),
            for:UIControl.State.normal)
        readModeButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_btn_yomu_r___x100y340w376h229",
                engFileName: "kddk1e_btn_yomu_r___x100y340w376h229"),
            for:UIControl.State.highlighted)
        aboutButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_subber_btn_about_n___x62y706w240h52",
                engFileName: "kddk1e_subber_btn_about_n___x62y706w240h52"),
            for:UIControl.State.normal)
        aboutButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_subber_btn_about_r___x62y706w240h52",
                engFileName: "kddk1e_subber_btn_about_r___x62y706w240h52"),
            for:UIControl.State.highlighted)
        aboutButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_subber_btn_about_c___x62y706w240h52",
                engFileName: "kddk1e_subber_btn_about_c___x62y706w240h52"),
            for:UIControl.State.selected)
        howtoButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_subber_btn_howto_n___x410y704w200h62",
                engFileName: "kddk1e_subber_btn_howto_n___x410y704w200h62"),
            for:UIControl.State.normal)
        howtoButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_subber_btn_howto_r___x410y704w200h62",
                engFileName: "kddk1e_subber_btn_howto_r___x410y704w200h62"),
            for:UIControl.State.highlighted)
        howtoButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_subber_btn_howto_c___x410y704w200h62",
                engFileName: "kddk1e_subber_btn_howto_c___x410y704w200h62"),
            for:UIControl.State.selected)
        optionButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_subber_btn_option_n___x790y706w134h56",
                engFileName: "kddk1e_subber_btn_option_n___x790y706w134h56"),
            for:UIControl.State.normal)
        optionButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_subber_btn_option_r___x790y706w134h56",
                engFileName: "kddk1c_subber_btn_option_r___x790y706w134h56"),
            for:UIControl.State.highlighted)
        optionButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_subber_btn_option_c___x790y706w134h56",
                engFileName: "kddk1c_subber_btn_option_c___x790y706w134h56"),
            for:UIControl.State.selected)
        aboutImageView.image = DataManager.getImage(
            jpnFileName: "kddk1j_subberpopup_about___x62y18w909h683",
            engFileName: "kddk1e_subberpopup_about___x62y18w909h683")
        howtoView.image = DataManager.getImage(
            jpnFileName: "kddk1j_subberpopup_howto___x62y80w901h622",
            engFileName: "kddk1e_subberpopup_howto___x62y80w901h622")
        optionImageView.image = DataManager.getImage(
            jpnFileName: "kddk1j_subberpopup_option___x510y158",
            engFileName: "kddk1e_subberpopup_option___x510y158")
        nihongoButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_subberpopup_option_r_japanese___x164y72w128h49",
                engFileName: "kddk1e_subberpopup_option_r_japanese___x164y72w128h49"),
            for:UIControl.State.selected)
        eigoButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_subberpopup_option_r_english___x292y72w121h49",
                engFileName: "kddk1e_subberpopup_option_r_english___x292y72w121h49"),
            for:UIControl.State.selected)
        shokyoImageView.image = DataManager.getImage(
            jpnFileName: "kddk1j_subberpopup_option_r_erase_menu___x653y323w291h252",
            engFileName: "kddk1e_subberpopup_option_r_erase_menu___x653y323w291h252")
        shokyoShimashitaView.image = DataManager.getImage(
            jpnFileName: "kddk1j_subberpopup_option_r_erase_menu_deleted___x726y499w151h27",
            engFileName: "kddk1e_subberpopup_option_r_erase_menu_deleted___x726y499w151h27")
        shokyoSuruButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_subberpopup_option_r_erase_menu_yes___x673y425w124h49",
                engFileName: "kddk1e_subberpopup_option_r_erase_menu_yes___x673y425w124h49"),
            for:UIControl.State.selected)
        shokyoShinaiButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_subberpopup_option_r_erase_menu_no___x798y425w128h49",
                engFileName: "kddk1e_subberpopup_option_r_erase_menu_no___x798y425w128h49"),
            for:UIControl.State.selected)
        websiteButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_btn_website_n___x737y569w187h28",
                engFileName: "kddk1e_btn_website_n___x737y569w187h28"),
            for:UIControl.State.normal)
        websiteButton.setImage(
            DataManager.getImage(
                jpnFileName: "kddk1j_btn_website02_r___x737y569w187h28",
                engFileName: "kddk1e_btn_website_r___x737y569w187h28"),
            for:UIControl.State.highlighted)
    }

    // よむモードボタンダウン
    @IBAction func touchDownReadButton(_ sender: AnyObject)
    {
        // 効果音再生
        SoundManager.playReadSound()
    }

    // よむモードボタンアップ
    @IBAction func touchUpReadButton(_ sender: AnyObject)
    {
        // タイトル画面をフェードアウト
        UIView.animate(withDuration: 1.0, animations: {self.view.alpha = 0.0}, completion: {_ in self.gotoReadMode()})
    }

    // よむモード開始
    private func gotoReadMode()
    {
        // サブメニューによる画面を閉じる
        closeAboutView()
        closeHowtoView()
        closeOptionView()

        // よむモードの画面へ遷移
        let readModeViewController = ReadModeViewController(nibName: "ReadModeViewController", bundle: Bundle.main)
        readModeViewController.modalPresentationStyle = .fullScreen
        present(readModeViewController,
                animated: false,
                completion: {
                    // フェードアウトしたalpha値を戻しておく
                    self.view.alpha = 1.0

                    // サブメニューを閉じる
                    self.submenuView.closeSubmenu(animation: false)

                    // BGM停止
                    self.bgAudio.stop()
                    self.bgAudio = nil
                }
        )
    }

    // あそぶモードボタンダウン
    @IBAction func touchDownPlayButton(_ sender: AnyObject)
    {
        // 効果音再生
        SoundManager.playPlaySound()
    }

    // あそぶモードボタンアップ
    @IBAction func touchUpPlayButton(_ sender: AnyObject)
    {
        // タイトル画面をフェードアウト
        UIView.animate(withDuration: 1.0,
                       animations: {self.view.alpha = 0.0},
                       completion: {_ in self.gotoPlayMode()})
    }

    // あそぶモード開始
    private func gotoPlayMode()
    {
        // サブメニューによる画面を閉じる
        closeAboutView()
        closeHowtoView()
        closeOptionView()
        
        // あそぶモードの画面へ遷移
        let playMode = PlayModeViewController(nibName: "PlayModeViewController", bundle: Bundle.main)
        playMode.modalPresentationStyle = .fullScreen
        present(playMode,
                animated: false,
                completion: {
                    // フェードアウトしたalpha値を戻しておく
                    self.view.alpha = 1.0

                    // サブメニューを閉じる
                    self.submenuView.closeSubmenu(animation: false)

                    // BGM停止
                    self.bgAudio.stop()
                    self.bgAudio = nil
                }
        )
    }

    // サブメニューボタン
    @IBAction func submenuButton(_ sender: AnyObject)
    {
        if submenuView.openFlag {
            // オープン中ならクローズ
            SoundManager.playCloseSound()
            submenuView.closeSubmenu(animation: true)
        } else {
            // クローズ中ならオープン
            SoundManager.playOpenSound()
            submenuView.openSubmenu(animation: true)
        }
    }

    // ほんについてボタン
    @IBAction func aboutButton(_ sender: AnyObject)
    {
        openAboutView()
    }

    // あそびかたボタン
    @IBAction func howtoButton(_ sender: AnyObject)
    {
        openHowtoView()
    }

    // 設定ボタン
    @IBAction func optionButton(_ sender: AnyObject)
    {
        openOptionView()
    }

    // ほんについての画面を表示
    private func openAboutView()
    {
        if !aboutButton.isSelected {
            SoundManager.playOpenSound()
            closeHowtoView()
            closeOptionView()
            aboutView.frame = CGRect(x: 62, y: 18, width: aboutView.frame.size.width, height: aboutView.frame.size.height)
            view.addSubview(aboutView)
            aboutButton.isSelected = true
            playModeButton.isEnabled = false
            readModeButton.isEnabled = false
        }
    }

    // ほんについての画面を閉じる
    private func closeAboutView()
    {
        if aboutButton.isSelected {
            SoundManager.playCloseSound()
            aboutView.removeFromSuperview()
            aboutButton.isSelected = false
            playModeButton.isEnabled = true
            readModeButton.isEnabled = true
        }
    }

    // あそびかたの画面を表示
    private func openHowtoView()
    {
        if !howtoButton.isSelected {
            SoundManager.playOpenSound()
            closeAboutView()
            closeOptionView()
            howtoView.frame = CGRect(x: 62, y: 80, width: howtoView.frame.size.width, height: howtoView.frame.size.height)
            view.addSubview(howtoView)
            howtoButton.isSelected = true
            playModeButton.isEnabled = false
            readModeButton.isEnabled = false
        }
    }

    // あそびかたの画面を閉じる
    private func closeHowtoView()
    {
        if howtoButton.isSelected {
            SoundManager.playCloseSound()
            howtoView.removeFromSuperview()
            howtoButton.isSelected = false
            playModeButton.isEnabled = true
            readModeButton.isEnabled = true
        }
    }

    // 設定画面を開く
    private func openOptionView()
    {
        if !optionButton.isSelected {
            SoundManager.playOpenSound()
            closeAboutView()
            closeHowtoView()
            nihongoButton.isSelected = DataManager.lang == LANG_JPN
            eigoButton.isSelected = DataManager.lang == LANG_ENG
            shokyoButton.isSelected = false
            optionView.frame = CGRect(x: 510, y: 158, width: optionView.frame.size.width, height: optionView.frame.size.height)
            view.addSubview(optionView)
            optionButton.isSelected = true
            playModeButton.isEnabled = false
            readModeButton.isEnabled = false
            optionView.isUserInteractionEnabled = true
        }
    }

    // 設定画面を閉じる
    private func closeOptionView()
    {
        if optionButton.isSelected {
            SoundManager.playCloseSound()
            optionView.removeFromSuperview()
            shokyoView.removeFromSuperview()
            optionButton.isSelected = false
            playModeButton.isEnabled = true
            readModeButton.isEnabled = true
        }
    }

    // BGM再生
    func playMenuBgSound()
    {
        // BGM再生
        bgAudio = SoundManager.initializeSound(soundFile: "kddk1a_loop_menu")
        bgAudio.numberOfLoops = -1
        bgAudio.play()
    }

    // ウェブサイトへボタン
    @IBAction func websiteButton(_ sender: AnyObject)
    {
        DataManager.saveData()
/*
        let url = URL(string: DataManager.lang == LANG_JPN ? "http://www.bookclub.kodansha.co.jp/books/topics/doko/index.html" : "http://children.kodansha.co.jp/en/index.html")
*/
        let url = URL(string: "https://bookclub.kodansha.co.jp/product?item=0000182460")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!)
        }
    }

    // 日本語ボタン
    @IBAction func nihongoButton(_ sender: AnyObject)
    {
        nihongoButton.isSelected = true
        eigoButton.isSelected = false
        if DataManager.lang != LANG_JPN {
            DataManager.lang = LANG_JPN
            setLanguage()
            DataManager.clearData()
        }
    }

    // 英語ボタン
    @IBAction func eigoButton(_ sender: AnyObject)
    {
        nihongoButton.isSelected = false
        eigoButton.isSelected = true
        if DataManager.lang != LANG_ENG {
            DataManager.lang = LANG_ENG
            setLanguage()
            DataManager.clearData()
        }
    }

    // 消去ボタン
    @IBAction func shokyoButton(_ sender: AnyObject)
    {
        shokyoView.frame = CGRect(x: 653, y: 323, width: shokyoView.frame.size.width, height: shokyoView.frame.size.height)
        shokyoSuruButton.isSelected = false
        shokyoShinaiButton.isSelected = false
        shokyoShimashitaView.isHidden = true
        view.addSubview(shokyoView)
        optionView.isUserInteractionEnabled = false
    }

    // 消去するボタン
    @IBAction func shokyoSuruButton(_ sender: AnyObject)
    {
        shokyoSuruButton.isSelected = true
        shokyoShinaiButton.isSelected = false

        DataManager.clearData()
        shokyoShimashitaView.isHidden = false
    }

    // 消去しないボタン
    @IBAction func shokyoShinaiButton(_ sender: AnyObject)
    {
        shokyoSuruButton.isSelected = false
        shokyoShinaiButton.isSelected = true
        shokyoView.removeFromSuperview()
        optionView.isUserInteractionEnabled = true
    }

    // ほんについて閉じるボタン
    @IBAction func aboutCloseButton(_ sender: AnyObject)
    {
        closeAboutView()
    }

    // サブメニューボタンアニメーション
    private func animationSubmenuButton()
    {
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       options: [.allowUserInteraction, .repeat, .autoreverse],
                       animations: {self.submenuImageView.alpha = 0.0},
                       completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        openingSkipFlag = true
        if openingMovieLayer != nil {
            openingMovieLayer.player?.pause()
            openingMovieLayer.removeFromSuperlayer()
            openingMovieLayer = nil
        }
    }
}
