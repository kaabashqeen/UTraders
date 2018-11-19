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
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath)
        return cell
    }
    
}
