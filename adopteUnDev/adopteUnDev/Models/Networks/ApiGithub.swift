//
//  ApiGithub.swift
//  adopteUnDev
//
//  Created by Badr Choukri on 15/08/2018.
//  Copyright © 2018 Badr Choukri. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
class apiGithub {
    
 
    
    
    func getContributor(info: Bool) -> Void {
        
        let url = "https://api.github.com/repos/apple/swift/contributors"
       var shouldSendNotification = false
        Alamofire.request(url, method: .get).responseJSON
            { response in
                if (response.error == nil)
                {
                    let json = JSON(response.result.value!)
                    if (json != nil)
                    {
                        for elem in json.array!
                        {

                            let contributor = Contributor(contributor: elem)
                            let realm = try! Realm()
                            let newContributor =
                                realm.object(ofType: Contributor.self, forPrimaryKey: contributor.id)
                            if (newContributor == nil)
                            {
                                shouldSendNotification = true
                                try! realm.write {
                                    realm.add(contributor)
                                }
                            }
                            else{
                                try! realm.write {
                                    newContributor?.urlPicture = contributor.urlPicture
                                    newContributor?.username = contributor.username
                                    newContributor?.urlProfile = contributor.urlProfile
                                }
                            }
                        }
                    }
                    else{
                        //Error
                    }
                    if (shouldSendNotification)
                    {
                        NotificationCenter.default.post(name:NSNotification.Name("ContributorsLoadedNotification"), object: nil, userInfo: nil)

                    }
                }
                else
                {
                    debugPrint(response.error!)
                NotificationCenter.default.post(name:NSNotification.Name("ErrorNotification"), object: nil, userInfo: nil)

                }
        }
    }
    
    func getDetailContributor(username: String) -> Void {
        
        let url = "https://api.github.com/users/\(username)"
        Alamofire.request(url, method: .get).responseJSON
            { response in
                if (response.error == nil)
                {
                    let json = JSON(response.result.value!)
                    if (json != nil)
                    {
                        NotificationCenter.default.post(name:NSNotification.Name("DetailContributorNotification"), object: json, userInfo: nil)
                    }
                    else{
                        //Error
                    }
                }
                else
                {
                    debugPrint(response.error!)
                    NotificationCenter.default.post(name:NSNotification.Name("ErrorNotification"), object: nil, userInfo: nil)
                }
        }
    }
    
    
}
