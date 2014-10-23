//
//  UserCollectionViewCell.swift
//  GithubToGo
//
//  Created by Joshua M. Sacks on 10/22/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = UIImage (named: "questionMark.png")
    }
}
