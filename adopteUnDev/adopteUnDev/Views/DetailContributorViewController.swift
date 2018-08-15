//
//  DetailContributorViewController.swift
//  adopteUnDev
//
//  Created by Badr Choukri on 15/08/2018.
//  Copyright © 2018 Badr Choukri. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import SwiftMessages

class DetailContributorViewController: UIViewController {
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var login: UILabel!
    @IBOutlet var entreprise: UILabel!//Bientot adopteUn mec j'espere 👌
    @IBOutlet var numberOfFollower: UILabel!
    @IBOutlet var numberOfFollowing: UILabel!
    @IBOutlet var btnMoreInfo: UIButton!
    @IBOutlet var activityIndicatorView: NVActivityIndicatorView!
    
    var contributor : Contributor? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.startAnimating()
        let api = apiGithub()
        api.getDetailContributor(username: contributor!.username)
        fillDetailIAlreadyHave()
        designIt()
        NotificationCenter.default.addObserver(forName:NSNotification.Name("ContributorsLoadedNotification"), object: nil, queue: nil, using: notificationFinish)

        NotificationCenter.default.addObserver(forName:NSNotification.Name("DetailContributorNotification"), object: nil, queue: nil, using: notificationFinish)
    }

    func designIt() -> Void {
        imgUser.layer.cornerRadius = imgUser.frame.height / 2
        imgUser.layer.borderColor = #colorLiteral(red: 0.9866481423, green: 0.2798342109, blue: 0.526060164, alpha: 1)
        imgUser.layer.borderWidth = 1
        imgUser.layer.masksToBounds = true
        btnMoreInfo.layer.cornerRadius = 10
    }
    
    func errorNoInternet() -> Void {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error)
        view.configureDropShadow()
        let iconText = ["😭", "❌", "😿"].sm_random()!
        view.configureContent(title: "Nous avons eu un soucis", body: "Êtes-vous connecté à un internet ?", iconText: iconText)
        SwiftMessages.show(view: view)
    }
    
    func fillDetailIAlreadyHave() -> Void {
        login.text = contributor?.username
        let imageURL = URL(string: (contributor?.urlPicture)!)
        let imageData = NSData(contentsOf: imageURL!)
        if (imageData == nil)
        {
            imgUser.image = #imageLiteral(resourceName: "stack")
        }
        else
        {
            imgUser.image =  UIImage(data: imageData! as Data)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GoToWeb")
        {
            let vc = segue.destination as! WebViewController
            vc.urlGithub = (contributor?.urlProfile)!
        }
    }
    
    func fillDetails(json: JSON) -> Void {
        numberOfFollower.text = json["followers"].stringValue
        entreprise.text = json["company"].stringValue
        numberOfFollowing.text = json["following"].stringValue
        activityIndicatorView.stopAnimating()

    }
    
    func notificationFinish(notification:Notification) -> Void {
        
        if (notification.name.rawValue == "DetailContributorNotification")
        {
            fillDetails(json: notification.object as! JSON)
            activityIndicatorView.stopAnimating()
        }
        if (notification.name.rawValue == "ErrorNotification")
        {
            errorNoInternet()
        }

    }
    
}
