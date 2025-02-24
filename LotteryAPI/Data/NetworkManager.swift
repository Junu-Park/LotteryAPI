//
//  NetworkManager.swift
//  LotteryAPI
//
//  Created by 박준우 on 2/24/25.
//

import Foundation

import RxSwift

enum LotteryError: Error {
    case invalidURL
    case requestError
    case errorStatusCode
    case nilData
    case decodingError
}

final class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    
    private init() { }
    
    func requestLotteryWithObservable(round: Int) -> Observable<Lottery> {
        return Observable.create { value in
            let urlString = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(round)"
            
            guard let url = URL(string: urlString) else {
                value.onError(LotteryError.invalidURL)
                
                return Disposables.create {
                    print("invalidURL")
                }
            }
            
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error == nil {
                    value.onError(LotteryError.requestError)
                }
                
                guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    value.onError(LotteryError.errorStatusCode)
                    return
                }
                
                guard let data else {
                    value.onError(LotteryError.nilData)
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode(Lottery.self, from: data)
                    value.onNext(decodedData)
                } catch {
                    value.onError(LotteryError.decodingError)
                }
            }
            return Disposables.create {
                print("끝")
            }
        }
    }
    
    func requestLotteryWithSingle(round: Int) -> Single<[Lottery]> {
        return Single<[Lottery]>.create { value in
            let urlString = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(round)"
            
            guard let url = URL(string: urlString) else {
                value(.failure(LotteryError.invalidURL))
                
                return Disposables.create {
                    print("invalidURL")
                }
            }
            
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error == nil {
                    value(.failure(LotteryError.requestError))
                }
                
                guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    value(.failure(LotteryError.errorStatusCode))
                    return
                }
                
                guard let data else {
                    value(.failure(LotteryError.nilData))
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode(Lottery.self, from: data)
                    value(.success(Array(repeating: decodedData, count: 8)))
                } catch {
                    value(.failure(LotteryError.decodingError))
                }
            }
            .resume()
            
            return Disposables.create {
                print("끝")
            }
        }
    }
}
