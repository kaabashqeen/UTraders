
//  StockTableViewController.swift
//  UTraders
//
//  Created by Possum on 11/8/18.
//  Copyright © 2018 CJ Izzo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PortfolioTableViewController: UITableViewController, StockDataProtocol, StockWeekDataProtocol {
    
    var investedvalueupdate: Float = 0.0
    var portfolio: Portfolio? = nil
    var currStock: String = ""
    var currIdx: Int = 0
    //    var investments = Investments()
    var stocksToUpdate: [String : Stock] = [:]
    var updatedStocks: [String : Float] = [:]
    var timer: Timer? = nil
    var timerIsRunning = false
    var stockDataSession = StockData()
    var stockWeekDataSession = StockWeekData()
    var doUpdates = false
    var portSums:[[Float]] = [[0.0]]
    
    @IBOutlet weak var valueGraphLabel: UILabel!
    
    let group = DispatchGroup()
    
    override func viewWillDisappear(_ animated: Bool) {
        //        group.wait()
        self.doUpdates = false
        self.currStock = ""
        self.currIdx = Int()
        self.timer?.invalidate()
        self.doUpdates = false
    }
    
    // called whenever view will appear from any view
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.currStock = ""
        self.currIdx = Int()
        stopTimer()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Portfolio>(entityName: "Portfolio")
        
        do {
            self.portfolio = try managedContext.fetch(fetchRequest)[0]
            if self.portfolio == nil {
                createPortfolio()
            } else {
                var stockArray = Array((portfolio?.investedStocks!)!) as! [Stock]
                for stock in stockArray {
                    print(stock.ticker!)
                    self.stocksToUpdate[stock.ticker!] = stock
                    self.updatedStocks[stock.ticker!] = stock.valueInvested
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            createPortfolio()
        }
        if portfolio!.investedStocks!.count == 0 {
            self.doUpdates = false
            stopTimer()
        } else {
            self.doUpdates = true
            runTimer()
        }
        if portfolio!.investedStocks!.count != 0 {
            print("pls")
            
            var stockArray = Array((portfolio?.investedStocks!)!) as! [Stock]
            var tickerArray:[String] = []
            for stock in stockArray {
                tickerArray.append(stock.ticker!)
            }
            if portSums.count == 1 {
                if portSums[0] == [0.0] {
                    portSums.remove(at: 0)
                }
            }

            for i in tickerArray {
                
                self.stockWeekDataSession.getAssetWeekData(identifier: i)
            }
//            for i in tickerArray {
//                self.stockWeekDataSession.getAssetWeekData(identifier: i)
//            }
            //self.setupGraphDisplay()
            self.doUpdates = true
            runTimer()

        }
        
        
    }
    
    
    // called when view has to be loaded into memory
    
    override func viewDidLoad() {
        print("\n\n\n\n\n\n\n\n yes")
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
            var port = try managedContext.fetch(fetchRequest)
            if port.count == 0 {
                createPortfolio()
            } else {
                self.portfolio = port[0]
                var stockArray = Array((portfolio?.investedStocks!)!) as! [Stock]
                for stock in stockArray {
                    print(stock.ticker!)
                    self.stocksToUpdate[stock.ticker!] = stock
                    self.updatedStocks[stock.ticker!] = stock.valueInvested
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "D-DIN", size: 20)!]
        
        self.stockDataSession.delegate = self
        self.stockWeekDataSession.delegate = self
        
        self.PortfolioValueLabel.text = "$\(String(format: "%.2f", self.portfolio!.portfolioValue))"
        self.navigationController?.navigationBar.shadowImage = UIImage()
        print(portfolio!.investedStocks?.count)
        
        
        if portfolio!.investedStocks!.count != 0 {
            print("pls")
            
            var stockArray = Array((portfolio?.investedStocks!)!) as! [Stock]
            var tickerArray:[String] = []
            for stock in stockArray {
                tickerArray.append(stock.ticker!)
            }
////////////////////////////////////////////////////////////////////////////
//            if portSums[0] == [0.0] {
//                portSums.remove(at: 0)
//            }
//            for i in tickerArray {
//
//                self.stockWeekDataSession.getAssetWeekData(identifier: i)
//            }
/////////////////////////////////////////////////////////////////////////
            self.doUpdates = true
            runTimer()
            
            
            
        } else {
            self.doUpdates = false
            stopTimer()
        }
        valueGraphLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
    }
    
    func createPortfolio() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entityPortfolio = NSEntityDescription.entity(forEntityName: "Portfolio", in: managedContext)!
        
        self.portfolio = NSManagedObject(entity: entityPortfolio, insertInto: managedContext) as! Portfolio
        self.portfolio?.investedValue = 0
        self.portfolio?.portfolioValue = 10000
        do {
            try managedContext.save()
            print("added!")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        print("created")
    }
    
    func runTimer() {
        if self.timerIsRunning == false {
            self.timer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            self.timerIsRunning = true
        }
        
    }
    
    func stopTimer() {
        if self.timerIsRunning {
            self.timerIsRunning = false
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        if ((portfolio) != nil) {
            return portfolio!.investedStocks!.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "AssetCell",
                                              for: indexPath) as! PortfolioAssetTableViewCell
            
            let stockArray = Array(portfolio!.investedStocks!)
            //let stocks = portfolio?.value(forKey: "investedStocks") as! NSSet
            let stock = stockArray[indexPath.row] as! Stock
            //            cell.portfolioView.layer.cornerRadius = 8
            //            cell.portfolioView.layer.shadowOffset = CGSize(width: 0, height: 0)
            //            cell.portfolioView.layer.shadowRadius = 3
            //            cell.portfolioView.layer.shadowOpacity = 0.05
            //            cell.portfolioView.layer.shadowPath = UIBezierPath(roundedRect: cell.portfolioView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
            //            cell.portfolioView.layer.shouldRasterize = true
            //            cell.portfolioView.layer.rasterizationScale = UIScreen.main.scale
            
            cell.portfolioAssetName?.text = "\(stock.ticker!)"
            cell.portfolioAssetShares?.text = "\(stock.numberOfShares) Shares"
            //print(stock.ticker!)
            //print(stocksToUpdate[indexPath.row].valueInvested, stock.valueInvested)
            var currValue = updatedStocks[stock.ticker!]!
            var changeValue = updatedStocks[stock.ticker!]! - stock.valueInvested
            cell.portfolioAssetValue.text = "$\(String(format: "%.2f", currValue)) (\(String(format: "%.2f", changeValue)))"
            return cell
    }
    
    
    @objc func update(){
        return
        if self.doUpdates == false {
            print("STOP")
            return
        }
        //        self.group.enter()
        
        print()
        print()
        print()
        print ("START ITERATION")
        print()
        print("invested",self.portfolio!.investedValue, self.portfolio!.portfolioValue)
        
        var count = 0
        let stockArray = Array(self.portfolio!.investedStocks!) as! [Stock]
        self.investedvalueupdate = 0
        var check = (self.portfolio?.portfolioValue)! - (self.portfolio?.investedValue)!
        //print(stockArray)
        for (ticker, stock) in self.updatedStocks{
            
            self.currStock = ticker
            self.currIdx = count
            print(ticker, self.currStock)
            //            DispatchQueue.global(qos: .userInitiated).async {
            // Download file or perform expensive task
            self.stockDataSession.getAssetData(identifier: self.currStock)
            //                DispatchQueue.main.async {
            //                    // Update the UI
            //                }
            //            }
            
            count+=1
            
        }
        
        //        self.group.leave()
        
        
        //        self.group.notify(queue: .main) {
        //            print("Finished all requests.")
        //
        //        }
        print()
        print()
        print("STOP ITERATION")
    }
    
    func save() {
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
        
    }
    
    func stockDataHandler(data: AssetData, stock: String) {
        //        DispatchQueue.main.async {
        //        DispatchQueue.global(qos: .userInitiated).async {
        if self.portfolio!.investedStocks!.count != 0{
            if self.currStock != ""{
                //                    print(self.currStock)
                print(stock)
                let close = data.close
                
                self.updatedStocks[stock]! = close
                
                
                let stockArray = Array(self.portfolio!.investedStocks!) as! [Stock]
                
                var numShares = 0
                self.investedvalueupdate = 0
                for asset in stockArray {
                    self.investedvalueupdate = self.investedvalueupdate + self.updatedStocks[asset.ticker!]! * Float(asset.numberOfShares)
                }
                
                self.portfolio?.setValue((self.portfolio?.portfolioValue)! - (self.portfolio?.investedValue)! + self.investedvalueupdate, forKey: "portfolioValue")
                
                print("check", self.portfolio?.portfolioValue, self.portfolio?.investedValue, self.investedvalueupdate)
                DispatchQueue.main.async {
                    self.PortfolioValueLabel.text = "$\(String(format: "%.2f", self.portfolio!.portfolioValue))"
                    var skew = self.investedvalueupdate - self.portfolio!.investedValue
                    self.PortfolioSkewLabel.text = " (\(String(format: "%.2f", skew)))"
                    self.save()
                    self.tableView.reloadData()
                }
                
                
            }
        }
        //        }
        
        
        
    }
    
    func responseErrorHandler(error: String) {
        return
    }
    
    ////////////////////////////////////////////
    /////////////////GRAPH VIEW/////////////////
    ////////////////////////////////////////////
    
    @IBOutlet weak var PortfolioView: UIView!
    @IBOutlet weak var ValueView: UIView!
    @IBOutlet weak var PortfolioGraphView: PortfolioDisplayView!
    @IBOutlet weak var PortfolioValueLabel: UILabel!
    @IBOutlet weak var PortfolioSkewLabel: UILabel!
    
    var isGraphViewShowing = true
    @IBAction func portfolioViewSwipeRight(_ gesture: UISwipeGestureRecognizer?){
        if isGraphViewShowing {
            //hide graph
            UIView.transition(from: PortfolioGraphView, to: ValueView, duration: 1.0, options:[.transitionFlipFromLeft, .showHideTransitionViews], completion:nil)
        } else {
            //show graph
            UIView.transition(from: ValueView, to: PortfolioGraphView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion:nil)
        }
        isGraphViewShowing = !isGraphViewShowing
    }
    
    @IBAction func portfolioViewSwipeLeft(_ gesture: UISwipeGestureRecognizer?){
        if isGraphViewShowing {
            //hide graph
            UIView.transition(from: PortfolioGraphView, to: ValueView, duration: 1.0, options:[.transitionFlipFromRight, .showHideTransitionViews], completion:nil)
        } else {
            //show graph
            UIView.transition(from: ValueView, to: PortfolioGraphView, duration: 1.0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion:nil)
        }
        isGraphViewShowing = !isGraphViewShowing
    }
    
    
    @IBOutlet weak var newTrade: UIBarButtonItem!
    @IBOutlet weak var settings: UIBarButtonItem!
    
    ////////////////////////////////////////////
    /////////////////SEGUES/////////////////////
    ////////////////////////////////////////////
    @IBAction func search(_ sender: Any) {
        performSegue(withIdentifier: "searchsegue", sender: nil)
    }
    
    @IBAction func unwindtoPortfolioTableViewController(segue: UIStoryboardSegue) {
        if let vc = segue.source as? AssetViewController {
            navigationController?.setNavigationBarHidden(false, animated: false)
            self.currStock = ""
            self.currIdx = Int()
            stopTimer()
            
            print(self.portfolio?.investedStocks?.count)
            tableView.reloadData()
            if self.portfolio!.investedStocks!.count != 0 {
                print("not 0")
                let stockArray = Array(portfolio!.investedStocks!) as! [Stock]
                for stock in stockArray{
                    self.stocksToUpdate[stock.ticker!] = stock
                    self.updatedStocks[stock.ticker!] = stock.valueInvested
                }
                self.doUpdates = true
                runTimer()
                
            }
            print("ITS 0")
            self.PortfolioSkewLabel.text = " (0)"
            
        }
    }
    
    @IBAction func unwindtoPortfolioTableViewControllerfromSVC(segue: UIStoryboardSegue) {
        
        if let vc = segue.source as? SearchViewController {
            //            self.investments = vc.investments
            
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print()
        print("START SEGUE")
        print("1")
        
        stopTimer()
        if let vc = segue.destination as? SearchViewController {
            print("2")
            //            guard let indexPath = searchTableView.indexPathForSelectedRow else { return }
            print("3")
            //            print(self.companySearchResults[indexPath.row].ticker)
            //            vc.investments = investments
            print("4")
            
        }
        if let vc = segue.destination as? AssetViewController {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let stockArray = Array(portfolio!.investedStocks!)
            //let stocks = portfolio?.value(forKey: "investedStocks") as! NSSet
            let stock = stockArray[indexPath.row] as! Stock
            vc.current_company = stock.ticker!
            vc.current_ticker = stock.ticker!
            
        }
        if let vc = segue.destination as? SettingsViewController {
            //            vc.investments = self.investments
        }
    }
    
    @IBAction func unwindtoPTVCfromSettings(segue:UIStoryboardSegue) {
        if let vc = segue.source as? SettingsViewController {
            //            self.investments = vc.investments
            self.PortfolioValueLabel.text = "$\(self.portfolio!.portfolioValue)"
        }
    }


    func responseErrorHandler2(error: String) {
        return
    }
    func stockWeekDataHandler(data: AssetWeekStock) {
        print()
        print()
        print("DOING STUFF")
        var partialPoints:[Float] = []
        var datum:[String] = []
        for i in 0..<data.stockNums.count {
            partialPoints += [data.stockNums[i].close]
            print(data.stockNums[i].close)
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
        print(partialPoints)
        partialPoints.reverse()
        datum.reverse()
        self.portSums += [partialPoints]
        self.PortfolioGraphView.dates = datum
        DispatchQueue.main.async {
            self.setupGraphDisplay()
        }
    }
    
    @IBOutlet weak var portfolioGraphHighLabel: UILabel!
    @IBOutlet weak var portfolioGraphLowLabel: UILabel!
    @IBOutlet weak var portfolioStartDateLabel: UILabel!
    @IBOutlet weak var portfolioEndDateLabel: UILabel!
    func setupGraphDisplay() {
        var portfolioPoints:[Float] = []
        print("Portsums here! \(portSums)")
        for i in 0..<portSums[0].count {
            var temp:[Float] = []
            for j in 0..<portSums.count {
                temp += [portSums[j][i]]
            }
            var tempSum:Float = 0.0
            for k in 0..<temp.count {
                tempSum += temp[k]
            }
            portfolioPoints += [tempSum + (self.portfolio?.portfolioValue)! - (self.portfolio?.investedValue)!]
        }
        self.PortfolioGraphView.graphPoints = portfolioPoints
        self.portfolioGraphHighLabel.text = "\(self.PortfolioGraphView.graphPoints.max()!)"
        self.portfolioGraphLowLabel.text = "\(self.PortfolioGraphView.graphPoints.min()!)"
        self.portfolioStartDateLabel.text = self.PortfolioGraphView.dates[0]
        self.portfolioEndDateLabel.text = self.PortfolioGraphView.dates[self.PortfolioGraphView.dates.count - 1]
        self.PortfolioGraphView.setNeedsDisplay()
        print(self.PortfolioGraphView.graphPoints)
    }

}
