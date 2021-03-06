//
//  SoundManager.swift
//  DokoMorinonakanosagashimono
//
//  Created by 相沢伸一 on 2021/02/24.
//

import UIKit
import AVFoundation

class SoundManager
{
    private static var playButtonSound: AVAudioPlayer!
    private static var readButtonSound: AVAudioPlayer!
    private static var openButtonSound: AVAudioPlayer!
    private static var closeButtonSound: AVAudioPlayer!

    // 初期化処理
    class func initialize()
    {
        playButtonSound = initializeSound(soundFile: "kddk1a_btn_asob")
        readButtonSound = initializeSound(soundFile: "kddk1a_btn_yomu")
        openButtonSound = initializeSound(soundFile: "kddk1a_bar_indexbtn")
        closeButtonSound = initializeSound(soundFile: "kddk1a_bar_menubtn")
    }

    // サウンドファイル名からAVAudioPlayerを作成
    class func initializeSound(soundFile: String) -> AVAudioPlayer
    {
        let path = Bundle.main.path(forResource: soundFile, ofType: "mp3")
        let audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
        
        return audioPlayer
    }

    // あそぶモードボタンの音を再生
    class func playPlaySound()
    {
        playButtonSound.currentTime = 0
        playButtonSound.play()
    }

    // よむモードボタンの音を再生
    class func playReadSound()
    {
        readButtonSound.currentTime = 0
        readButtonSound.play()
    }

    // 開くアクションの音を再生
    class func playOpenSound()
    {
        openButtonSound.currentTime = 0
        openButtonSound.play()
    }

    // 閉じるアクションの音を再生
    class func playCloseSound()
    {
        closeButtonSound.currentTime = 0
        closeButtonSound.play()
    }

}
