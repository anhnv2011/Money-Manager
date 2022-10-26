//
//  AdsTableViewCell.swift
//  Money Manager
//
//  Created by MAC on 10/26/22.
//

import UIKit

class AdsTableViewCell: UITableViewCell {
    static let identifier = "AdsTableViewCell"

    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrAds = ["ads1", "ads2"]
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AdsTableViewCellCell", bundle: nil), forCellWithReuseIdentifier: AdsTableViewCellCell.identifier)
    }
}

extension AdsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdsTableViewCellCell.identifier, for: indexPath) as! AdsTableViewCellCell
        cell.imgAds.image = UIImage(named: arrAds[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.width*2/3, height: collectionView.bounds.height)
    }
}

