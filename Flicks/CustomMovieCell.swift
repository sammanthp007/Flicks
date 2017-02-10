//
//  CustomMovieCell.swift
//  Flicks
//
//  Created by samman on 2/5/17.
//  Copyright © 2017 samman. All rights reserved.
//

import UIKit

class CustomMovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

    }

}
