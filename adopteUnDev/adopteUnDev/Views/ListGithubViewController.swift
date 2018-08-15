//
//  ListGithubViewController.swift
//  adopteUnDev
//
//  Created by Badr Choukri on 15/08/2018.
//  Copyright © 2018 Badr Choukri. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RealmSwift
import SwiftMessages

class ListGithubViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet var collectionView: UICollectionView!
    let searchBar = UISearchBar()
    var refreshControl: UIRefreshControl!
    let api = apiGithub()
    var contributorArray : Results<Contributor>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api.getContributor(info: false)
        let realm = try! Realm()
        contributorArray = realm.objects(Contributor.self)
        if (contributorArray.count == 0)
        {
            activityIndicatorView.startAnimating()

        }
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("pullToRefresh", comment: "pull to refresh"))
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        //createSearchBar()
        NotificationCenter.default.addObserver(forName:NSNotification.Name("ErrorNotification"), object: nil, queue: nil, using: notificationFinish)
        NotificationCenter.default.addObserver(forName:NSNotification.Name("ContributorsLoadedNotification"), object: nil, queue: nil, using: notificationFinish)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        api.getContributor(info: false)
        collectionView.reloadData()
    }

    func createSearchBar() -> Void {
        searchBar.showsCancelButton = false
        searchBar.placeholder = NSLocalizedString("placeHolderSearch", comment: "searchBar")
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        searchBar.returnKeyType = .default
    }
    
    @objc func refresh(_ sender: Any) {
        api.getContributor(info: false)
        self.refreshControl.endRefreshing()
        collectionView.reloadData()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contributorArray.count
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserCollectionViewCell
        cell.fillCell(contributor: contributorArray[indexPath.row])
        return cell
    }

    func errorNoInternet() -> Void {
        let view = MessageView.viewFromNib(layout: .messageViewIOS8)
        view.configureTheme(.error)
        view.configureDropShadow()
        let iconText = ["😭", "❌", "😿"].sm_random()!
        view.configureContent(title: NSLocalizedString("noInternetTitle", comment: "Don't have connection"), body: NSLocalizedString("noInternetDetails", comment: "Don't have connection"), iconText: iconText)
        SwiftMessages.show(view: view)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.searchBar.endEditing(true)

        performSegue(withIdentifier: "goToDetail", sender: indexPath.row)
    }
    
    func notificationFinish(notification:Notification) -> Void {
        if (notification.name.rawValue == "ContributorsLoadedNotification")
        {
            activityIndicatorView.stopAnimating()
            collectionView.reloadData()
            let realm = try! Realm()
            let test = realm.objects(Contributor.self)
        }
        if (notification.name.rawValue == "ErrorNotification")
        {
            errorNoInternet()
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToDetail")
        {
            let vc = segue.destination as! DetailContributorViewController
            let pos = sender as! Int
            vc.contributor = contributorArray[pos]
        }
    }
    
}
