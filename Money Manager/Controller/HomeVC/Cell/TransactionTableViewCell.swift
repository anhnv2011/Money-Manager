//
//  TransactionTableViewCell.swift
//  Money Manager
//
//  Created by MAC on 10/26/22.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    static let identifier = "TransactionTableViewCell"

    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func setupUI(){
        self.selectionStyle = .none
        iconView.layer.cornerRadius = 20
        iconView.backgroundColor = .iconColor()
        imageIcon.tintColor = .white
        nameLabel.font = .medium(ofSize: 14)
        nameLabel.textColor = .black
        dateLabel.font = .regular(ofSize: 12)
        dateLabel.textColor = .borderColor()
        amountLabel.font = .regular(ofSize: 16)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
