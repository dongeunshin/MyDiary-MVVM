//
//  FavTableViewCell.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/04/18.
//

import UIKit

class FavTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
