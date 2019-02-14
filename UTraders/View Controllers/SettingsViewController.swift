//
//  SettingsViewController.swift
//  UTraders
//
//  Created by Kaab Ashqeen on 12/4/18.
//  Copyright © 2018 CJ Izzo. All rights reserved.
//

import UIKit
import CoreData
class SettingsViewController: UIViewController {

    
    var investments = Investments()
    
    @IBOutlet weak var portfolioValueLabel: UILabel!
    @IBOutlet weak var investedLabel: UILabel!
    
    @IBOutlet weak var portfolioValueValueLabel: UILabel!
    @IBOutlet weak var investedValueLabel: UILabel!
    
    @IBOutlet weak var portfolioText: UILabel!
    @IBOutlet weak var portfolioValue: UILabel!
    @IBOutlet weak var addFundsButton: UIButton!
//    @IBOutlet weak var moneyAnimationView: UIImageView!
    
    var portfolio: Portfolio? = nil
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<Portfolio>(entityName: "Portfolio")
        
        //3
        do {
            self.portfolio = try managedContext.fetch(fetchRequest)[0] as Portfolio
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<Portfolio>(entityName: "Portfolio")
        
        //3
        do {
            self.portfolio = try managedContext.fetch(fetchRequest)[0] as! Portfolio
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        self.portfolioValue.text = "$\(String(format: "%.2f", (self.portfolio!.portfolioValue)))"
        self.portfolioText.text = "Portfolio Value"
        self.portfolioValueLabel.text = "Portfolio"
        self.portfolioValueValueLabel.text = "$\(String(format: "%.2f", (self.portfolio!.portfolioValue)))"
        
        self.investedLabel.text = "Invested"
        self.investedValueLabel.text = "$\(String(format: "%.2f", (self.portfolio!.investedValue)))"
        
    }
    
    
    @IBAction func addFunds(_ sender: Any) {
        let alert = UIAlertController(title: "Add Funds",
                                      message: "Enter Amount to Add",
                                      preferredStyle: .alert)
        alert.isModalInPopover = true
        let alertIncorrect = UIAlertController(title: "Error Adding Funds",
                                      message: "Make sure amount to add is a float!",
                                      preferredStyle: .alert)
        
        let tradeAction = UIAlertAction(title: "Add Funds",
                                       style: .default) {
                                        [unowned self] action in

                                        guard let textField = alert.textFields?.first,
                                            let fundsToAdd = Float(textField.text!) else {
                                                self.present(alertIncorrect, animated: true)
                                                return
                                        }
                                        
                                        self.portfolio?.portfolioValue = (self.portfolio!.portfolioValue) + Float(fundsToAdd)
                                        
                                        guard let appDelegate =
                                            UIApplication.shared.delegate as? AppDelegate else {
                                                return
                                        }
                                        
                                        let managedContext = appDelegate.persistentContainer.viewContext
                                        
                                        do {
                                            try managedContext.save()
                                            print("added!")
                                        } catch let error as NSError {
                                            print("Could not save. \(error), \(error.userInfo)")
                                        }
                                        
                                        self.performSegue(withIdentifier: "unwindtoPTVCfromS", sender: self)
        }
        alert.addTextField()
        alertIncorrect.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(tradeAction)
        present(alert, animated: true)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PortfolioTableViewController {
//            vc.investments = self.investments
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension UIImage {
//    public class func gif(asset: String) -> UIImage? {
//        if let asset = NSDataAsset(name: asset) {
//            return UIImage.gif(asset.data)
//        }
//        return nil
//    }
//}

import UIKit
import ImageIO
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}



extension UIImage {

    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }

        return UIImage.animatedImageWithSource(source)
    }

    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL? = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL!) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }

        return gifImageWithData(imageData)
    }

    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gifImageWithData(imageData)
    }

    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1

        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)

        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        delay = delayObject as! Double

        if delay < 0.1 {
            delay = 0.1
        }

        return delay
    }

    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }

        if a < b {
            let c = a
            a = b
            b = c
        }

        var rest: Int
        while true {
            rest = a! % b!

            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }

    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }

        return gcd
    }

    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }

            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
        }()

        let gcd = gcdForArray(delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)

        return animation
    }
}
