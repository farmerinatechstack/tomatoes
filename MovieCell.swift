//
//  MovieCell.swift
//  RottenTomatoes
//
//  Created by Hassan Karaouni on 4/10/15.
//  Copyright (c) 2015 HKII. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var criticLabel: UILabel!
    
    @IBOutlet weak var runtimeLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var viewerPic: UIImageView!
    
    @IBOutlet weak var criticPic: UIImageView!
    
    @IBOutlet weak var viewerLabel: UILabel!

    
    
    override func awakeFromNib() {
                super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
