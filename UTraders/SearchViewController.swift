//
//  SearchViewController.swift
//  UTraders
//
//  Created by Kaab Ashqeen on 11/19/18.
//  Copyright © 2018 CJ Izzo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SearchCompanyDataProtocol {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var searchDataSession = SearchData()
    var companySearchResults = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchDataSession.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companySearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = searchTableView.dequeueReusableCell(withIdentifier: "company", for: indexPath) as! companySearchTableViewCell
        let company = companySearchResults[indexPath.row]
        cell.companyNameLabel.text = company.name
        cell.companyTickerLabel.text = company.ticker
        return cell

        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func searchCompanyDataHandler(data: SearchCompanyData) {
        companySearchResults = data.companies
        if companySearchResults.count > 10{
            companySearchResults = Array(companySearchResults[0 ..< 10])
        }
        else {
            companySearchResults = Array(companySearchResults[0 ..< companySearchResults.endIndex])
        }
        DispatchQueue.main.async { 
            self.searchTableView.reloadData()
        }
    }
    
    func searchCompanyDataResponseErrorHandler(error: String) {
        return
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDataSession.getSearchData(identifier: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchTableView.reloadData()
    }

}
