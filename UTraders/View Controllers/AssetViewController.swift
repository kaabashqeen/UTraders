//
//  AssetViewController.swift
//  UTraders
//
//  Created by Kaab Ashqeen on 11/28/18.
//  Copyright © 2018 CJ Izzo. All rights reserved.
//
import UIKit
import Foundation

//extension UIImage {
//    convenience init?(url: URL?) {
//        guard let url = url else { return nil }
//
//        do {
//            let data = try Data(contentsOf: url)
//            self.init(data: data)
//        } catch {
//            print("Cannot load image from url: \(url) with error: \(error)")
//            return nil
//        }
//    }
//}
//extension String {
//
//    var length: Int {
//        return count
//    }
//
//    subscript (i: Int) -> String {
//        return self[i ..< i + 1]
//    }
//
//    func substring(fromIndex: Int) -> String {
//        return self[min(fromIndex, length) ..< length]
//    }
//
//    func substring(toIndex: Int) -> String {
//        return self[0 ..< max(0, toIndex)]
//    }
//
//    subscript (r: Range<Int>) -> String {
//        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
//                                            upper: min(length, max(0, r.upperBound))))
//        let start = index(startIndex, offsetBy: range.lowerBound)
//        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
//        return String(self[start ..< end])
//    }
//
//}
class AssetViewController: UIViewController, StockDataProtocol, UIPickerViewDelegate, UIPickerViewDataSource {

    var choices = [1,2,3,4,5,6,7,8,9,10]
    var pickerView = UIPickerView()
    var typeValue = Int()
    
    var stocks: [Asset] = []

    
    
    var current_company: String = ""
    var current_price: Float = 0.0
    var current_ticker: String = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(choices[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            typeValue = 1
        } else if row == 1 {
            typeValue = 2
        } else if row == 2 {
            typeValue = 3
        } else if row == 3 {
            typeValue = 4
        } else if row == 4 {
            typeValue = 5
        } else if row == 5 {
            typeValue = 6
        } else if row == 6 {
            typeValue = 7
        } else if row == 7 {
            typeValue = 8
        } else if row == 8 {
            typeValue = 9
        } else if row == 9 {
            typeValue = 10
        } else if row == 10 {
            typeValue = 11
        }
        
        
    }
    
    
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
    
    
    @IBOutlet weak var numberOfSharesLabel: UILabel!
    @IBOutlet weak var numberOfSharesToInvestLabel: UILabel!
    @IBOutlet weak var tradeButton: UIButton!
    
    var stockDataSession = StockData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.weatherDataSession.delegate = self
        self.stockDataSession.delegate = self
        print(current_company)
        current_company = "AAPL"
        current_ticker = "AAPL"
        stockDataSession.getAssetData(identifier: "AAPL")
        
    }

//    @IBAction func showChoices(_ sender: Any) {
//        let alert = UIAlertController(title: "Car Choices", message: "\n\n\n\n\n\n", preferredStyle: .alert)
//        alert.isModalInPopover = true
//
//        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
//        
//        alert.view.addSubview(pickerFrame)
//        pickerFrame.dataSource = self
//        pickerFrame.delegate = self
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
//
//            print("You selected " + self.typeValue )
//
//        }))
//        self.present(alert,animated: true, completion: nil )
//    }
//    
    @IBAction func tradeButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Trade",
                                      message: "\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        alert.isModalInPopover = true
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))

        
//        let tradeAction = UIAlertAction(title: "Trade",
//                                       style: .default) {
//                                        [unowned self] action in
//
//                                        guard let textField = alert.textFields?.first,
//                                            let stockToTrade = textField.text else {
//                                                return
//                                        }
//                                        let vc = PortfolioTableViewController()
//                                        var stocks = vc.stocks
//                                        stocks.append(stockToTrade)
//        }

        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Trade", style: .default, handler: { (UIAlertAction) in
            
            print("You selected ", self.typeValue, self.current_company)
            var assetToTrade = Asset()
            assetToTrade.numberOfShares = self.typeValue
            assetToTrade.ticker = self.current_company
            assetToTrade.valueInvested = Float(assetToTrade.numberOfShares!) * self.current_price
            assetToTrade.company = self.current_company
            self.stocks.append(assetToTrade)
            self.performSegue(withIdentifier: "unwindToPTVC", sender: self)
            
        }))
        present(alert, animated: true)
        
    }
    
    
    func stockDataHandler(data: AssetData) {
        print("hello \(data.high)")
        let open = data.open
        let high = data.high
        let low = data.low
        let close = data.close
        let volume = data.volume
        let adjClose = data.adjClose
        self.current_price = close
        
        DispatchQueue.main.async {
            self.assetPriceLabel.text = "Close: \(Double(String(format: "%.2f", close)))"
            self.assetHighLabel.text = "High: \(high)"
            self.assetLowLabel.text = "Low: \(low)"
            var myDouble = (open + high)/2
            var avg = Double(String(format: "%.2f", myDouble))
            self.assetAverageLabel.text = "Average: \(avg!)"
            self.assetOpenLabel.text = "Open: \(open)"
            
            
        }
    }
    
    func responseErrorHandler(error: String) {
        return
    }
    

}
