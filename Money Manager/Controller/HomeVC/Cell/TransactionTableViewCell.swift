//
//  TransactionTableViewCell.swift
//  Money Manager
//
//  Created by MAC on 10/26/22.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    static let identifier = "TransactionTableViewCell"

    @IBOutlet weak var vIcon: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        vIcon.layer.cornerRadius = 20
        vIcon.backgroundColor = .iconColor()
        imgIcon.tintColor = .white
        lblName.font = .medium(ofSize: 14)
        lblName.textColor = .black
        lblDate.font = .regular(ofSize: 12)
        lblDate.textColor = .borderColor()
        lblAmount.font = .regular(ofSize: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
