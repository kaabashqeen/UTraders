//
//  StockData.swift
//  UTraders
//
//  Created by Possum on 11/25/18.
//  Copyright © 2018 CJ Izzo. All rights reserved.

import Foundation

struct MarketCap: Decodable {
    let identifier: String
    let item: String
    let value: Float
}

struct AssetData: Decodable {
    let open: Float
    let high: Float
    let low: Float
    let close: Float
    let volume: Float
    let adjClose: Float
    
    private enum CodingKeys: String, CodingKey {
        case open = "open"
        case high = "high"
        case low = "low"
        case close = "close"
        case volume = "volume"
        case adjClose = "adj_close"
    }
}

struct AssetStock: Decodable {
    let stockNums: [AssetData]
    
    private enum CodingKeys: String, CodingKey {
        case stockNums = "data"
    }
    
}
protocol StockDataProtocol {
    func stockDataHandler(data:AssetData)
    //func marketCapHandler(data:)
    func responseErrorHandler(error:String)
}

class StockData {
    private let urlSession = URLSession.shared
    private let apiKey = "&api_key=OjM5OTI4ZDkyZGY3MWFkNjczODk1NzYzYjU2MTA2NThm"
    private let stockUrl = "https://api.intrinio.com/prices?identifier="
    private let marketCapUrl = "https://api.intrinio.com/data_point?identifier="
    
    var delegate:StockDataProtocol? = nil
    
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
    
    func getAssetData(identifier: String) {
        var dateToParse = Date()
        let calendar = Calendar.current
        
        let dayOfWeek = calendar.component(.weekday, from: dateToParse)
        if (dayOfWeek == 1) || (dayOfWeek == 7) {
            if dayOfWeek == 1{
                dateToParse = dateToParse - 2
            }
            if dayOfWeek == 7{
                dateToParse = dateToParse - 1
            }
        }
        
        let number = Int.random(in: 3 ... 4)

        let day = calendar.component(.day, from: dateToParse)
        let month = calendar.component(.month, from: dateToParse)
        let year = calendar.component(.year, from: dateToParse)
        
        let yearString = String(year)
        var monthString = String(month)
        if monthString.count == 1 {
            monthString = "0" + monthString
        }
//        let number = Int.random(in: 6 ... 9)
//        var daychange = day-number
        var days = number
        var dayString = String(days)
        if dayString.count == 1 {
            dayString = "0" + dayString
        }
        var endString = ""
        if days == 3{
            endString = "&end_date="+yearString+monthString+dayString
        }
        let date = "&start_date=" + yearString + monthString + dayString + endString
        let urlPath = self.stockUrl + identifier + date + self.apiKey
        //print(urlPath)
        
        guard let url = URL(string: urlPath) else { //point 1
            print("Fail at point 1")
            return
        }
        
        urlSession.dataTask(with: url) { (data, response, error) in
            guard let data = data else { //point 2
                print("Fail at point 2")
                return
            }
            do { //point 3
                //print("URL session initialization success")
                let assetData = try JSONDecoder.init().decode(AssetStock.self, from: data)
                self.delegate?.stockDataHandler(data: assetData.stockNums[0])
                print(assetData.stockNums[0].open)
            } catch {
                print("Fail at point 3")
            }
            }.resume()
    }
    /*
    func getMarketCap(identifier: String){
        let urlPath = self.marketCapUrl + identifier + "item=marketcap" + self.apiKey
        
        guard let url = URL(string: urlPath) else { //point 1
            print("Fail at point 1")
            return
        }
        
        urlSession.dataTask(with: url) { (data, response, error) in
            guard let data = data else { //point 2
                print("Fail at point 2")
                return
            }
            do {
                let marketCapData = try JSONDecoder.init().decode(AssetStock.self, from data)
                self.delegate
            } catch {
                
            }
    }
    */
}
