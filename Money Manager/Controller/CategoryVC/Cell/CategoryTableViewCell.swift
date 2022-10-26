//
//  CategoryTableViewCell.swift
//  Money Manager
//
//  Created by MAC on 10/26/22.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    static let identifier = "CategoryTableViewCell"
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI(){
        self.selectionStyle = .none
        icon.tintColor = .white
        iconView.layer.cornerRadius = 20
        iconView.backgroundColor = .iconColor()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
