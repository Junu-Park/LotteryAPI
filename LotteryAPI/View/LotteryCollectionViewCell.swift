//
//  LotteryCollectionViewCell.swift
//  LotteryAPI
//
//  Created by 박준우 on 1/14/25.
//

import UIKit
import SnapKit

final class LotteryCollectionViewCell: UICollectionViewCell {
    
    static let id = "LotteryCollectionViewCell"
    
    let numberLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        lb.clipsToBounds = true
        return lb
    }()
    
    let bunusLabel: UILabel = {
        let lb = UILabel()
        lb.text = "보너스"
        lb.textColor = UIColor.clear
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureHierarchy()
        self.configureLayout()
    }
    
    func configureHierarchy() {
        self.contentView.addSubviews(self.numberLabel, self.bunusLabel)
    }
    
    func configureLayout() {
        self.numberLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.numberLabel.snp.width)
        }
        self.bunusLabel.snp.makeConstraints { make in
            make.top.equalTo(self.numberLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
