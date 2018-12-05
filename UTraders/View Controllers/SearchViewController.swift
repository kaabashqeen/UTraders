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
    var initialState: [Company] = []
    var searching = false
    var company_clicked = ""
    
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
        if searching {
            return companySearchResults.count
        } else {
            return initialState.count
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "company", for: indexPath) as! companySearchTableViewCell
        if searching {
            if indexPath.count <= companySearchResults.count {
                if companySearchResults.count == 0{
                    return cell
                } else {
                    let company = companySearchResults[indexPath.row]
                    //print("check",company)
                    cell.companyNameLabel.text = company.name
                    cell.companyTickerLabel.text = company.ticker
                    return cell
                    
                }
            } else {
                return cell
            }
        } else {
            cell.companyNameLabel.text = ""
            cell.companyTickerLabel.text = ""
        }
        return cell

    }
    
    @IBAction func unwindToSearchViewController(segue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        DispatchQueue.main.async() {
            print()
            print("START SEGUE")
            if let vc = segue.destination as? AssetViewController {
//                guard let indexPath = self.searchTableView.indexPathForSelectedRow else { return }
//                print("3")
//                print(self.companySearchResults[indexPath.row].ticker)
//                print(indexPath.row)
//                print(self.companySearchResults)
//                vc.current_company = self.companySearchResults[indexPath.row].ticker
                vc.current_company = self.company_clicked
                print(vc.current_company)
                print("...")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?{
        print(indexPath.row)
        print(companySearchResults)
        self.company_clicked = self.companySearchResults[indexPath.row].ticker
        performSegue(withIdentifier: "showAVCSegue", sender: self)
        print(self.company_clicked)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.company_clicked = self.companySearchResults[indexPath.row].ticker
        //print(self.company_clicked)
        
    }

    func searchCompanyDataHandler(data: SearchCompanyData) {
        DispatchQueue.main.async() {
            self.companySearchResults = data.companies
            if self.companySearchResults.count > 15{
                self.companySearchResults = Array(self.companySearchResults[0 ..< 14])
            }
            else {
                self.companySearchResults = Array(self.companySearchResults[0 ..< self.companySearchResults.endIndex])
            }
            
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
        searching = true
//        let totalRows = self.searchTableView.numberOfRows(inSection: 0)
//        for row in (0..<totalRows).reversed() {
//            searchTableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .fade)
//        }
        let searchTextQuery = searchText.replacingOccurrences(of: " ", with: "_")
        print(searchTextQuery)
        searchDataSession.getSearchData(identifier: searchTextQuery)
        DispatchQueue.main.async() {
            self.searchTableView.reloadData()
//            let totalRows = self.searchTableView.numberOfRows(inSection: 0)
//            for row in 0..<totalRows {
//                self.searchTableView.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)
//            }
//            self.searchTableView.reloadRows(at: self.searchTableView.indexPathsForSelectedRows!, with: UITableView.RowAnimation.automatic)
            //print(self.companySearchResults)
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
