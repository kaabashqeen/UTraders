//
//  StockTableViewController.swift
//  UTraders
//
//  Created by Possum on 11/8/18.
//  Copyright © 2018 CJ Izzo. All rights reserved.
//

import Foundation
import UIKit

class StockTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssetCell", for: indexPath)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SearchViewController {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
//            vc.current_asset = self.adventurers[indexPath.row]
        }
    }

}
