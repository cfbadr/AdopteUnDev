//
//  Contributor.swift
//  adopteUnDev
//
//  Created by Badr Choukri on 15/08/2018.
//  Copyright © 2018 Badr Choukri. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
class Contributor: Object {
    
    @objc dynamic var id : String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var urlPicture : String = ""
    @objc dynamic var urlProfile : String = ""
    
    
    
    convenience init(contributor: JSON) {
        self.init() // Call self.init(), not super.init()

        id = contributor["id"].stringValue
        username = contributor["login"].stringValue
        urlPicture = contributor["avatar_url"].stringValue
        urlProfile = contributor["html_url"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func printInfo() -> Void {
        debugPrint("** id **")
        debugPrint(id)
        debugPrint("** username **")
        debugPrint(username)
        debugPrint("** urlPicture **")
        debugPrint(urlPicture)
        debugPrint("** urlProfile **")
        debugPrint(urlProfile)
    }
}
