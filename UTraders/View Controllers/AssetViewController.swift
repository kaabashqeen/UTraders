//
//  AssetViewController.swift
//  UTraders
//
//  Created by Kaab Ashqeen on 11/28/18.
//  Copyright © 2018 CJ Izzo. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class AssetViewController: UIViewController, StockDataProtocol, UIPickerViewDelegate, UIPickerViewDataSource, StockWeekDataProtocol{
    
    
    @IBOutlet weak var assetGraphView: AssetGraphView!
    var choices = Array(1...100)
    var pickerViewBuy = UIPickerView()
    var pickerViewSell = UIPickerView()
    var typeValue = Int()
    var portfolio: Portfolio? = nil
    //    var investments: Investments = Investments()
    
    @IBOutlet weak var valueGraphLabel: UILabel!
    
    
    var current_company: String = ""
    var current_price: Float = 0.0
    var current_ticker: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.assetTickerLabel.text = ""
        self.assetPriceLabel.text = ""
        self.assetHighLabel.text = ""
        self.assetLowLabel.text = ""
        
        self.assetAverageLabel.text = ""
        self.assetOpenLabel.text = ""
        self.currentAlgorithmInvestedLabel.text = ""
        
        self.investedValueLabel.text = ""
        self.buyButton.isHidden = true
        self.sellButton.isHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewBuy {
            return choices.count + 1
        } else {
            return investedAmount + 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 0 ? "" : String(choices[row - 1])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeValue = row
        
    }
    
    
    @IBOutlet weak var assetTickerLabel: UILabel!
    @IBOutlet weak var investedValueLabel: UILabel!
    @IBOutlet weak var assetPriceLabel: UILabel!
    
    @IBOutlet weak var assetOpenLabel: UILabel!
    @IBOutlet weak var assetHighLabel: UILabel!
    @IBOutlet weak var assetLowLabel: UILabel!
    @IBOutlet weak var assetAverageLabel: UILabel!
    @IBOutlet weak var currentAlgorithmInvestedLabel: UILabel!
    
    //    @IBOutlet weak var algorithm1Label: UIButton!
    //    @IBOutlet weak var algorithm2Label: UIButton!
    //    @IBOutlet weak var algorithm3Label: UIButton!
    
    
    //    @IBOutlet weak var numberOfSharesLabel: UILabel!
    //    @IBOutlet weak var numberOfSharesToInvestLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    
    
    var stockDataSession = StockData()
    var investedAmount = 0
    var stockWeekSession = StockWeekData()
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Portfolio>(entityName: "Portfolio")
        
        do {
            portfolio = try managedContext.fetch(fetchRequest)[0]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        var checkCurrentAssets = Array((portfolio?.investedStocks)!) as! [Stock]
        for stock in checkCurrentAssets {
            print(stock.ticker, current_ticker)
            if stock.ticker! == current_ticker {
                investedAmount = Int(stock.numberOfShares)
                self.investedValueLabel.text = "\(investedAmount) Shares"
                print("I have", investedAmount)
            }
            
            
        }
        
        valueGraphLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view, typically from a nib.
        //self.weatherDataSession.delegate = self
        self.stockDataSession.delegate = self
        //print("HEY", current_company)
        stockDataSession.getAssetData(identifier: current_company)
        
        
        self.stockWeekSession.delegate = self
        if self.current_company == "" {
            stockWeekSession.getAssetWeekData(identifier: "AAPL")
        } else {
            stockWeekSession.getAssetWeekData(identifier: current_company)
        }
        
        //        self.loadView()
        
        
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
    @IBAction func sellButtonClicked(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Portfolio>(entityName: "Portfolio")
        
        do {
            portfolio = try managedContext.fetch(fetchRequest)[0]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        let alert = UIAlertController(title: "Trade",
                                      message: "\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        alert.isModalInPopover = true
        
        pickerViewSell.frame = CGRect(x: 5, y: 20, width: 250, height: 140)
        
        alert.view.addSubview(pickerViewSell)
        pickerViewSell.dataSource = self
        pickerViewSell.delegate = self
        let addFunds = UIAlertAction(title: "Add Funds", style: .default) {
            [unowned self] action in
            
            self.performSegue(withIdentifier: "unwindToPTVC", sender: self)
        }
        
        let alertNoStocks = UIAlertController(title: "No Sufficient Investment in Stock", message: "The requested investment cannot be fulfilled.", preferredStyle:.alert)
        let alertNoAmount = UIAlertController(title: "No Amount Selected", message: "The requested investment cannot be fulfilled with zero shares.", preferredStyle:.alert)
        alertNoAmount.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Trade", style: .default, handler: { (UIAlertAction) in
            
            print("You selected ", self.typeValue, self.current_company)
            if self.typeValue == 0 {
                self.present(alertNoAmount, animated: true)
            } else if self.investedAmount != 0 && self.typeValue > self.investedAmount {
                self.present(alertNoStocks, animated: true)
            } else {
                self.deleteStock(ticker: self.current_company, amount: self.typeValue)
                self.performSegue(withIdentifier: "unwindToPTVC", sender: self)
            }
            
        }))
        present(alert, animated: true)
        
    }
    @IBAction func buyButtonClicked(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Portfolio>(entityName: "Portfolio")
        
        do {
            portfolio = try managedContext.fetch(fetchRequest)[0]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        let alert = UIAlertController(title: "Trade",
                                      message: "\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        alert.isModalInPopover = true
        pickerViewBuy.frame = CGRect(x: 5, y: 20, width: 250, height: 140)
        
        
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
        
        alert.view.addSubview(pickerViewBuy)
        pickerViewBuy.dataSource = self
        pickerViewBuy.delegate = self
        let alertNoFunds = UIAlertController(title: "Not Enough Sufficient Funds", message: "The requested investment cannot be fulfilled.", preferredStyle:.alert)
        let addFunds = UIAlertAction(title: "Add Funds", style: .default) {
            [unowned self] action in
            
            self.performSegue(withIdentifier: "unwindToPTVC", sender: self)
        }
        let alertNoAmount = UIAlertController(title: "No Amount Selected", message: "The requested investment cannot be fulfilled with zero shares.", preferredStyle:.alert)
        alertNoAmount.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertNoFunds.addAction(addFunds)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Trade", style: .default, handler: { (UIAlertAction) in
            
            print("You selected ", self.typeValue, self.current_company)
            if self.typeValue == 0 {
                self.present(alertNoAmount, animated: true)
            } else if (Float(self.typeValue) * self.current_price + self.portfolio!.investedValue > (self.portfolio?.portfolioValue)!) {
                self.present(alertNoFunds, animated: true)
                
            } else {
                self.save(ticker: self.current_company, amount: self.typeValue)
                //            let assetToTrade = Asset()
                //            assetToTrade.numberOfShares = self.typeValue
                //            assetToTrade.ticker = self.current_company
                //            assetToTrade.valueInvested = self.current_price
                self.performSegue(withIdentifier: "unwindToPTVC", sender: self)
            }
            
            //            if (Float(assetToTrade.numberOfShares!) * assetToTrade.valueInvested! + self.investments.investedValue > self.investments.portfolioValue) {
            //                self.present(alertNoFunds, animated: true)
            //            } else {
            //                assetToTrade.company = self.current_company
            //                self.investments.investedValue = Float(assetToTrade.numberOfShares!) * assetToTrade.valueInvested! + self.investments.investedValue
            //
            //                self.investments.assets.append(assetToTrade)
            //                print(self.investments.assets)
            //                self.performSegue(withIdentifier: "unwindToPTVC", sender: self)
            //            }
            
        }))
        present(alert, animated: true)
        
    }
    
    func deleteStock(ticker: String, amount: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Portfolio>(entityName: "Portfolio")
        
        do {
            portfolio = try managedContext.fetch(fetchRequest)[0]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let stocks = Array((portfolio!.investedStocks?.allObjects)!) as! [Stock]
        var stockToRemove = Stock()
        for stock in stocks {
            if stock.ticker == ticker {
                stockToRemove = stock
            }
        }
        portfolio?.investedValue = (portfolio!.investedValue) - stockToRemove.valueInvested * Float(amount)
        portfolio?.portfolioValue = (portfolio!.portfolioValue) + self.current_price * Float(amount) - stockToRemove.valueInvested * Float(amount)
        
        if amount == stockToRemove.numberOfShares {
            print("pls delete")
            portfolio?.removeFromInvestedStocks(stockToRemove)
            managedContext.delete(stockToRemove)
        } else {
            stockToRemove.numberOfShares = stockToRemove.numberOfShares.advanced(by: -amount)
        }
        
        do {
            try managedContext.save()
            print("added!")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func save(ticker: String, amount: Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Portfolio>(entityName: "Portfolio")
        do {
            portfolio = try managedContext.fetch(fetchRequest)[0]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let stocks = Array((portfolio!.investedStocks?.allObjects)!) as! [Stock]
        var found = false
        var stockToAdd = Stock()
        for stock in stocks {
            if stock.ticker == ticker {
                stockToAdd = stock
                found = true
                stockToAdd.numberOfShares = stockToAdd.numberOfShares.advanced(by: amount)
                portfolio!.investedValue = portfolio!.investedValue + Float(amount) * stock.valueInvested
            }
        }
        
        if found == false {
            let entityStock = NSEntityDescription.entity(forEntityName: "Stock", in: managedContext)!
            let stock = NSManagedObject(entity: entityStock, insertInto: managedContext) as! Stock
            
            stock.setValue(amount, forKey: "numberOfShares")
            stock.setValue(ticker, forKey: "ticker")
            stock.setValue(current_price, forKey: "valueInvested")
            stock.setValue("", forKey: "company")
            portfolio!.addToInvestedStocks(stock)
            portfolio!.investedValue = portfolio!.investedValue + Float(stock.numberOfShares) * stock.valueInvested
            
        }
        do {
            try managedContext.save()
            print("added!")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SearchViewController {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        self.navigationController?.setNavigationBarHidden(true, animated: false)
    //    }
    
    func stockDataHandler(data: AssetData, stock: String) {
        
        //print("hello \(data.high)")
        let open = data.open
        let high = data.high
        let low = data.low
        let close = data.close
        //        let volume = data.volume
        //        let adjClose = data.adjClose
        self.current_price = close
        
        DispatchQueue.main.async {
            self.investedValueLabel.text = "Invested: \(self.investedAmount) Shares"
            self.buyButton.isHidden = false
            self.sellButton.isHidden = false
            self.assetTickerLabel.text = self.current_company
            self.assetPriceLabel.text = "Current: \(Double(String(format: "%.2f", close))!)"
            self.assetHighLabel.text = "High: \(high)"
            self.assetLowLabel.text = "Low: \(low)"
            let myDouble = (open + high)/2
            let avg = Double(String(format: "%.2f", myDouble))
            self.assetAverageLabel.text = "Average: \(avg!)"
            self.assetOpenLabel.text = "Open: \(open)"
            
            
        }
    }
    
    @IBOutlet weak var assetGraph: AssetGraphView!
    func responseErrorHandler(error: String) {
        return
    }
    
    func stockWeekDataHandler(data: AssetWeekStock) {
        var points:[Float] = []
        var datum:[String] = []
        print(data.stockNums.count)
        for i in 0..<data.stockNums.count {
            points += [data.stockNums[i].close]
            var formDate = ""
            var count = 0
            for ch in data.stockNums[i].date {
                if count < 5 {
                    count += 1
                } else {
                    formDate += "\(ch)"
                }
            }
            datum += [formDate]
        }
        print("point")
        points.reverse()
        datum.reverse()
        print(datum)
        self.assetGraph.graphPoints = points
        self.assetGraph.dates = datum
        DispatchQueue.main.async {
            self.setupGraphDisplay()
        }
    }
    
    func responseErrorHandler2(error: String) {
        return
    }
    
    
    @IBOutlet weak var companyGraphLabel: UILabel!
    @IBOutlet weak var lowGraphLabel: UILabel!
    @IBOutlet weak var highGraphLabel: UILabel!
    @IBOutlet weak var endDateGraphLabel: UILabel!
    @IBOutlet weak var startDateGraphLabel: UILabel!
    func setupGraphDisplay() {
        endDateGraphLabel.text = assetGraph.dates[assetGraph.dates.count - 1]
        startDateGraphLabel.text = assetGraph.dates[0]
        highGraphLabel.text = "\(assetGraph.graphPoints.max()!)"
        lowGraphLabel.text = "\(assetGraph.graphPoints.min()!)"
        companyGraphLabel.text = self.current_company
        assetGraph.setNeedsDisplay()
        
    }
    
}

