//
//  UserSearchViewController.swift
//  github_fellows
//
//  Created by nacnud on 1/24/15.
//  Copyright (c) 2015 nanud. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate{

    
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var collectionView: UICollectionView!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.searchBar.delegate = self
        self.navigationController?.delegate = self
        
        self.collectionView.backgroundColor = UIColor.whiteColor()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        NetworkController.sharedNetworkController.fetchUsersForSearchTerm(searchBar.text, callback: { (userArray, errorString) -> (Void) in
            if errorString == nil {
                self.users = userArray!
                self.collectionView.reloadData()
            }
        })
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return text.validateForGitHubUserName()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCollectionViewCell
        cell.backgroundColor = UIColor.redColor()
        cell.userImage.image = nil
        var user = self.users[indexPath.row]
        if user.avatarImage == nil {
            NetworkController.sharedNetworkController.fetchAvatarImageFromURL(user.avatarURL
            , completionHandler: { (image) -> (Void) in
                cell.userImage.image = image
                user.avatarImage = image
                self.users[indexPath.row] = user
            })
        } else {
            cell.userImage.image = user.avatarImage
        }
        return cell
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if toVC is UserDetailViewController {
            return ToUserDetailAnimationController()
        }
        if toVC is HomeTableViewController {
            self.navigationController?.delegate = nil
        }
        return nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_USER_DETAIL" {
            let destinationVC = segue.destinationViewController as UserDetailViewController
            let selectedIndexPath = self.collectionView.indexPathsForSelectedItems().first as NSIndexPath
            destinationVC.presentUser = self.users[selectedIndexPath.row]
        }
    }

}
