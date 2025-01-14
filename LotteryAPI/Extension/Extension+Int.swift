//
//  Extension+Int.swift
//  LotteryAPI
//
//  Created by 박준우 on 1/14/25.
//

import UIKit

extension Int {
    func returnLotteryResultString() -> NSAttributedString {
        let mutableString = NSMutableAttributedString(string: "\(self)회", attributes: [.foregroundColor: UIColor.orange, .font: UIFont.boldSystemFont(ofSize: 24)])
        mutableString.append(NSAttributedString(string: " 당첨결과", attributes: [.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 24)]))
        return mutableString
    }
}
