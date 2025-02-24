//
//  LotteryViewController.swift
//  LotteryAPI
//
//  Created by 박준우 on 1/14/25.
//

import UIKit
import SnapKit
import Alamofire

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
    
    private lazy var lottoRoundPickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.delegate = self
        pv.dataSource = self
        pv.backgroundColor = UIColor.lightGray
        return pv
    }()
    
    private var lottoInfoLabel: UILabel = {
        let lb = UILabel()
        lb.text = "당첨번호 안내"
        lb.textColor = UIColor.black
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        return lb
    }()
    
    private var lottoDateLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lightGray
        lb.font = UIFont.boldSystemFont(ofSize: 11)
        return lb
    }()
    
    private var lottoInfoDivider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private var lottoResultLabel: UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lo = UICollectionViewFlowLayout()
        lo.minimumLineSpacing = 4
        lo.minimumInteritemSpacing = 4
        let total: CGFloat = 4.0 * 2 + 4.0 * 7
        lo.itemSize = CGSize(width: (UIScreen.main.bounds.width - total - 32) / 8, height: 100)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: lo)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private var currentData: Lottery = Mock.lottery {
        didSet {
            lottoDateLabel.text = currentData.drwNoDate.returnLotteryDateString()
            lottoResultLabel.attributedText = currentData.drwNo.returnLotteryResultString()
            collectionView.reloadData()
        }
    }
    
    private var recentLotteryRound: Int = 1154
    
    private var lotteryRoundList: Array<Int> {
        return Array(1...recentLotteryRound)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureHierarchy()
        self.configureLayout()
        self.configureCollectionView()
        
        AF.request("https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(self.recentLotteryRound)").responseDecodable(of: Lottery.self) { response in
            switch response.result {
            case .success(let data):
                self.currentData = data
            case .failure(let error): print(error)
            }
        }
    }
    
    func configureHierarchy() {
        self.view.addSubviews(self.lottoRoundTextField, self.lottoInfoLabel, self.lottoDateLabel, self.lottoInfoDivider, self.lottoResultLabel, self.collectionView)
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
    }
    
    func configureView() {
        self.view.backgroundColor = .white
        self.lottoRoundTextField.text = "\(self.recentLotteryRound)"
        self.lottoRoundPickerView.selectRow(self.lotteryRoundList.firstIndex(of: self.recentLotteryRound)!, inComponent: 0, animated: false)
    }
}

extension LotteryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.lotteryRoundList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // TODO: String(row) 와 "\(row)" 차이는?
        return String(self.lotteryRoundList[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let round: Int = row + 1
        lottoRoundTextField.text = "\(round)"
        AF.request("https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(round)").responseDecodable(of: Lottery.self) { response in
            switch response.result {
            case .success(let data):
                self.currentData = data
                self.view.endEditing(true)
            case .failure(let error): print(error)
            }
        }
    }
}

extension LotteryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func configureCollectionView() {
        collectionView.register(LotteryCollectionViewCell.self, forCellWithReuseIdentifier: LotteryCollectionViewCell.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
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
