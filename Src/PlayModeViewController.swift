//
//  PlayModeViewController.swift
//  DokoMorinonakanosagashimono
//
//  Created by 相沢伸一 on 2021/02/24.
//

import UIKit
import AVFoundation

let sounfEffectFile: [String] = [
    "doko_word01in",
    "doko_word02in",
    "doko_word03in",
    "doko_word04in",
    "doko_word05in",
    "doko_word06in"
]

class PlayModeViewController: UIViewController, UIScrollViewDelegate, IndexViewDelegete {
    @IBOutlet var guideView: UIView!                   // 操作ガイドビュー
    @IBOutlet var guideImageView: UIImageView!         // 操作ガイドイメージビュー
    @IBOutlet var startButton: UIButton!               // スタートボタン
    @IBOutlet var maskView: UIView!                    // サムネイルのマスクビュー
    @IBOutlet var scrollView: MyScrollView!            // スクロールビュー
    @IBOutlet var bgView: UIView!                      // 背景ビュー
    @IBOutlet var atariView: UIView!                   // 当たりボタンビュー
    @IBOutlet var baseView: UIView!                    // テキスト表示ビュー
    @IBOutlet var indexView: IndexView!                // インデックスビュー
    @IBOutlet var indexButton: UIButton!               // インデックス表示ボタン
    @IBOutlet var endButton: UIButton!                 // あそぶモード終了ボタン
    @IBOutlet var completeJpnImageView: UIImageView!   // コンプリート文字ビュー（日本語）
    @IBOutlet var completeEngImageView: UIImageView!   // コンプリート文字ビュー（英語）

    var bgMovie: AVPlayer!                  // 背景動画
    var bgMovieLayer: AVPlayerLayer!

    var currentPage = 0                     // 現在ページ
    var itemCount = 0                       // アイテム名読み上げカウンタ
    var readStopFlag = false                // よむモード終了フラグ
    var readTextTimer: Timer!               // アイテム名読み上げタイマー
    var completeCounter = 0                 // コンプリートアニメーションカウンタ
    var completeImageView: UIImageView!     // コンプリート文字ビュー
    var completeStopFlag = false            // コンプリート停止フラグ
    var enableTouch = false                 // タッチ有効フラグ
    
    var atariButtonArray: [UIButton]!       // 当たりボタンの配列
    var textViewArray: [UILabel]!           // アイテム名表示用ビューの配列

    var bgmAudio: AVAudioPlayer!
    var atariAudio: AVAudioPlayer!
    var itemSEAudio: AVAudioPlayer!
    var itemAudio: AVAudioPlayer!
    var completeAudio: AVAudioPlayer!
    var dokoAudio: AVAudioPlayer!
    
    func endAnimation() {
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 現在ページを取得
        currentPage = dataManager.playCurrentPage

        // 配列を初期化
        atariButtonArray = []
        textViewArray = []

        // スクロールビューの設定
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.delegate = self
        scrollView.contentSize = bgView.frame.size

        // インデックスビューの設定
        indexView.indexViewDelegate = self
        indexView.closeIndex(animation: false, endMethod: nil)

        // BGムービー初期化
        bgMovie = AVPlayer()

        // 初回は操作ガイド表示
        if !dataManager.playContinueFlag {
            displayGuide()
            dataManager.playContinueFlag = true
        } else {
            continueGuide()
        }
    }

    // 操作ガイド表示
    func displayGuide()
    {
        guideImageView.image = dataManager.getImage(jpnFileName: "kddk1j_guide_asob", engFileName: "kddk1e_guide_asobu")
        startButton.setImage(dataManager.getImage(jpnFileName: "kddk1j_btn_guide_n___x423y666w172h35", engFileName: "kddk1e_btn_guide_n___x423y666w172h35"), for: UIControl.State.normal)
        startButton.setImage(dataManager.getImage(jpnFileName: "kddk1j_btn_guide_r___x423y666w172h35", engFileName: "kddk1e_btn_guide_r___x423y666w172h35"), for: UIControl.State.highlighted)
        view.addSubview(guideView)
    }

    // スタートボタンタッチ
    @IBAction func touchStartButton(_ sender: AnyObject)
    {
        UIView.animate(withDuration: 0.5,
                       animations: {self.guideView.alpha = 0.0},
                       completion: {_ in
                        // 操作ガイド画面を閉じる
                        self.guideView.removeFromSuperview()

                        // あそぶモード開始
                        self.startPlayFirst()
                       })
    }

    // ２回目以降
    func continueGuide()
    {
        // インデックス表示
        indexView.openIndex(page: -1, animation: false)
        
        // 現在ページのサムネイル用をマスクするためのビュー
        let rect = indexView.frame
        indexView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - rect.size.height, width: rect.size.width, height: rect.size.height)
        indexView.isUserInteractionEnabled = false
        indexView.isHidden = false
        let thumbnail = indexView.getThumbnailView(page: currentPage)
        maskView.frame = thumbnail.frame
        maskView.alpha = 0.0
        indexView.addSubview(maskView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 現在ページのサムネイルを3回点滅
        UIView.animate(withDuration: 0.2,
                       delay: 0.5,
                       options: [],
                       animations: {
                        UIView.modifyAnimations(withRepeatCount: 3, autoreverses: true, animations: {
                            self.maskView.alpha = 0.7
                        })
                       },
                       completion: {_ in self.endContinueGuide()})
    }

    // インデックス消去
    func endContinueGuide()
    {
        indexView.closeIndex(animation: true, endMethod: #selector(endContinueGuide2))
    }

    // マスクビュー消去
    @objc func endContinueGuide2()
    {
        maskView.removeFromSuperview()
        startPlayFirst()
    }

    // あそぶモードの開始
    func startPlayFirst()
    {
        endButton.isHidden = false
        indexButton.isHidden = false
        baseView.isHidden = false
        indexView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        enableTouch = true

        startPlayMode()
    }

    // あそぶモード開始
    func startPlayMode()
    {
        // 現在ページ保存
        dataManager.playCurrentPage = currentPage
        
        readStopFlag = false

        setupBgView()
        setFindItem()

        scrollView.zoomScale = 1.0

        // viewフェードイン
        view.alpha = 0.0
        UIView.animate(withDuration: 2.0,
                       animations: {self.view.alpha = 1.0},
                       completion: {_ in self.readItemName()})
    }

    // あそぶモード停止
    func stopPlayMode()
    {
        // 当たりボタンを削除
        for atariButton in atariButtonArray {
            atariButton.removeFromSuperview()
        }
        atariButtonArray.removeAll()

        // アイテム名テキストビューを削除
        for textView in textViewArray {
            textView.removeFromSuperview()
        }
        textViewArray.removeAll()

        // 停止フラグセット
        readStopFlag = true
        
        // 読み上げ待ち停止
        NSObject.cancelPreviousPerformRequests(withTarget: self)

        // 読み上げタイマー停止
        if readTextTimer != nil {
            readTextTimer.invalidate()
            readTextTimer = nil
        }

        // コンプリート停止
        if completeImageView != nil {
            completeImageView.removeFromSuperview()
            completeStopFlag = true
        }
        
        // 各サウンド停止
        itemAudio.stop()
        itemSEAudio.stop()
        bgMovie.pause()
        bgmAudio.stop()
    }

    // 背景動画、BGM再生
    func setupBgView()
    {
        // BGM再生
        bgmAudio = soundManager.initializeSound(soundFile: dataManager.getBgSoundFile(page: currentPage))
        bgmAudio.numberOfLoops = -1
        bgmAudio.volume = 1.0
        bgmAudio.play()
        
        // 背景動画再生
        let moviePath = Bundle.main.path(forResource: dataManager.getBgMovieFile(page: currentPage), ofType: "mp4")!
        let bgItem = AVPlayerItem(url: URL(fileURLWithPath: moviePath))
        bgMovie.replaceCurrentItem(with: bgItem)
        bgMovieLayer = AVPlayerLayer(player: bgMovie)
        bgMovieLayer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        bgView.layer.addSublayer(bgMovieLayer)
        bgMovie.play()
    }

    //　アイテム名読み上げ待ち
    @objc func readItemName()
    {
        // アイテム表示まで2秒待つ
        perform(#selector(readItemName2), with:nil, afterDelay:2.0)
    }

    //　アイテム名読み上げタイマーセット
    @objc func readItemName2()
    {
        // アイテム名読み上げカウンタクリア
        itemCount = 0

        // １つ目のアイテム読み上げ
        setItemText()
        itemCount += 1

        // ２つ目以降のアイテム読み上げタイマー設定
        readTextTimer = Timer.scheduledTimer(timeInterval: 2.8, target: self, selector: #selector(readTextTimer(timer:)), userInfo: nil, repeats: true)
    }

    //　アイテム名読み上げタイマー
    @objc func readTextTimer(timer: Timer)
    {
        if readStopFlag {
            timer.invalidate()
            readTextTimer = nil
            return
        }
        
        if itemCount < FIND_ITEM_NUM {
            // アイテム読み上げ
            setItemText()
            
            itemCount += 1
        } else {
            // タイマー停止
            timer.invalidate()
            readTextTimer = nil
            
            // 「どこ」読み上げ
            dokoAudio = soundManager.initializeSound(soundFile: dataManager.lang == LANG_JPN ? "kddk1j_re_doko" : "kddk1e_re_doko")
            dokoAudio.play()

            // 当たり済みのアイテムを消す
            UIView.animate(withDuration: 0.5,
                           animations: {
                            for i in 0 ..< FIND_ITEM_NUM {
                                if dataManager.playFindItem[self.currentPage][i].findFlag {
                                    self.textViewArray[i].alpha = 0.0
                                }
                            }
                           })
            
            //　アイテムボタン生成
            setItemButton()
            
            completeStopFlag = false
        }
    }

    //　アイテム名（テキスト表示/音声再生）
    func setItemText()
    {
        if readStopFlag {
            return
        }
        
        itemAudio = soundManager.initializeSound(soundFile: dataManager.getPlaySoundFile(page: currentPage, index: dataManager.playFindItem[currentPage][itemCount].itemIndex))
        itemAudio.numberOfLoops = 0
        itemAudio.volume = 1.0
        
        itemSEAudio = soundManager.initializeSound(soundFile: sounfEffectFile[itemCount])
        itemSEAudio.numberOfLoops = 0
        itemSEAudio.volume = 1.0
        
        itemSEAudio.play()
        itemAudio.play()
        
        textViewArray[itemCount].alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {self.textViewArray[self.itemCount].alpha = 1.0})
    }

    //　当たりボタン生成
    func setItemButton()
    {
        for i in 0 ..< FIND_ITEM_NUM {
            if !dataManager.playFindItem[currentPage][i].findFlag {
                atariButtonArray[i].isHidden = false
            }
        }
    }

    // 当たりボタン、アイテム名表示
    func setFindItem()
    {
        var i: Int
        var textSize: [CGSize] = [CGSize](repeating: CGSize(width: 0, height: 0), count: FIND_ITEM_NUM)

        // 全部回答済みなら再度選択
        i = 0
        while i < FIND_ITEM_NUM {
            if !dataManager.playFindItem[currentPage][i].findFlag {
                break
            }
            i += 1
        }
        if i == FIND_ITEM_NUM {
            dataManager.initPlayFindPage(page: currentPage)
        }
        
        var font: UIFont?
        var margin: CGFloat = 0
        var fontSize: CGFloat = 26
        var totalTextWidth: CGFloat
        while (true) {
            // フォント作成
            font = UIFont(name: "HiraKakuProN-W6", size: fontSize)!
            
            // 全部のテキストの長さを求める
            totalTextWidth = 0
            for i in 0 ..< FIND_ITEM_NUM {
                let bounds = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                let str = NSString(string: dataManager.getPlayItemName(page: currentPage, index: dataManager.playFindItem[currentPage][i].itemIndex))
                textSize[i] = str.boundingRect(with: bounds, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font!], context: nil).size

                totalTextWidth += textSize[i].width
            }

            // テキスト間のマージン
            margin = (SCREEN_WIDTH - totalTextWidth) / CGFloat((FIND_ITEM_NUM + 1))
            
            if margin > 20 {
                break
            } else {
                // 入りきらなければフォントサイズを小さくする
                fontSize -= 1
            }
        }

        atariButtonArray.removeAll()
        textViewArray.removeAll()
        var x = margin
        for i in 0 ..< FIND_ITEM_NUM {
            // 当たりボタン生成
            let atariButton = UIButton(type: UIButton.ButtonType.roundedRect)
            atariButton.frame = dataManager.getPlayAtariRect(page: currentPage, index: dataManager.playFindItem[currentPage][i].itemIndex)
            atariButton.addTarget(self, action:#selector(clickItem), for: UIControl.Event.touchUpInside)
            atariButton.isHidden = true
            atariView.addSubview(atariButton)
            atariButtonArray.append(atariButton)

            // アイテム名表示
            let rect = CGRect(x: x, y: 20, width: textSize[i].width, height: textSize[i].height)
            let textView = UILabel(frame: rect)
            textView.font = font
            textView.text = dataManager.getPlayItemName(page: currentPage, index: dataManager.playFindItem[currentPage][i].itemIndex)
            textView.alpha = 0.0
            textView.textColor = UIColor(ciColor: .white)
            textView.backgroundColor = UIColor(ciColor: .clear)
            baseView.addSubview(textView)
            textViewArray.append(textView)
            
            x += textSize[i].width + margin
        }
    }

    // アイテムクリック
    @objc func clickItem(inSender: NSObject)
    {
        var i: Int
        
        i = 0
        while i < FIND_ITEM_NUM {
            if inSender == atariButtonArray[i] {
                break
            }
            i += 1
        }
        if i == FIND_ITEM_NUM {
            return
        }
        
        dataManager.playFindItem[currentPage][i].findFlag = true
        
        atariButtonArray[i].isHidden = true

        // 当たりパーティクル再生
        let rect = dataManager.getPlayAtariRect(page: currentPage, index: dataManager.playFindItem[currentPage][i].itemIndex)
        viewAtariParticle(point: CGPoint(x: rect.origin.x + rect.size.width / 2, y: rect.origin.y + rect.size.height / 2))

        // 当たり効果音再生
        atariAudio = soundManager.initializeSound(soundFile: "doko_word_ok")
        atariAudio.numberOfLoops = 0
        atariAudio.volume = 1.0
        atariAudio.play()

        // 当たりアイテム名再生
        itemAudio = soundManager.initializeSound(soundFile: dataManager.getPlaySoundFile(page: currentPage, index: dataManager.playFindItem[currentPage][i].itemIndex))
        itemAudio.numberOfLoops = 0
        itemAudio.volume = 1.0
        itemAudio.play()

        // 当たりテキスト消去
        UIView.animate(withDuration: 3.0, animations: {self.textViewArray[i].alpha = 0.0})

        // コンプリートチェック
        i = 0
        while i < FIND_ITEM_NUM {
            if !dataManager.playFindItem[currentPage][i].findFlag {
                break
            }
            i += 1
        }
        if i == FIND_ITEM_NUM {
            perform(#selector(playComplete), with: nil, afterDelay: 3.0)
        }
    }

    //　当たりパーティクル再生
    func viewAtariParticle(point: CGPoint)
    {
        let imageArray: [UIImage] = [
                               UIImage(named: "fx_atari_a0001.png")!,
                               UIImage(named: "fx_atari_a0002.png")!,
                               UIImage(named: "fx_atari_a0003.png")!,
                               UIImage(named: "fx_atari_a0004.png")!,
                               UIImage(named: "fx_atari_a0005.png")!,
                               UIImage(named: "fx_atari_a0006.png")!,
                               UIImage(named: "fx_atari_a0007.png")!,
                               UIImage(named: "fx_atari_a0008.png")!,
                               UIImage(named: "fx_atari_a0009.png")!,
                               UIImage(named: "fx_atari_a0010.png")!,
                               UIImage(named: "fx_atari_a0011.png")!,
                               UIImage(named: "fx_atari_a0012.png")!,
                               UIImage(named: "fx_atari_a0013.png")!,
                               UIImage(named: "fx_atari_a0014.png")!,
                               UIImage(named: "fx_atari_a0015.png")!,
                               UIImage(named: "fx_atari_a0016.png")!,
                               UIImage(named: "fx_atari_a0017.png")!,
                               UIImage(named: "fx_atari_a0018.png")!,
                               ]
        let rect = CGRect(x: point.x - 143, y: point.y - 102, width: 288, height: 288)
        let atariAnimation = UIImageView(frame: rect)
        atariAnimation.animationImages = imageArray
        atariAnimation.animationRepeatCount = 1
        atariAnimation.animationDuration = 3.0
        bgView.addSubview(atariAnimation)
        atariAnimation.startAnimating()
        
        perform(#selector(endAtariParticle(atariAnimation:)), with: atariAnimation, afterDelay: 3.0)
    }

    // 当たりパーティクル再生終了
    @objc func endAtariParticle(atariAnimation: UIImageView)
    {
        atariAnimation.removeFromSuperview()
    }

    // コンプリート画面処理
    @objc func playComplete()
    {
        if completeStopFlag {
            return
        }
        
        if dataManager.lang == LANG_JPN {
            completeImageView = completeJpnImageView
            completeImageView.frame = CGRect(x: 244, y: 351, width: completeImageView.frame.size.width, height: completeImageView.frame.size.height)
        } else {
            completeImageView = completeEngImageView
            completeImageView.frame = CGRect(x: 215, y: 351, width: completeImageView.frame.size.width, height: completeImageView.frame.size.height)
        }
        completeImageView.alpha = 0.0
        view.addSubview(completeImageView)
        
        UIView.animate(withDuration: 0.5, animations: {self.completeImageView.alpha = 1.0}, completion: {_ in self.playComplete2()})
    }

    // コンプリート画面処理2
    func playComplete2()
    {
        if completeStopFlag {
            return
        }
        
        // BGM停止
        bgmAudio.stop()
        
        // コンプリート音
        completeAudio = soundManager.initializeSound(soundFile: "kddk1a_comp")
        completeAudio.play()

        UIView.animate(withDuration: 1.5, delay: 4.0, options: [], animations: {self.completeImageView.alpha = 0.0}, completion: {_ in self.playComplete4()})

        completeCounter = 0
        for i in 0 ..< FIND_ITEM_NUM {
            let point = CGPoint(x: 0, y: 0)
            perform(#selector(playComplete3), with: nil, afterDelay: Double(i) * 0.3)
            viewAtariParticle(point: point)
        }
    }

    // コンプリート画面処理3
    @objc func playComplete3()
    {
        if completeStopFlag {
            return
        }
        
        let rect = dataManager.getPlayAtariRect(page: currentPage, index: dataManager.playFindItem[currentPage][completeCounter].itemIndex)
        completeCounter += 1
        let point = CGPoint(x: rect.origin.x + rect.size.width / 2, y: rect.origin.y + rect.size.height / 2)
        viewAtariParticle(point: point)
    }

    // コンプリート画面処理4
    func playComplete4()
    {
        if completeStopFlag {
            return
        }
        
        UIView.animate(withDuration: 2.0, animations: {self.view.alpha = 0.0}, completion: {_ in self.playComplete5()})
    }

    // コンプリート画面処理5
    func playComplete5()
    {
        if completeStopFlag {
            return
        }
        
        completeImageView.removeFromSuperview()
        
        currentPage += 1
        if currentPage == PAGE_NUM {
            dataManager.playCurrentPage = 0
            returnMenu()
        } else {
            stopPlayMode()
            startPlayMode()
        }
    }

    //　メニューに戻る
    func returnMenu()
    {
        readStopFlag = true
        enableTouch = false
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5, animations: {self.view.alpha = 0.0}, completion: {_ in self.endReturnMenu()})
    }

    // メニューに戻る
    func endReturnMenu()
    {
        // あそぶモード停止
        stopPlayMode()
        
        // 現在の状態を保存
        dataManager.saveData()
        
        // 親コントローラに通知
        (presentingViewController as! DokoViewController).playMenuBgSound()
        
        // 元の画面に戻る
        dismiss(animated: false, completion:nil)
    }

    // 画面をダブルクリック
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if !enableTouch {
            return
        }
        
        let touch = touches.first!
        switch (touch.tapCount) {
        case 1:
            if indexView.openFlag {
                soundManager.playCloseSound()
                indexView.closeIndex(animation: true, endMethod: nil)
            }
            break
        case 2:
            if scrollView.zoomScale != 1.0 {
                scrollView.zoom(to: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), animated:true)
            } else {
                let point = touch.location(in: bgView)
                scrollView.zoom(to: CGRect(x: point.x / 2, y: point.y / 2, width: SCREEN_WIDTH / 2, height: SCREEN_HEIGHT / 2), animated:true)
            }
            break
        default:
            break
        }
    }

    // インデックスボタンクリック
    @IBAction func indexButton(_ sender: AnyObject)
    {
        if indexView.openFlag {
            soundManager.playCloseSound()
            indexView.closeIndex(animation: true, endMethod: nil)
        } else {
            soundManager.playOpenSound()
            indexView.openIndex(page: currentPage, animation: true)
        }
    }

    // ページ替え
    func selectPage(page: Int)
    {
        currentPage = page

        indexView.closeIndex(animation: true, endMethod: #selector(endSelectPage))
    }

    @objc func endSelectPage()
    {
        UIView.animate(withDuration: 0.5,
                       animations: {self.view.alpha = 0.0},
                       completion: {_ in
                        self.stopPlayMode()
                        self.startPlayMode()
                       })
    }

    // メニューへ戻るボタンクリック
    @IBAction func endButton(_ sender: AnyObject)
    {
        // 閉じる音
        soundManager.playCloseSound()

        returnMenu()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return bgView
    }
}