//
//  ReadModeViewController.swift
//  DokoMorinonakanosagashimono
//
//  Created by 相沢伸一 on 2021/02/24.
//

import UIKit
import AVFoundation

private let TEXT1_HEIGHT:CGFloat = 690
private let TEXT2_HEIGHT:CGFloat = 720
private let PAGE_SPACE:CGFloat = 30
private let ZOOM_SPEED = 10.0

class ReadModeViewController: UIViewController, AVAudioPlayerDelegate, UIScrollViewDelegate, IndexViewDelegete
{
    struct SentenceData {
        var sentence: String!
        var soundFile: String!
        var viewIndex: Int!
        var lineIndex: Int!
        var viewSize: CGSize!
    }

    struct ReadData {
        var textLabel: UILabel!
        var soundFile: String!
    }
    
    @IBOutlet var guideView: UIView!
    @IBOutlet var guideImageView: UIImageView!   // 操作ガイドイメージビュー
    @IBOutlet var startButton: UIButton!         // スタートボタン
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var indexView: IndexView!
    @IBOutlet var maskView: UIView!
    @IBOutlet var indexButton: UIButton!
    @IBOutlet var endButton: UIButton!
    @IBOutlet var endMarkView: UIImageView!     // ページ終了マークビュー

    private var bgMovie: AVPlayer!                      // BGムービー
    private var bgMovieLayer: AVPlayerLayer!
    private var textFont: UIFont!                       // テキスト用フォント
    private var midashiFont: UIFont!                    // 小見出し用フォント
    private var sentenceArray: [SentenceData]!          // 語句の配列
    private var readDataArray: [ReadData]!              // 読み上げデータの配列
    private var currentPage: Int = 0                    // 現在ページ
    private var sentenceCounter: Int = 0                // 語句読み上げカウンタ
    private var readCounter: Int = 0                    // テキスト読み上げカウンタ
    private var pageControlUsed: Bool = false           // ページ制御中フラグ
    private var bgViews = [UIView?](repeating: nil, count: PAGE_NUM)    // ページ毎のBGビュー配列
    private var bgImageViews = [UIImageView?](repeating: nil, count: PAGE_NUM)  // ページ毎の静止画ビュー配列
    private var scrollFlag: Bool = false                // スクロール中フラグ
    private var enableTouch: Bool = false               // タッチ有効フラグ
    private var indexAnimationFlag = false

    private var bgmAudio: AVAudioPlayer!
    private var readAudio: AVAudioPlayer!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // 現在ページ取得
        currentPage = DataManager.readCurrentPage

        // フォント作成
        textFont = UIFont(name: "HiraKakuProN-W6", size: 20)!
        midashiFont = UIFont(name: "HiraKakuProN-W6", size: 26)!

        // 配列初期化
        sentenceArray = []
        readDataArray = []

        // BGムービー初期化
    //    bgMovie = [[AVPlayer alloc] init]

        // スクロールビュー設定
        scrollView.delegate = self
        scrollView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH + PAGE_SPACE, height: SCREEN_HEIGHT)
        scrollView.contentSize = CGSize(width: (SCREEN_WIDTH + PAGE_SPACE) * CGFloat((PAGE_NUM + 2)), height: SCREEN_HEIGHT)

        // インデックス設定
        indexView.indexViewDelegate = self
        indexView.closeIndex(animation: false, endMethod: nil)

        // 初回は操作ガイド表示
        if !DataManager.readContinueFlag {
            displayGuide()
            DataManager.readContinueFlag = true
        } else {
            continueGuide()
        }
    }

    // 操作ガイド表示
    private func displayGuide()
    {
        guideImageView.image = DataManager.getImage(jpnFileName: "kddk1j_guide_yomu", engFileName: "kddk1e_guide_yomu")
        startButton.setImage(DataManager.getImage(jpnFileName: "kddk1j_btn_guide_n___x423y666w172h35", engFileName: "kddk1e_btn_guide_n___x423y666w172h35"), for: UIControl.State.normal)
        startButton.setImage(DataManager.getImage(jpnFileName: "kddk1j_btn_guide_r___x423y666w172h35", engFileName: "kddk1e_btn_guide_r___x423y666w172h35"), for: UIControl.State.highlighted)
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
                        
                        // 読むモード開始
                        self.startReadFirst()
                       })
    }

    // ２回目以降
    private func continueGuide()
    {
        // インデックス表示
        indexView.openIndex(page: -1, animation: false)

        // 現在ページのサムネイル用をマスクするためのビュー
        let rect = indexView.frame
        indexView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - rect.size.height, width: rect.size.width, height: rect.size.height)
        indexView.isUserInteractionEnabled = false
        indexView.isHidden = false
        maskView.frame = indexView.getThumbnailView(page: currentPage).frame
        maskView.alpha = 0.0
        indexView.addSubview(maskView)
        
        indexAnimationFlag = true
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if indexAnimationFlag {
            indexAnimationFlag = false
            
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
    }

    // インデックス消去
    private func endContinueGuide()
    {
        indexView.closeIndex(animation: true, endMethod: endContinueGuide2)
    }

    // マスクビュー消去
    private func endContinueGuide2()
    {
        maskView.removeFromSuperview()

        startReadFirst()
    }

    // よむモードの開始
    private func startReadFirst()
    {
        endButton.isHidden = false
        indexButton.isHidden = false
        indexView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        enableTouch = true

        createBgView()
        startReadMode(fadeIn: true)
    }

    // BGビュー作成
    private func createBgView()
    {
        var imageView: UIImageView

        // BGビュー作成
        for i in 0 ..< PAGE_NUM {
            let view = UIView(frame: CGRect(x: CGFloat((i + 1)) * (SCREEN_WIDTH + PAGE_SPACE), y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            view.clipsToBounds = true
            scrollView.addSubview(view)
            bgViews[i] = view
        }

        // 1ページ目の前にタイトル画面を入れる
        let image = DataManager.getImage(jpnFileName: "kddk1j_op", engFileName: "kddk1e_op")
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        scrollView.addSubview(imageView)

        // 最終ページ目の次にタイトル画面を入れる
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: CGFloat((PAGE_NUM + 1)) * (SCREEN_WIDTH + PAGE_SPACE), y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        scrollView.addSubview(imageView)
    }

    // 「よむモード」開始処理
    private func startReadMode(fadeIn: Bool)
    {
        // ページ位置設定
        pageControlUsed = true
        scrollView.setContentOffset(CGPoint(x: (currentPage + 1) * Int((SCREEN_WIDTH + PAGE_SPACE)), y: 0), animated: false)

        // 現在ページ保存
        DataManager.readCurrentPage = currentPage
        
        // BGムービー再生
        startBgMovie(fadeIn: !fadeIn)

        // BGM再生
        bgmAudio = SoundManager.initializeSound(soundFile: DataManager.getBgSoundFile(page: currentPage))
        bgmAudio.numberOfLoops = -1
        bgmAudio.volume = 1.0
        bgmAudio.play()

        if fadeIn {
            // viewフェードイン
            view.alpha = 0.0
            UIView.animate(withDuration: 2.0, animations: {self.view.alpha = 1.0}, completion: {_ in self.startTextData()})
        } else {
            // テキスト再生
            startTextData()
        }
    }

    // 「よむモード」停止処理
    private func stopReadMode()
    {
        stopTextData()
        stopBgMovie()
        bgmAudio.stop()
    }

    // BGムービー開始
    private func startBgMovie(fadeIn: Bool)
    {
        // 背景静止画設定
        setBgImage(page: currentPage - 2)
        setBgImage(page: currentPage - 1)
        setBgImage(page: currentPage)
        setBgImage(page: currentPage + 1)
        setBgImage(page: currentPage + 2)
        
        // BGムービー設定
        let path = Bundle.main.path(forResource: DataManager.getBgMovieFile(page: currentPage), ofType: "mp4")!
        bgMovie = AVPlayer(url: URL(fileURLWithPath: path))
        bgMovieLayer = AVPlayerLayer(player: bgMovie)
        let zoomPoint = DataManager.getReadZoomPoint(page: currentPage)
        let zoomRatio = DataManager.getReadZoomRatio(page: currentPage)
        bgMovieLayer.frame = CGRect(x: (SCREEN_WIDTH / 2 - zoomPoint.x) * CGFloat(zoomRatio), y: (SCREEN_HEIGHT / 2 - zoomPoint.y) * CGFloat(zoomRatio), width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        bgMovieLayer.transform = CATransform3DScale(bgMovieLayer.transform, zoomRatio, zoomRatio, 1)
        bgImageViews[currentPage]?.alpha = fadeIn ? 1.0 : 0.0
        bgViews[currentPage]?.layer.insertSublayer(bgMovieLayer, at:0)
        bgMovie.play()

        // ズームアウト
        UIView.animate(withDuration: ZOOM_SPEED,
                       delay: 2.0,
                       options: .allowUserInteraction,
                       animations: {
                        self.bgMovieLayer.transform = CATransform3DScale(self.bgMovieLayer.transform, 1.0, 1.0, 1.0)
                        self.bgMovieLayer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                       },
                       completion: nil)

        // ムービーフェードイン
        if fadeIn {
            UIView.animate(withDuration: 0.5, delay: 0.7, options: [], animations: {self.bgImageViews[self.currentPage]?.alpha = 0.0}, completion: nil)
        }
    }

    // BGムービー停止
    private func stopBgMovie()
    {
        // BGムービー停止
        bgMovie.pause()

        // ページ終了マーク消去
        endMarkView.removeFromSuperview()
    }

    // 背景の静止画を設定
    private func setBgImage(page: Int)
    {
        if page < 0 || page >= PAGE_NUM {
            return
        }
        
        if bgImageViews[page] == nil {
            let path = Bundle.main.path(forResource: DataManager.getBgImageFile(page: page), ofType: "png")!
            let imageView = UIImageView(image: UIImage(contentsOfFile: path))
            let zoomPoint = DataManager.getReadZoomPoint(page: page)
            let zoomRatio = DataManager.getReadZoomRatio(page: page)
            imageView.frame = CGRect(x: SCREEN_WIDTH / 2 - zoomPoint.x * zoomRatio, y: SCREEN_HEIGHT / 2 - zoomPoint.y * zoomRatio, width: SCREEN_WIDTH * zoomRatio, height: SCREEN_HEIGHT * zoomRatio)
            bgViews[page]!.addSubview(imageView)
            bgImageViews[page] = imageView
        } else {
            bgImageViews[page]!.alpha = 1.0
        }
    }

    // テキスト表示／再生開始
    private func startTextData()
    {
        sentenceCounter = 0
        readTextData()
        setTextData()
    }

    // テキスト表示／再生停止
    private func stopTextData()
    {
        readAudio.stop()
        readAudio = nil
        sentenceArray.removeAll()
        removeReadData(readDataArray: &readDataArray)
    }

    // テキストファイル読み込み
    private func readTextData()
    {
        let path = Bundle.main.path(forResource: DataManager.getReadTextFile(page: currentPage), ofType: "txt")
        let text: String
        do {
            text = try String(contentsOfFile: path!, encoding: String.Encoding.shiftJIS)
        } catch _ {
            text = ""
        }
        let lines = text.components(separatedBy: "\r\n")
        var viewIndex = 0
        var lineIndex = 0
        
        sentenceArray.removeAll()
        
        for lineText in lines {
            let lineText2 = lineText.trimmingCharacters(in: NSCharacterSet.whitespaces)
            if lineText2.count != 0 {
                var sentenceIndex = 0
                let sentences = lineText2.components(separatedBy: DataManager.lang == LANG_JPN ? "," : "@")
                for sentence in sentences {
                    if sentence.count != 0 {
                        var sentenceData = SentenceData()
                        sentenceData.sentence = sentence
                        sentenceData.soundFile = DataManager.getReadSentenceSoundFile(page: currentPage, viewIndex: viewIndex, lineIndex: lineIndex, sentenceIndex: sentenceIndex)
                        sentenceData.viewIndex = viewIndex
                        sentenceData.lineIndex = lineIndex
                        let bounds = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                        let nsstr = sentenceData.sentence as NSString
                        sentenceData.viewSize = nsstr.boundingRect(with: bounds, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:(viewIndex == 0 ? midashiFont : textFont)!], context: nil).size
                        sentenceArray.append(sentenceData)
                        sentenceIndex += 1
                    }
                }
                lineIndex += 1
            } else {
                lineIndex = 0
                viewIndex += 1
            }
        }
    }

    // テキストデータ表示／再生設定
    private func setTextData()
    {
        if readCounter >= readDataArray.count {
            if sentenceCounter >= sentenceArray.count {
                if sentenceArray.count != 0 {
                    bgViews[currentPage]?.addSubview(endMarkView)
                }
                return
            } else {
                removeReadData(readDataArray: &readDataArray)

                let sentenceData = sentenceArray[sentenceCounter]
                let viewIndex = sentenceData.viewIndex

                var width1:CGFloat = 0
                var width2:CGFloat = 0
                var sentenceCounter2 = sentenceCounter
                while sentenceCounter2 < sentenceArray.count {
                    let sentenceData = sentenceArray[sentenceCounter2]
                    
                    if viewIndex != sentenceData.viewIndex {
                        break
                    }

                    if sentenceData.lineIndex == 0 {
                        width1 += sentenceData.viewSize.width
                    } else {
                        width2 += sentenceData.viewSize.width
                    }
                    
                    sentenceCounter2 += 1
                }
                
                let leftMargin = (SCREEN_WIDTH - max(width1, width2)) / 2
                var x = leftMargin
                var lineIndex = 0
                
                while sentenceCounter < sentenceArray.count {
                    let sentenceData = sentenceArray[sentenceCounter]

                    if viewIndex != sentenceData.viewIndex {
                        break
                    }
                    
                    if lineIndex != sentenceData.lineIndex {
                        x = leftMargin
                    }

                    var readData = ReadData()
                    readData.textLabel = UILabel()
                    readData.soundFile = sentenceData.soundFile

                    readData.textLabel.font = sentenceCounter == 0 ? midashiFont : textFont
                    readData.textLabel.frame = CGRect(x: x, y: sentenceData.lineIndex == 0 ? TEXT1_HEIGHT : TEXT2_HEIGHT, width: sentenceData.viewSize.width, height: sentenceData.viewSize.height)
                    readData.textLabel.text = sentenceData.sentence
                    readData.textLabel.textColor = UIColor(ciColor: .white)
                    readData.textLabel.backgroundColor = UIColor(ciColor: .clear)
                    readData.textLabel.shadowColor = UIColor(ciColor: .black)
                    readData.textLabel.shadowOffset = CGSize(width: 1, height: 1)
                    bgViews[currentPage]?.addSubview(readData.textLabel)
                    readDataArray.append(readData)

                    sentenceCounter += 1

                    x += sentenceData.viewSize.width
                    lineIndex = sentenceData.lineIndex
                }

                readCounter = 0
            }
        }

        let readData = readDataArray[readCounter]

        // 文字の色替え
        readData.textLabel.textColor = UIColor(red: 1.0, green: 0.6, blue: 0.7, alpha: 1.0)
        
        // 音声再生
        readAudio = SoundManager.initializeSound(soundFile: readData.soundFile)
        readAudio.delegate = self
        readAudio.play()
        
        readCounter += 1
    }

    private func removeReadData(readDataArray: inout [ReadData])
    {
        for readData in readDataArray {
            readData.textLabel.removeFromSuperview()
        }
        
        readDataArray.removeAll()
    }

    // 音声再生終了
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        setTextData()
    }

    // スクロールによるページ替え
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        // ページ制御中なら何もしない
        if pageControlUsed {
            return
        }

        // スクロール中でなければ効果音再生
        if !scrollFlag {
            scrollFlag = true
            SoundManager.playOpenSound()
        }

        // スクロールが終わったらそのページを開始
        let offset = floor(scrollView.contentOffset.x)
        if Int(offset) % Int(SCREEN_WIDTH + PAGE_SPACE) == 0 {
            scrollFlag = false
            
            let n = Int(offset) / Int(SCREEN_WIDTH + PAGE_SPACE)
            if n == 0 || n == PAGE_NUM + 1 {
                returnMenu(fadeout: false)
            } else {
                if currentPage != n - 1 {
                    currentPage = n - 1
                    stopReadMode()
                    startReadMode(fadeIn: false)
                    if indexView.openFlag {
                        indexView.setCurrentPage(page: currentPage)
                    }
                }
            }
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        pageControlUsed = false
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControlUsed = false
    }

    // メインメニューに戻る
    private func returnMenu(fadeout: Bool)
    {
        if fadeout {
            enableTouch = false
            view.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.5, animations: {self.view.alpha = 0.0}, completion: {_ in self.endReturnMenu()})
        } else {
            endReturnMenu()
        }
    }

    // メインメニューに戻る
    private func endReturnMenu()
    {
        indexView.indexViewDelegate = nil
        
        // よむモード停止処理
        stopReadMode()
        
        // 現在の状態を保存
        DataManager.saveData()
        
        // 親コントローラに通知
        (presentingViewController as! DokoViewController).playMenuBgSound()
        
        // この画面を閉じる
        dismiss(animated: false, completion:nil)
    }

    // インデックスからページ選択
    func selectPage(page:Int)
    {
        currentPage = page
     
        SoundManager.playOpenSound()
        indexView.closeIndex(animation: true, endMethod: endSelectPage)
    }

    // ページ選択後よむモード開始
    private func endSelectPage()
    {
        UIView.animate(withDuration: 0.5,
                       animations: {self.view.alpha = 0.0},
                       completion: {_ in
                        self.stopReadMode()
                        self.startReadMode(fadeIn: true)
                       })
    }

    // インデックスボタン処理
    @IBAction func indexButton(_ sender: AnyObject)
    {
        if indexView.openFlag {
            // インデックスが開いているなら閉じる
            SoundManager.playCloseSound()
            indexView.closeIndex(animation: true, endMethod: nil)
        } else {
            // インデックスが閉じているなら開く
            SoundManager.playOpenSound()
            indexView.openIndex(page: currentPage, animation: true)
        }
    }

    // 終了ボタン
    @IBAction func endButton(_ sender: AnyObject)
    {
        // 閉じる音
        SoundManager.playCloseSound()
        
        returnMenu(fadeout: true)
    }

    // 画面タッチ
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if !enableTouch {
            return
        }

        let touch = touches.first!
        if touch.tapCount == 1 {
            // インデックス表示中なら閉じる
            if indexView.openFlag {
                SoundManager.playCloseSound()
                indexView.closeIndex(animation: true, endMethod: nil)
            }
        }
    }
}
