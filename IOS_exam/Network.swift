//
//  Network.swift
//  IOS_exam
//
//  Created by Илья Володин on 19.12.2023.
//

import Foundation

class Network {
    private enum Constants {
        static let adress: String = "https://api.coinranking.com/v2/"
        static let apiKey: String = "coinranking3a52b8f37cb61499794cfdb3e8c11bda28fdc4122bbaf2cb"
    }
    
    func getList(completion: @escaping ([Coin]) -> Void) {
        if let url = URL(string: Constants.adress + "coins") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(Constants.apiKey, forHTTPHeaderField: "x-access-token")
            
            let task = URLSession.shared.dataTask(with: request) { data, responce, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        completion(try jsonDecoder.decode(ResponceLIst.self, from: data).data.coins)
                    } catch {
                        print("list", error)
                        return
                    }
                }
                
            }
            
            task.resume()
        }
    }
    
    func getCoinPrice(time: String, uuid: String,completion: @escaping (String) -> Void) {
        if let url = URL(string: Constants.adress + "coin/\(uuid)/price?timestamp=\(time)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(Constants.apiKey, forHTTPHeaderField: "x-access-token")
            
            let task = URLSession.shared.dataTask(with: request) { data, responce, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        completion(try jsonDecoder.decode(ResponceSingle.self, from: data).data.price)
                    } catch {
                        completion(try! jsonDecoder.decode(ErrorResponse.self, from: data).status)
                        return
                    }
                }
                
            }
            
            task.resume()
        }
    }
}
    
struct ResponceLIst: Codable {
    let data: DataAll
}

struct DataAll: Codable {
    let coins: [Coin]
}

struct Coin: Codable {
    let uuid: String
    let name: String
    let price: String
}

struct DataSingle: Codable {
    let price: String
}

struct ResponceSingle: Codable {
    let data: DataSingle
}

struct ErrorResponse: Codable {
    let status: String
    let type: String
    let message:String
}
