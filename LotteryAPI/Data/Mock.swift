//
//  Mock.swift
//  LotteryAPI
//
//  Created by 박준우 on 2/24/25.
//

import Foundation

struct Mock {
    static let lottery: Lottery = Lottery(returnValue: "success", drwNoDate: "2025-01-11", drwNo: 1154, drwtNo1: 4, drwtNo2: 8, drwtNo3: 22, drwtNo4: 26, drwtNo5: 32, drwtNo6: 38, bnusNo: 27)
}
