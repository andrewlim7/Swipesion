//
//  SavedNewsCell.swift
//  Swipesion
//
//  Created by Andrew Lim on 13/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit

class SavedNewsCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
