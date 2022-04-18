//
//  HomeTableViewCell.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/02/11.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
//    let identifier = "HomeTableViewCell"
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
