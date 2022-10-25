//
//  AccountTableViewCell.swift
//  Money Manager
//
//  Created by MAC on 10/25/22.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    static let identifier = "AccountTableViewCell"
    
    
    @IBOutlet weak var settingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
