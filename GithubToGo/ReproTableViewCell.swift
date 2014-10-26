//
//  ReproTableViewCell.swift
//  GithubToGo
//
//  Created by Joshua M. Sacks on 10/21/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class ReproTableViewCell: UITableViewCell {
    @IBOutlet weak var descripition: UILabel!

    @IBOutlet weak var updateDate: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
