//
//  SoundManager.swift
//  DokoMorinonakanosagashimono
//
//  Created by 相沢伸一 on 2021/02/24.
//

import UIKit
import AVFoundation

var soundManager: SoundManager!

class SoundManager {
    var playButtonSound: AVAudioPlayer!
    var readButtonSound: AVAudioPlayer!
    var openButtonSound: AVAudioPlayer!
    var closeButtonSound: AVAudioPlayer!

    // 初期化処理
    init()
    {
        playButtonSound = initializeSound(soundFile: "kddk1a_btn_asob")
        readButtonSound = initializeSound(soundFile: "kddk1a_btn_yomu")
        openButtonSound = initializeSound(soundFile: "kddk1a_bar_indexbtn")
        closeButtonSound = initializeSound(soundFile: "kddk1a_bar_menubtn")
    }

    // サウンドファイル名からAVAudioPlayerを作成
    func initializeSound(soundFile: String) -> AVAudioPlayer
    {
        var audioPlayer: AVAudioPlayer?
        
        let path = Bundle.main.path(forResource: soundFile, ofType: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
        } catch _ {
        }
        
        return audioPlayer!
    }

    // あそぶモードボタンの音を再生
    func playPlaySound()
    {
        playButtonSound.currentTime = 0
        playButtonSound!.play()
    }

    // よむモードボタンの音を再生
    func playReadSound()
    {
        readButtonSound!.currentTime = 0
        readButtonSound!.play()
    }

    // 開くアクションの音を再生
    func playOpenSound()
    {
        openButtonSound!.currentTime = 0
        openButtonSound!.play()
    }

    // 閉じるアクションの音を再生
    func playCloseSound()
    {
        closeButtonSound!.currentTime = 0
        closeButtonSound!.play()
    }

}
