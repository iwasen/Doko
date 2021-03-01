//
//  IndexView.swift
//  DokoMorinonakanosagashimono
//
//  Created by 相沢伸一 on 2021/02/25.
//

import UIKit

protocol IndexViewDelegete: NSObject
{
    func selectPage(page: Int)
}

let THUMBNAIL_WIDTH: CGFloat = 50
let THUMBNAIL_HEIGHT: CGFloat = 50
let SELECTED_THUMBNAIL_WIDTH: CGFloat = 75
let SELECTED_THUMBNAIL_HEIGHT: CGFloat = 75
let THUMBNAIL_SPACE: CGFloat = 10
let THUMBNAIL_OFFSET: CGFloat = 80
let INDEX_HEIGHT: CGFloat = 70

class IndexView: UIView {
    var indexViewDelegate: IndexViewDelegete?
    var openFlag: Bool = false

    var thumbnailViews: [ThumbnailView] = []
    var endHideIndexMethod: Selector?
    var currentPage: Int = 0
    var animationFlag: Bool = false
    var endAnimationSel: Selector?

    override func awakeFromNib()
    {
        super.awakeFromNib()

        // サムネイルを作成
        for i in 0 ..< PAGE_NUM {
            let fileName = String(format: "kddk1a_subber_thum_%02d", i + 1)
            let path = Bundle.main.path(forResource: fileName, ofType: "png")
            let view = ThumbnailView(image: UIImage(contentsOfFile: path!))
            view.page = i
            view.isUserInteractionEnabled = true
            addSubview(view)
            thumbnailViews.append(view)
        }
        
        setThumbnailsPosition(page: -1)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    - (void)drawRect:(CGRect)rect
    {
        // Drawing code
    }
    */

    // サムネイルタッチ処理
    func touchThumbnail(page: Int)
    {
        if page == currentPage {
            indexViewDelegate?.selectPage(page: page)
        } else {
            setCurrentPage(page: page)
        }
    }

    // インデックス表示処理
    func openIndex(page: Int, animation: Bool)
    {
        if animationFlag {
            return
        }
        
        openFlag = true
        
        setThumbnailsPosition(page: page)

        isHidden = false

        let indexSize = frame.size
        if animation {
            animationFlag = true
            if currentPage != -1 {
                let rect = thumbnailViews[currentPage].frame
                thumbnailViews[currentPage].frame = CGRect(x: rect.origin.x, y: rect.origin.y + (SELECTED_THUMBNAIL_HEIGHT - THUMBNAIL_HEIGHT), width: rect.size.width, height: rect.size.height)
            }
            frame = CGRect(x: 0, y: SCREEN_HEIGHT - (indexSize.height - INDEX_HEIGHT), width: indexSize.width, height: indexSize.height)
            UIView.animate(withDuration: 0.5,
                           animations: {
                            self.frame = CGRect(x: 0, y: SCREEN_HEIGHT - indexSize.height - 20, width: indexSize.width, height: indexSize.height)
                            if self.currentPage != -1 {
                                let rect = self.thumbnailViews[self.currentPage].frame
                                self.thumbnailViews[self.currentPage].frame = CGRect(x: rect.origin.x, y: rect.origin.y - (SELECTED_THUMBNAIL_HEIGHT - THUMBNAIL_HEIGHT), width: rect.size.width, height: rect.size.height)
                            }
                           },
                           completion: {_ in self.endOpenIndex()})
        } else {
            frame = CGRect(x: 0, y: SCREEN_HEIGHT - indexSize.height, width: indexSize.width, height: indexSize.height)
        }
    }

    // インデックス表示完了処理
    func endOpenIndex()
    {
        let indexSize = frame.size
        UIView.animate(withDuration: 0.2,
                       animations: {self.frame = CGRect(x: 0, y: SCREEN_HEIGHT - indexSize.height, width: indexSize.width, height: indexSize.height)},
                       completion: {_ in self.animationFlag = false})
    }

    // インデックス消去処理
    func closeIndex(animation: Bool, endMethod: Selector?)
    {
        if animationFlag {
            return
        }
        
        openFlag = false
        endHideIndexMethod = endMethod
        endAnimationSel = endMethod

        let indexSize = frame.size
        if animation {
            animationFlag = true
            UIView.animate(withDuration: 0.5,
                           animations: {
                            self.frame = CGRect(x: 0, y: SCREEN_HEIGHT - (indexSize.height - INDEX_HEIGHT), width: indexSize.width, height: indexSize.height)
                            if self.currentPage != -1 {
                                let rect = self.thumbnailViews[self.currentPage].frame
                                self.thumbnailViews[self.currentPage].frame = CGRect(x: rect.origin.x, y: rect.origin.y + (SELECTED_THUMBNAIL_HEIGHT - THUMBNAIL_HEIGHT), width: rect.size.width, height: rect.size.height)
                            }
                           },
                           completion: {_ in self.endCloseIndex()})
        } else {
            frame = CGRect(x: 0, y: SCREEN_HEIGHT - (indexSize.height - INDEX_HEIGHT), width: indexSize.width, height: indexSize.height)
        }
    }

    func endCloseIndex()
    {
        animationFlag = false
        if indexViewDelegate != nil && endAnimationSel != nil {
            indexViewDelegate?.perform(endAnimationSel)
        }
    }

    // ページに対応したサムネイルを取得
    func getThumbnailView(page: Int) -> UIImageView
    {
        return thumbnailViews[page]
    }

    // サムネイルの表示位置を設定
    func setThumbnailsPosition(page: Int)
    {
        currentPage = page
        
        let indexSize = frame.size
        var offset = (page == -1) ? (SCREEN_WIDTH - (THUMBNAIL_WIDTH * CGFloat(PAGE_NUM) + THUMBNAIL_SPACE * CGFloat(PAGE_NUM - 1))) / 2 : THUMBNAIL_OFFSET
        for i in 0 ..< PAGE_NUM {
            let thumbnail = thumbnailViews[i]
            if thumbnail.page == page {
                thumbnail.frame = CGRect(x: offset, y: indexSize.height - SELECTED_THUMBNAIL_HEIGHT - 10, width: SELECTED_THUMBNAIL_WIDTH, height: SELECTED_THUMBNAIL_HEIGHT)
                offset += SELECTED_THUMBNAIL_WIDTH + THUMBNAIL_SPACE
            } else {
                thumbnail.frame = CGRect(x: offset, y: indexSize.height - THUMBNAIL_HEIGHT - 10, width: THUMBNAIL_WIDTH, height: THUMBNAIL_HEIGHT)
                offset += THUMBNAIL_WIDTH + THUMBNAIL_SPACE
            }
        }
    }

    // 現在ページを設定
    func setCurrentPage(page: Int)
    {
        UIView.animate(withDuration: 0.2, animations: {self.setThumbnailsPosition(page: page)})
    }
}
