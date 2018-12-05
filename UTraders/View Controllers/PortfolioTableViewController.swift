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

class PortfolioTableViewController: UITableViewController {
    

    var investments = Investments()
    
    var stocks: [Asset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.PortfolioValueLabel.text = String(self.investments.portfolioValue)
        
        //loadPortfolio
        let apple = Asset()
        apple.ticker = "AAPL"
        apple.numberOfShares = 3
        apple.valueInvested = 300.2
        apple.company = "AAPL"
        stocks.append(apple)
    }

    
    override func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    override func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "AssetCell",
                                              for: indexPath) as! PortfolioAssetTableViewCell
            cell.portfolioAssetName?.text = "\(stocks[indexPath.row].ticker!) (\(stocks[indexPath.row].numberOfShares!))"
            cell.portfolioAssetValue?.text = "\(stocks[indexPath.row].valueInvested!)"
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
    
    
    @IBOutlet weak var PotfolioView: UIView!
    @IBOutlet weak var PortfolioValueLabel: UILabel!
    
    
    @IBOutlet weak var newTrade: UIBarButtonItem!
    @IBOutlet weak var settings: UIBarButtonItem!
    
    @IBAction func search(_ sender: Any) {
        performSegue(withIdentifier: "searchsegue", sender: nil)
    }
    
    @IBAction func unwindtoPortfolioTableViewController(segue: UIStoryboardSegue) {
        
        if let vc = segue.source as? AssetViewController {
            self.stocks = vc.stocks
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
            vc.stocks = stocks
            print("4")
        }
        if let vc = segue.destination as? AssetViewController {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            vc.current_company = stocks[indexPath.row].ticker!
            print(stocks[indexPath.row])
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
