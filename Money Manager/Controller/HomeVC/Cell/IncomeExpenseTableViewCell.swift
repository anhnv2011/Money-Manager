//
//  IncomeExpenseTableViewCell.swift
//  Money Manager
//
//  Created by MAC on 10/26/22.
//

import UIKit

class IncomeExpenseTableViewCell: UITableViewCell {
    static let identifier = "IncomeExpenseTableViewCell"
   
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    private func setupUI(){
        self.selectionStyle = .none
        
        contentStackView.clipsToBounds = true
        contentStackView.layer.cornerRadius = 10
        contentStackView.layer.borderWidth = 1
        contentStackView.layer.borderColor = UIColor.separatorColor().cgColor
        
        incomeLabel.textColor = .incomeColor()
        incomeLabel.font = .semibold(ofSize: 18)
        expenseLabel.textColor = .expenseColor()
        expenseLabel.font = .semibold(ofSize: 18)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
