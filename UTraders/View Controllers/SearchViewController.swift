//
//  SearchViewController.swift
//  UTraders
//
//  Created by Kaab Ashqeen on 11/19/18.
//  Copyright © 2018 CJ Izzo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SearchCompanyDataProtocol {

    
    var stocks: [Asset] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var searchDataSession = SearchData()
    var companySearchResults = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(stocks)
        self.searchDataSession.delegate = self
        
        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companySearchResults.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "company", for: indexPath) as! companySearchTableViewCell
        if indexPath.count <= companySearchResults.count {
            if companySearchResults.count == 0{
                return cell
            } else {
                let company = companySearchResults[indexPath.row]
                cell.companyNameLabel.text = company.name
                cell.companyTickerLabel.text = company.ticker
                return cell
                
            }
        } else {
            return cell
        }

    }
    
    @IBAction func unwindToSearchViewController(segue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print()
        print("START SEGUE")
        print("1")
        if let vc = segue.destination as? AssetViewController {
            print("2")
            guard let indexPath = searchTableView.indexPathForSelectedRow else { return }
            print("3")
            print(self.companySearchResults[indexPath.row].ticker)
            vc.current_company = self.companySearchResults[indexPath.row].ticker
            vc.stocks = stocks
            print("4")
        }
    }

    func searchCompanyDataHandler(data: SearchCompanyData) {
        companySearchResults = data.companies
        if companySearchResults.count > 15{
            companySearchResults = Array(companySearchResults[0 ..< 14])
        }
        else {
            companySearchResults = Array(companySearchResults[0 ..< companySearchResults.endIndex])
        }
    }
    
    func searchCompanyDataResponseErrorHandler(error: String) {
        return
    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        print("1", searchBar.text!)
//        searchDataSession.getSearchData(identifier: searchBar.text!)
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("2", searchText)
        let searchTextQuery = searchText.replacingOccurrences(of: " ", with: "_")
        searchDataSession.getSearchData(identifier: searchTextQuery)
        dispatch_queue_main_t.main.async() {
            self.searchTableView.reloadData()
        }
        

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
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("3", searchBar.text!)
        searchBar.text = ""
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
            self.searchTableView.beginUpdates()
            self.searchTableView.endUpdates()
        }
    }

}
