//
//  Extension+String.swift
//  LotteryAPI
//
//  Created by 박준우 on 1/14/25.
//

import Foundation

extension String {
    func returnLotteryDateString() -> String {
        return "\(self) 추첨"
    }
    
    func convertToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self) ?? Date()
    }
}
