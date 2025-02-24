//
//  LotteryViewController.swift
//  LotteryAPI
//
//  Created by 박준우 on 1/14/25.
//

import UIKit

import Alamofire
import RxCocoa
import RxSwift
import SnapKit

protocol LotteryViewControllerProtocol: AnyObject {
    func configureHierarchy()
    func configureLayout()
    func configureView()
}

final class LotteryViewController: UIViewController, LotteryViewControllerProtocol {
    
    private lazy var lottoRoundTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.textColor = UIColor.black
        tf.tintColor = UIColor.black
        tf.borderStyle = .roundedRect
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.inputView = self.lottoRoundPickerView
        return tf
    }()
    private let lottoRoundPickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.backgroundColor = UIColor.lightGray
        return pv
    }()
    private let lottoInfoLabel: UILabel = {
        let lb = UILabel()
        lb.text = "당첨번호 안내"
        lb.textColor = UIColor.black
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        return lb
    }()
    private let lottoDateLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lightGray
        lb.font = UIFont.boldSystemFont(ofSize: 11)
        return lb
    }()
    private let lottoInfoDivider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    private let lottoResultLabel: UILabel = UILabel()
    private let collectionView: UICollectionView = {
        let lo = UICollectionViewFlowLayout()
        lo.minimumLineSpacing = 4
        lo.minimumInteritemSpacing = 4
        let total: CGFloat = 4.0 * 2 + 4.0 * 7
        lo.itemSize = CGSize(width: (UIScreen.main.bounds.width - total - 32) / 8, height: 100)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: lo)
        cv.register(LotteryCollectionViewCell.self, forCellWithReuseIdentifier: LotteryCollectionViewCell.id)
        return cv
    }()
    private let observableButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Observable", for: [])
        btn.backgroundColor = .blue.withAlphaComponent(0.5)
        return btn
    }()
    private let singleButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Single", for: [])
        btn.backgroundColor = .red.withAlphaComponent(0.5)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureHierarchy()
        self.configureLayout()
        self.configureView()
        self.bind()
    }
    
    func configureHierarchy() {
        self.view.addSubviews(self.lottoRoundTextField, self.lottoInfoLabel, self.lottoDateLabel, self.lottoInfoDivider, self.lottoResultLabel, self.collectionView, self.observableButton, self.singleButton)
    }
    
    func configureLayout() {
        self.lottoRoundTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
        
        self.lottoInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.lottoRoundTextField.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(16)
        }
        
        self.lottoDateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.lottoRoundTextField.snp.bottom).offset(32)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        self.lottoInfoDivider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(self.lottoInfoLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        self.lottoResultLabel.snp.makeConstraints { make in
            make.top.equalTo(self.lottoInfoDivider.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.lottoResultLabel.snp.bottom).offset(32)
            make.height.equalTo(100)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        self.observableButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.centerY.equalToSuperview().offset(32)
        }
        
        self.singleButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-32)
            make.centerY.equalToSuperview().offset(32)
        }
    }
    
    func configureView() {
        self.view.backgroundColor = .white
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LotteryCollectionViewCell.id, for: indexPath) as! LotteryCollectionViewCell
        if let number = currentData.getDrwNo(index: indexPath.item) {
            let color = currentData.getDrwNoColor(number: number)
            cell.numberLabel.backgroundColor = color
            cell.numberLabel.text = "\(number)"
            cell.numberLabel.textColor = UIColor.white
            cell.bunusLabel.textColor = indexPath.item == 7 ? color : UIColor.clear
            DispatchQueue.main.async {
                cell.numberLabel.layer.cornerRadius = cell.numberLabel.frame.width / 2
            }
        }else {
            cell.numberLabel.text = "+"
            cell.numberLabel.textColor = UIColor.black
            cell.numberLabel.backgroundColor = UIColor.clear
        }
        return cell
    }
}
