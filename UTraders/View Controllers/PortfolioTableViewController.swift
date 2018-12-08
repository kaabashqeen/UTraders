//
//  StockTableViewController.swift
//  UTraders
//
//  Created by Possum on 11/8/18.
//  Copyright © 2018 CJ Izzo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PortfolioTableViewController: UITableViewController, StockDataProtocol {
    
    var investedvalueupdate: Float = 0.0
    func stockDataHandler(data: AssetData) {
        DispatchQueue.main.async() {
            let open = data.open
            let high = data.high
            let low = data.low
            let close = data.close
            let volume = data.volume
            let adjClose = data.adjClose
            self.stocksToUpdate[self.currIdx].numberOfShares = 1
            self.stocksToUpdate[self.currIdx].valueInvested = close
            self.investedvalueupdate = self.stocksToUpdate[self.currIdx].valueInvested! * Float(self.investments.assets[self.currIdx].numberOfShares!)
        }
        
        DispatchQueue.main.async {
            
//            self.investedValueLabel.text = "Invested: 0.00"
//            self.tradeButton.isHidden = false
//
//            self.assetTickerLabel.text = self.current_company
//            self.assetPriceLabel.text = "Close: \(Double(String(format: "%.2f", close))!)"
//            self.assetHighLabel.text = "High: \(high)"
//            self.assetLowLabel.text = "Low: \(low)"
//            let myDouble = (open + high)/2
//            let avg = Double(String(format: "%.2f", myDouble))
//            self.assetAverageLabel.text = "Average: \(avg!)"
//            self.assetOpenLabel.text = "Open: \(open)"
            
            
        }
    }
    
    func responseErrorHandler(error: String) {
        return
    }
    
    
    var currStock: String = ""
    var currIdx: Int = 0
    var investments = Investments()
    
    var stocksToUpdate: [Asset] = []

    var stockDataSession = StockData()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "D-DIN", size: 20)!]
        self.stockDataSession.delegate = self
        
        self.PortfolioValueLabel.text = String(self.investments.portfolioValue)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //loadPortfolio
//        let apple = Asset()
//        apple.ticker = "AAPL"
//        apple.numberOfShares = 3
//        apple.valueInvested = 300.2
//        apple.company = "AAPL"
//        investments.assets.append(apple)
        self.stocksToUpdate = investments.assets
    }
    

    @objc func update(){
        var count = 0
        //print("1",self.investments.investedValue)
        investedvalueupdate = 0
        var check = self.investments.portfolioValue - self.investments.investedValue
        for asset in investments.assets {
            self.currStock = asset.ticker!
            
            self.currIdx = count
            
            print("looping", self.currStock, self.currIdx)
            DispatchQueue.main.async() {
                self.stockDataSession.getAssetData(identifier: self.currStock)
            }
            count = count+1
        }
        //print("2",self.investments.investedValue)
        self.investments.portfolioValue = (investedvalueupdate - self.investments.investedValue) + self.investments.portfolioValue
        self.PortfolioValueLabel.text = "\(self.investments.portfolioValue)"
        self.investments.investedValue =  investedvalueupdate
        
        //print(check)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return investments.assets.count
    }
    
    override func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "AssetCell",
                                              for: indexPath) as! PortfolioAssetTableViewCell
            cell.portfolioAssetName?.text = "\(investments.assets[indexPath.row].ticker!)"
            cell.portfolioAssetShares?.text = "\(investments.assets[indexPath.row].numberOfShares!) Shares"
            print(investments.assets[indexPath.row].ticker!)
            print(stocksToUpdate[indexPath.row].valueInvested!, investments.assets[indexPath.row].valueInvested!)
            cell.portfolioAssetValue?.text = "$\(stocksToUpdate[indexPath.row].valueInvested!) (\(stocksToUpdate[indexPath.row].valueInvested! - investments.assets[indexPath.row].valueInvested!))"
            return cell
    }
    
//    func loadAdventurers() {
//        guard let app_delegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let managed_context = app_delegate.persistentContainer.viewContext
//        let fetch_request = Portfolio.fetchRequest()
//
//        do {
//            adventurers = try managed_context.fetch(fetch_request)
//        } catch let error as NSError {
//            print("Could not load adventurers: \(error)")
//        }
//
//        for adventurer in adventurers as! [Adventurer]  {
//            let total_hp = adventurer.value(forKeyPath: "total_hp") as? Int32
//            adventurer.setValue(total_hp, forKeyPath: "current_hp")
//        }
//
//        self.tableView.reloadData()
//    }
//    
//    var portfolio: NSManagedObject = nil
//    var assets: NSManagedObject = nil
    
    
    @IBOutlet weak var PortfolioView: UIView!
    @IBOutlet weak var ValueView: UIView!
    @IBOutlet weak var PortfolioGraphView: PortfolioDisplayView!
    @IBOutlet weak var PortfolioValueLabel: UILabel!
    @IBOutlet weak var PortfolioSkewLabel: UILabel!
    
    var isGraphViewShowing = false
    @IBAction func portfolioViewSwipe(_ gesture: UISwipeGestureRecognizer?){
        if isGraphViewShowing {
            //hide graph
            UIView.transition(from: PortfolioGraphView, to: ValueView, duration: 1.0, options:[.transitionFlipFromLeft, .showHideTransitionViews], completion:nil)
        } else {
            //show graph
        UIView.transition(from: ValueView, to: PortfolioGraphView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion:nil)
        }
        isGraphViewShowing = !isGraphViewShowing
    }
    
    @IBOutlet weak var newTrade: UIBarButtonItem!
    @IBOutlet weak var settings: UIBarButtonItem!
    
    @IBAction func search(_ sender: Any) {
        performSegue(withIdentifier: "searchsegue", sender: nil)
    }
    
    @IBAction func unwindtoPortfolioTableViewController(segue: UIStoryboardSegue) {
        
        if let vc = segue.source as? AssetViewController {
            navigationController?.setNavigationBarHidden(false, animated: false)
            self.investments = vc.investments
            self.stocksToUpdate = vc.investments.assets
            tableView.reloadData()
            let timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func unwindtoPortfolioTableViewControllerfromSVC(segue: UIStoryboardSegue) {
        
        if let vc = segue.source as? SearchViewController {
            self.investments = vc.investments
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print()
        print("START SEGUE")
        print("1")
        if let vc = segue.destination as? SearchViewController {
            print("2")
//            guard let indexPath = searchTableView.indexPathForSelectedRow else { return }
            print("3")
//            print(self.companySearchResults[indexPath.row].ticker)
            vc.investments = investments
            print("4")
        }
        if let vc = segue.destination as? AssetViewController {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            vc.current_company = investments.assets[indexPath.row].ticker!
            print(investments.assets[indexPath.row])
        }
        if let vc = segue.destination as? SettingsViewController {
            vc.investments = self.investments
        }
    }
    
    @IBAction func unwindtoPTVCfromSettings(segue:UIStoryboardSegue) {
        if let vc = segue.source as? SettingsViewController {
            self.investments = vc.investments
            self.PortfolioValueLabel.text = "\(self.investments.portfolioValue)"
        }
    }
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? SearchViewController {
//            guard let indexPath = tableView.indexPathForSelectedRow else { return }
////            vc.current_asset = self.adventurers[indexPath.row]
//        }
//    }

}
//
//extension Portfol: UITableViewDataSource {
//    func tableView(_ tableView: UITableView,
//                   numberOfRowsInSection section: Int) -> Int {
//        return people.count
//    }
//
//    func tableView(_ tableView: UITableView,
//                   cellForRowAt indexPath: IndexPath)
//        -> UITableViewCell {
//
//            let person = people[indexPath.row]
//            let cell =
//                tableView.dequeueReusableCell(withIdentifier: "Cell",
//                                              for: indexPath)
//            cell.textLabel?.text =
//                person.value(forKeyPath: "name") as? String
//            return cell
//    }
//}
