//
//  UserCollectionViewCell.swift
//  adopteUnDev
//
//  Created by Badr Choukri on 15/08/2018.
//  Copyright © 2018 Badr Choukri. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var loginUser: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func fillCell(contributor: Contributor) -> Void {
        loginUser.text = contributor.username
        let imageURL = URL(string: contributor.urlPicture)
        let imageData = NSData(contentsOf: imageURL!)
        if (imageData == nil)
        {
            imgUser.image = #imageLiteral(resourceName: "stack")
        }
        else{
            imgUser.image =  UIImage(data: imageData! as Data)
        }
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
}
