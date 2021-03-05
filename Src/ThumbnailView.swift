//
//  ThumbnailView.swift
//  DokoMorinonakanosagashimono
//
//  Created by 相沢伸一 on 2021/02/25.
//

import UIKit

class ThumbnailView: UIImageView {
    var page: Int = 0
        
    // サムネイルタッチ処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // 親ビューに通知
        let indexView = superview as! IndexView
        indexView.touchThumbnail(page: page)
    }
}
