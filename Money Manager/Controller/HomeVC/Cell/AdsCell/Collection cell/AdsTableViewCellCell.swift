//
//  AdsTableViewCellCell.swift
//  Money Manager
//
//  Created by MAC on 10/26/22.
//

import UIKit

class AdsTableViewCellCell: UICollectionViewCell {
    static let identifier = "AdsTableViewCellCell"

    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var imgAds: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vContent.clipsToBounds = true
        vContent.layer.cornerRadius = 10
        imgAds.contentMode = .scaleAspectFill
    }

}
