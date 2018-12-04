//
//  AssetViewController.swift
//  UTraders
//
//  Created by Kaab Ashqeen on 11/28/18.
//  Copyright © 2018 CJ Izzo. All rights reserved.
//
import UIKit
import Foundation

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}
extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
class AssetViewController: UIViewController, StockDataProtocol {

    
    
    
    var current_company: String = ""

    @IBOutlet weak var assetTickerLabel: UILabel!
    @IBOutlet weak var investedValueLabel: UILabel!
    @IBOutlet weak var assetPriceLabel: UILabel!
    
    @IBOutlet weak var assetOpenLabel: UILabel!
    @IBOutlet weak var assetHighLabel: UILabel!
    @IBOutlet weak var assetLowLabel: UILabel!
    @IBOutlet weak var assetAverageLabel: UILabel!
    @IBOutlet weak var currentAlgorithmInvestedLabel: UILabel!
    
    @IBOutlet weak var algorithm1Label: UIButton!
    @IBOutlet weak var algorithm2Label: UIButton!
    @IBOutlet weak var algorithm3Label: UIButton!
    
    
    var stockDataSession = StockData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.weatherDataSession.delegate = self
        self.stockDataSession.delegate = self
        print(current_company)
        stockDataSession.getAssetData(identifier: "AAPL")
        
    }

    
    func stockDataHandler(data: AssetData) {
        print("hello \(data.high)")
        let open = data.open
        let high = data.high
        let low = data.low
        let close = data.close
        let volume = data.volume
        let adjClose = data.adjClose
        
        DispatchQueue.main.async {
            self.assetPriceLabel.text = "Close: \(close)"
            self.assetHighLabel.text = "High: \(high)"
            self.assetLowLabel.text = "Low: \(low)"
            self.assetAverageLabel.text = "Average: \((open + high)/2)"
            self.assetOpenLabel.text = "Open: \(open)"
            
            
        }
    }
    
    func responseErrorHandler(error: String) {
        return
    }
    

}

