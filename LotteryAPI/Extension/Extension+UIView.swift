//
//  Extension+UIView.swift
//  LotteryAPI
//
//  Created by 박준우 on 1/14/25.
//

import UIKit

extension UIView {
    // TODO: 다양한 뷰들의 타입을 리스트로 받아오고 싶다면? 가변 파라미터? => 배열로 받아오는거랑 뭐가 달라?
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
