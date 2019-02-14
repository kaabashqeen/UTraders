//
//  SearchData.swift
//  UTraders
//
//  Created by Kaab Ashqeen on 12/3/18.
//  Copyright © 2018 CJ Izzo. All rights reserved.
//

import Foundation

struct Company: Decodable {
    let name: String
    let ticker: String
}

struct SearchCompanyData: Decodable {
    let companies: [Company]
    
    private enum CodingKeys: String, CodingKey {
        case companies = "data"
    }
    
}
protocol SearchCompanyDataProtocol {
    func searchCompanyDataHandler(data:SearchCompanyData)
    func searchCompanyDataResponseErrorHandler(error:String)
}

class SearchData {
    private let urlSession = URLSession.shared
    private let apiKey = "&api_key=OjA5MGVkNzRkMzZhMzU0Y2VmZmY4YjNhNmJlYmVmODM4"
    private let companyURL = "https://api.intrinio.com/securities/search?conditions=name~contains~"
    
    var delegate:SearchCompanyDataProtocol? = nil
    
    func getSearchData(identifier: String) {
        let urlPath = self.companyURL + identifier + self.apiKey
        
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
                let searchData = try JSONDecoder.init().decode(SearchCompanyData.self, from: data)
                self.delegate?.searchCompanyDataHandler(data: searchData)

                //print(searchData.companies)
            } catch {
                print("Fail at point 3")
            }
            }.resume()
    }
    
}

