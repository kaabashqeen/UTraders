//
//  SearchViewController.swift
//  UTraders
//
//  Created by Kaab Ashqeen on 11/19/18.
//  Copyright © 2018 CJ Izzo. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SearchCompanyDataProtocol {

//    var investments: Investments = Investments()
    var initialState: [Company] = []
    var searching = false
    var company_clicked = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var searchDataSession = SearchData()
    var companySearchResults = [Company]()
    

    override func viewWillAppear(_ animated: Bool) {
//        self.searctableView!.beginUpdates()
//        self.tableView!.deleteRowsAtIndexPaths(removedPaths, withRowAnimation:UITableViewRowAnimation.Bottom)
//        self.tableView!.insertRowsAtIndexPaths(addedPaths, withRowAnimation:UITableViewRowAnimation.Bottom)
//        self.tableView!.endUpdates()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        DispatchQueue.main.async {
            self.searchBar.becomeFirstResponder()
        }
    }
    
    
    override func viewDidLoad() {
        //self.searchBar.setImage(UIImage(named: "search"), for: .clear, state: UIControl.State.normal)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        super.viewDidLoad()
//        print(investments)
        self.searchDataSession.delegate = self
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchBar.delegate = self
//        DispatchQueue.main.async {
//            self.searchBar.becomeFirstResponder()
//        }

        
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return companySearchResults.count
        } else {
            return initialState.count
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchTableView.dequeueReusableCell(withIdentifier: "company", for: indexPath) as! companySearchTableViewCell
        cell.layer.borderColor = UIColor(red: 255, green: 218, blue: 169, alpha: 1).cgColor
        DispatchQueue.main.async {
            if self.searching {
                let company = self.companySearchResults[indexPath.row]
                //print("check",company)
                cell.companyNameLabel.text = company.name
                cell.companyTickerLabel.text = company.ticker
            } else {
                cell.companyNameLabel.text = ""
                cell.companyTickerLabel.text = ""
            }
        }
        return cell

    }
    
    @IBAction func unwindToSearchViewController(segue: UIStoryboardSegue) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        DispatchQueue.main.async() {
            print()
            print("START SEGUE")
            if let vc = segue.destination as? PortfolioTableViewController {
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                
            }
            if let vc = segue.destination as? AssetViewController {
//                guard let indexPath = self.searchTableView.indexPathForSelectedRow else { return }
//                print("3")
//                print(self.companySearchResults[indexPath.row].ticker)
//                print(indexPath.row)
//                print(self.companySearchResults)
//                vc.current_company = self.companySearchResults[indexPath.row].ticker
//                vc.investments = self.investments
                vc.current_company = self.company_clicked
                print(vc.current_company)
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                vc.viewDidLoad()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?{
        print(indexPath.row)
        //print(companySearchResults)
        self.company_clicked = self.companySearchResults[indexPath.row].ticker
        print(self.company_clicked)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.company_clicked = self.companySearchResults[indexPath.row].ticker
        
        
    }
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        self.searchBar.becomeFirstResponder()
        return true
    }
    
    func searchCompanyDataHandler(data: SearchCompanyData) {
        self.companySearchResults = data.companies
        //print(self.companySearchResults)
        DispatchQueue.main.async{
            self.searchTableView.reloadData()
        }
        
    }
    
    func searchCompanyDataResponseErrorHandler(error: String) {
        return
    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        print("1", searchBar.text!)
//        searchDataSession.getSearchData(identifier: searchBar.text!)
//    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
//        searchBar.
//        let totalRows = self.searchTableView.numberOfRows(inSection: 0)
//        for row in (0..<totalRows).reversed() {
//            searchTableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .fade)
//        }
        let searchTextQuery = searchText.replacingOccurrences(of: " ", with: "_")
        print(searchTextQuery)
        searchDataSession.getSearchData(identifier: searchTextQuery)
        DispatchQueue.main.async{
            self.searchTableView.reloadData()
        }

//        DispatchQueue.main.async() {
//            self.searchTableView.reloadData()
////            let totalRows = self.searchTableView.numberOfRows(inSection: 0)
////            for row in 0..<totalRows {
////                self.searchTableView.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)
////            }
////            self.searchTableView.reloadRows(at: self.searchTableView.indexPathsForSelectedRows!, with: UITableView.RowAnimation.automatic)
//            //print(self.companySearchResults)
//        }


    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchDataSession.getSearchData(identifier: searchBar.text!)
//        self.searchTableView.reloadData()
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchDataSession.getSearchData(identifier: searchBar.text!)
//        self.searchTableView.reloadData()
//    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.searchBar.resignFirstResponder()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searching = true
        let searchTextQuery = searchBar.text!.replacingOccurrences(of: " ", with: "_")
        print(searchTextQuery)
        print("YO")
        searchDataSession.getSearchData(identifier: searchTextQuery)
        DispatchQueue.main.async {
            self.searchBar.resignFirstResponder()
        }

    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("3", searchBar.text!)
        searchBar.text = ""
        performSegue(withIdentifier: "unwindtoPTVCfromSVC", sender: self)
        DispatchQueue.main.async {
            print("check")
            self.searchTableView.reloadData()
        }
    }

}
