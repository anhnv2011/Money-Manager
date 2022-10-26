//
//  HeaderView.swift
//  Money Manager
//
//  Created by MAC on 10/26/22.
//

import UIKit

class HeaderView: UIView {
    let tiltleLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    var buttonHeader: UIButton = {
        let button = UIButton()
        button.setTitleColor(.mainColor(), for: .normal)
        button.titleLabel?.font = .semibold(ofSize: 14)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    var completion : (() -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI(){
        addSubview(tiltleLabel)
        addSubview(buttonHeader)
        tiltleLabel.center.y = center.y
        tiltleLabel.frame = .init(x: 24, y: 0, width: 100, height: 40)
        buttonHeader.frame = .init(x: frame.maxX-124, y: 0, width: 100, height: 40)
        buttonHeader.center.y = center.y
        buttonHeader.addTarget(self, action: #selector(buttonHeaderAction), for: .touchUpInside)
        
    }
    
    @objc func buttonHeaderAction(){
        completion!()
    }
    
    func configureHeader(title: String, buttonTitle: String){
        tiltleLabel.text = title
        buttonHeader.setTitle(buttonTitle, for: .normal)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
