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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadPortfolio()
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssetCell", for: indexPath)
        return cell
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
