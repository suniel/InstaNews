//
//  ArticleViewCell.swift
//  InstaNews
//
//  Created by Suniel on 10/10/17.
//  Copyright © 2017 Suniel. All rights reserved.
//

import UIKit

class ArticleViewCell: UITableViewCell {

    
    @IBOutlet weak var articleImage: UIImageView!
    
    @IBOutlet weak var articleTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
