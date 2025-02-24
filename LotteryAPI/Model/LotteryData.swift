//
//  LotteryData.swift
//  LotteryAPI
//
//  Created by 박준우 on 1/14/25.
//

import UIKit
import Alamofire

struct LotteryData: Decodable {
//    let totSellamnt: Int
    let returnValue: String
//    let firstWinamnt: Int
//    let firstPrzwnerCo: Int
//    let firstAccumamnt: Int
    let drwNoDate: String
    let drwNo: Int
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    let bnusNo: Int
    
    static let lotteryMockData: LotteryData = LotteryData(returnValue: "success", drwNoDate: "2025-01-11", drwNo: 1154, drwtNo1: 4, drwtNo2: 8, drwtNo3: 22, drwtNo4: 26, drwtNo5: 32, drwtNo6: 38, bnusNo: 27)
    
    func getDrwNo(index: Int) -> Int? {
        switch index {
        case 0: return self.drwtNo1
        case 1: return self.drwtNo2
        case 2: return self.drwtNo3
        case 3: return self.drwtNo4
        case 4: return self.drwtNo5
        case 5: return self.drwtNo6
        case 7: return self.bnusNo
        default: return nil
        }
    }
    
    func getDrwNoColor(number: Int) -> UIColor {
        switch number {
        case 1...10: return .orange
        case 11...20: return .systemTeal
        case 21...30: return .systemPink
        case 31...40: return .lightGray
        case 41...: return .systemGreen
        default: return .black
        }
    }
}
