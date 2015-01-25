//
//  SearchRepoViewController.swift
//  github_fellows
//
//  Created by nacnud on 1/24/15.
//  Copyright (c) 2015 nanud. All rights reserved.
//

import UIKit

class SearchRepoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var repos: [Repository] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        
        self.searchBar.becomeFirstResponder()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.orangeColor()
        cell.textLabel?.text = repos[indexPath.row].name
        return cell
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println(self.searchBar.text)
        self.searchBar.resignFirstResponder()
        NetworkController.sharedNetworkController.fetchRepositoriesForSearchTerm(searchBar.text, callback: { (repoArray, errorString) -> (Void) in
            if errorString == nil {
                self.repos = repoArray!
                self.tableView.reloadData()
            }
        })
//        searchBar.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(self.repos[indexPath.row].url)
        let webVC = WebViewController()
        webVC.urlString = self.repos[indexPath.row].url
        
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "SHOW_WEB_VC" {
//            println("hey")
//            let destinationVC = segue.destinationViewController as WebViewController
//            let selectedIndexPath = self.tableView.indexPathForSelectedRow()
//            let repo = self.repos[selectedIndexPath!.row]
//            destinationVC.urlString = repo.url
//            navigationController?.pushViewController(destinationVC, animated: true)
//            
//        }
//    }
}
