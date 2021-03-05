//
//  SubmenuView.swift
//  DokoMorinonakanosagashimono
//
//  Created by 相沢伸一 on 2021/02/21.
//

import UIKit

class SubmenuView: UIView
{
    var openFlag: Bool = false
    
    // サブメニューを表示
    func openSubmenu(animation: Bool)
    {
        openFlag = true

        let indexSize = frame.size
        if animation {
            frame = CGRect(x: 0, y: SCREEN_HEIGHT - (indexSize.height - INDEX_HEIGHT), width: indexSize.width, height: indexSize.height)
            UIView.animate(withDuration: 0.5,
                           animations: {self.frame = CGRect(x: 0, y: SCREEN_HEIGHT - indexSize.height - 20, width: indexSize.width, height: indexSize.height)},
                           completion: {_ in self.endOpenSubmenu()})
        } else {
            frame = CGRect(x: 0, y: SCREEN_HEIGHT - indexSize.height, width: indexSize.width, height: indexSize.height)
        }
    }

    // サブメニュー表示完了
    private func endOpenSubmenu()
    {
        let indexSize = frame.size
        UIView.animate(withDuration: 0.2, animations: {self.frame = CGRect(x: 0, y: SCREEN_HEIGHT - indexSize.height, width: indexSize.width, height: indexSize.height)})
    }

    // サブメニューを閉じる
    func closeSubmenu(animation: Bool)
    {
        openFlag = false
        
        let indexSize = frame.size
        if animation {
            UIView.animate(withDuration: 0.5, animations:{self.frame = CGRect(x: 0, y: SCREEN_HEIGHT - (indexSize.height - INDEX_HEIGHT), width: indexSize.width, height: indexSize.height)})
        } else {
            frame = CGRect(x: 0, y: SCREEN_HEIGHT - (indexSize.height - INDEX_HEIGHT), width: indexSize.width, height: indexSize.height)
        }
    }
}
