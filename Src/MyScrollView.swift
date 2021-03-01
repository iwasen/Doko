//
//  MyScrollView.swift
//  DokoMorinonakanosagashimono
//
//  Created by 相沢伸一 on 2021/02/25.
//

import UIKit

class MyScrollView: UIScrollView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        next?.touchesBegan(touches, with: event)
    }
}
