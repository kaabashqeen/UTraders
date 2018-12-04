//
//  SettingsViewController.swift
//  UTraders
//
//  Created by Kaab Ashqeen on 12/4/18.
//  Copyright © 2018 CJ Izzo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    var investments = Investments()
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var lastLoginLabel: UILabel!
    
    @IBOutlet weak var firstNameValueLabel: UILabel!
    @IBOutlet weak var lastNameValueLabel: UILabel!
    @IBOutlet weak var usernameValueLabel: UILabel!
    @IBOutlet weak var lastLoginValueLabel: UILabel!
    
    @IBOutlet weak var portfolioLabel: UILabel!
    @IBOutlet weak var portfolioValueLabel: UILabel!
    @IBOutlet weak var addFundsButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.portfolioValueLabel.text = String(self.investments.portfolioValue)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addFunds(_ sender: Any) {
        let alert = UIAlertController(title: "Add Funds",
                                      message: "Enter Amount to Add",
                                      preferredStyle: .alert)
        alert.isModalInPopover = true
  
        let tradeAction = UIAlertAction(title: "Add Funds",
                                       style: .default) {
                                        [unowned self] action in

                                        guard let textField = alert.textFields?.first,
                                            let fundsToAdd = textField.text else {
                                                return
                                        }
                                        
                                        self.investments.portfolioValue = self.investments.portfolioValue + Float(fundsToAdd)!
                                        
                                        self.performSegue(withIdentifier: "unwindtoPTVCfromS", sender: self)
        }
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(tradeAction)
        present(alert, animated: true)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PortfolioTableViewController {
            vc.investments = self.investments
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
