//
//  StockWeekData.swift
//  UTraders
//
//  Created by Izzo, Christopher J on 12/9/18.
//  Copyright © 2018 CJ Izzo. All rights reserved.
//

import Foundation

struct AssetWeekData: Decodable {
    let date: String
    let open: Float
    let high: Float
    let low: Float
    let close: Float
    let volume: Float
    let adjClose: Float
    
    private enum CodingKeys: String, CodingKey {
        case date = "date"
        case open = "open"
        case high = "high"
        case low = "low"
        case close = "close"
        case volume = "volume"
        case adjClose = "adj_close"
    }
}

struct AssetWeekStock: Decodable {
    let stockNums: [AssetWeekData]
    
    private enum CodingKeys: String, CodingKey {
        case stockNums = "data"
    }
    
}
protocol StockWeekDataProtocol {
    func stockWeekDataHandler(data:AssetWeekStock)
    func responseErrorHandler2(error:String)
}
class StockWeekData {
    private let urlSession = URLSession.shared
    private let apiKey = "&api_key=OjA5MGVkNzRkMzZhMzU0Y2VmZmY4YjNhNmJlYmVmODM4"
    private let stockUrl = "https://api.intrinio.com/prices?identifier="
    
    var delegate:StockWeekDataProtocol? = nil
    
    func formatDate(date:Date) -> String {
        var newDate = ""
        for ch in "\(date)" {
            if ch == " " {
                break
            } else if ch == "-" {
                continue
            } else {
                newDate += "\(ch)"
            }
        }
        return newDate
    }
    
    func getAssetWeekData(identifier:String) {
        var date = Date()
        date = date - (86400 * 30 as TimeInterval)
        let weekAgo = "&start_date=" + formatDate(date: date)
        
        var urlPath = ""
        urlPath = self.stockUrl + identifier + weekAgo + self.apiKey
        
        guard let url = URL(string: urlPath) else { //point 1
            print("Fail at point 1")
            return
        }
        //print(urlPath)
        urlSession.dataTask(with: url) { (data, response, error) in
            guard let data = data else { //point 2
                print("Fail at point 2")
                return
            }
            print("y00")
            do { //point 3
                //print("URL session initialization success")
                let assetData = try JSONDecoder.init().decode(AssetWeekStock.self, from: data)
                print("Is there anybody out there?")
                self.delegate?.stockWeekDataHandler(data: assetData)
                //print(assetData.stockNums[0].open)
            } catch {
                print("Fail at point 3")
            }
            }.resume()
        print("y0")
    }
}
