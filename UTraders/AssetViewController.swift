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
    func stockDataHandler(data: NSDictionary) {
        return
    }
    
    func responseErrorHandler(error: String) {
        return
    }

    @IBOutlet weak var assetImage: UIImageView!
    @IBOutlet weak var assetTickerLabel: UILabel!
    @IBOutlet weak var investedValueLabel: UILabel!
    @IBOutlet weak var assetPriceLabel: UILabel!
    
    @IBOutlet weak var assetHighLabel: UILabel!
    @IBOutlet weak var assetLowLabel: UILabel!
    @IBOutlet weak var assetAverageLabel: UILabel!
    @IBOutlet weak var currentAlgorithmInvestedLabel: UILabel!
    
    @IBOutlet weak var algorithm1Label: UIButton!
    @IBOutlet weak var algorithm2Label: UIButton!
    @IBOutlet weak var algorithm3Label: UIButton!
    
    
//    @IBOutlet weak var cityNameText: UITextField!
//    @IBOutlet weak var stateNameText: UITextField!
//    @IBOutlet weak var checkWeatherButton: UIButton!
//    @IBOutlet weak var errorLabel: UILabel!
//    @IBOutlet weak var cloudLabel: UILabel!
//    @IBOutlet weak var humidityLabel: UILabel!
//
//    @IBOutlet weak var pressureLabel: UILabel!
//    @IBOutlet weak var precipitationLabel: UILabel!
//    @IBOutlet weak var windLabel: UILabel!
//    @IBOutlet weak var cloudValLabel: UILabel!
//    @IBOutlet weak var humidityValLabel: UILabel!
//    @IBOutlet weak var pressureValLabel: UILabel!
//    @IBOutlet weak var precipitationValLabel: UILabel!
//    @IBOutlet weak var windValLabel: UILabel!
//    @IBOutlet weak var tempsLabel: UILabel!
//    @IBOutlet weak var weatherImage: UIImageView!
    
    var stockDataSession = StockData()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.weatherDataSession.delegate = self
        self.stockDataSession.delegate = self
        stockDataSession.getAssetData(identifier: "AAPL")
        
    }
    
//    @IBAction func checkConditionButtonClicked(_ sender: Any) {
//        var checkLocation = "&q=" + (self.cityNameText.text!).lowercased() + "," + (self.stateNameText.text!).lowercased()
//        checkLocation = checkLocation.replacingOccurrences(of: " ", with: "+")
//        print(checkLocation)
//        weatherDataSession.getData(location: checkLocation)
//        self.cloudLabel.text = ""
//        self.cloudValLabel.text = ""
//        self.humidityLabel.text = ""
//        self.humidityValLabel.text = ""
//        self.pressureLabel.text = ""
//        self.pressureValLabel.text = ""
//        self.precipitationLabel.text = ""
//        self.precipitationValLabel.text = ""
//        self.windLabel.text = ""
//        self.windValLabel.text = ""
//        self.weatherImage.image = nil
//        self.tempsLabel.text = ""
//    }
    
    func responseStockDataHandler(data:NSDictionary) {
//        let temp_c = data.current.temp_c
//        let temp_f = data.current.temp_f
//        let conditionStringImg = data.current.condition.icon
//        let wind_mph = data.current.wind_mph
//        let wind_kph = data.current.wind_kph
//        let wind_degree = data.current.wind_degree
//        let wind_dir = data.current.wind_dir
//        let pressure_mb = data.current.pressure_mb
//        let precip_mm = data.current.precip_mm
//        let humidity = data.current.humidity
//        let cloud = data.current.cloud
//        let city = data.location.name
//        let state = data.location.region
//
//        //        dispatch_queue_main_t dispatch_get_main_queue(void)
//        //Run this handling on a separate thread
//        dispatch_queue_main_t.main.async() {
//            let checkCity = (self.cityNameText.text!).lowercased() != city.lowercased()
//            print(checkCity)
//            var checkDirectState = true
//            if ((self.stateNameText.text!).length==2){
//                checkDirectState = false
//            } else {
//                checkDirectState = (self.stateNameText.text!).lowercased() != state.lowercased()
//            }
//            print(checkDirectState)
//
//            let checkStateFirst = state.lowercased().range(of:(self.stateNameText.text!).lowercased()[0]) == nil
//            print(checkStateFirst)
//            let checkStateSecond = state.lowercased().range(of:(self.stateNameText.text!).lowercased()[1]) == nil
//            print(checkStateSecond)
//            if (checkCity || ((checkDirectState) || (((checkStateFirst) || (checkStateSecond))))) {
//                self.responseError(message: "Location not found")
//            } else {
//                self.errorLabel.text = ""
//                self.cloudLabel.text = "Cloud Cover: "
//                self.cloudValLabel.text = String(cloud) + "%"
//                self.humidityLabel.text = "Humidity: "
//                self.humidityValLabel.text = String(humidity)+"%"
//                self.pressureLabel.text = "Pressure: "
//                self.pressureValLabel.text = String(pressure_mb)+"mbar"
//                self.precipitationLabel.text = "Precipitation: "
//                self.precipitationValLabel.text = String(precip_mm)+"mm"
//                self.windLabel.text = "Wind: "
//                self.windValLabel.text = String(wind_kph)+"kmph/"+String(wind_mph)+"mph "+String(wind_dir)+" ("+String(wind_degree)+"°)"
//                let imgstringurl2 = "https:" + conditionStringImg
//                self.tempsLabel.text = String(temp_c) + "°C/"+String(temp_f)+"°F"
//                let url = URL(string: imgstringurl2)
//
//                do {
//                    let data = try Data(contentsOf: url!)
//                    self.weatherImage.image = UIImage(data: data)
//                } catch let err {
//                    self.responseError(message: "Image not found")
//                    print("Error")
//                }
//            }
//
//        }
        
    }
    
    func responseErrorMessage(error:String) {
//        self.errorLabel.text = "Current conditions not found" + " (" + error + ")"
        
    }
    
    
    
    
    
}

