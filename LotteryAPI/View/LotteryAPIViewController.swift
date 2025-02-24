//
//  LotteryAPIViewController.swift
//  LotteryAPI
//
//  Created by 박준우 on 1/14/25.
//

import UIKit
import SnapKit
import Alamofire

protocol LotteryAPIViewControllerProtocol: AnyObject {
    // TODO: 변수도 한 번 해봤는데...굳이...? 일회성인데...?
    var lottoRoundTextField: UITextField { get }
    var lottoRoundPickerView: UIPickerView { get }
    var lottoInfoLabel: UILabel { get }
    var lottoDateLabel: UILabel { get }
    var lottoResultLabel: UILabel { get }
    var collectionView: UICollectionView { get }
    
    func configureHierarchy()
    func configureLayout()
}

class LotteryAPIViewController: UIViewController, LotteryAPIViewControllerProtocol {
    
    lazy var lottoRoundTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.textColor = UIColor.black
        tf.tintColor = UIColor.black
        tf.borderStyle = .roundedRect
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.inputView = lottoRoundPickerView
        return tf
    }()
    
    // TODO: 여기에서 delegate / dataSource 선언해도 해도 될까? => self 써야하는데 초기화되는 과정에는 불가능! lazy를 붙여줘야!
    lazy var lottoRoundPickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.delegate = self
        pv.dataSource = self
        pv.backgroundColor = UIColor.lightGray
        return pv
    }()
    
    var lottoInfoLabel: UILabel = {
        let lb = UILabel()
        lb.text = "당첨번호 안내"
        lb.textColor = UIColor.black
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        return lb
    }()
    
    var lottoDateLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lightGray
        lb.font = UIFont.boldSystemFont(ofSize: 11)
        return lb
    }()
    
    var lottoInfoDivider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    var lottoResultLabel: UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    lazy var collectionView: UICollectionView = {
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
    
    var currentData: LotteryData = LotteryData.lotteryMockData {
        didSet {
            lottoDateLabel.text = currentData.drwNoDate.returnLotteryDateString()
            lottoResultLabel.attributedText = currentData.drwNo.returnLotteryResultString()
            collectionView.reloadData()
        }
    }
    
    var recentLotteryRound: Int = 1154
    
    var lotteryRoundList: Array<Int> {
        return Array(1...recentLotteryRound)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        configureHierarchy()
        configureLayout()
        configurePickerView()
        configureCollectionView()
        
        AF.request("https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(recentLotteryRound)").responseDecodable(of: LotteryData.self) { response in
            switch response.result {
            case .success(let data):
                self.currentData = data
            case .failure(let error): print(error)
            }
        }
        lottoRoundTextField.text = "\(recentLotteryRound)"
        lottoRoundPickerView.selectRow(lotteryRoundList.firstIndex(of: recentLotteryRound)!, inComponent: 0, animated: false)
    }
    
    func configureHierarchy() {
        /*
        view.addSubview(lottoRoundTextField)
        view.addSubview(lottoInfoLabel)
        view.addSubview(lottoDateLabel)
        view.addSubview(lottoInfoDivider)
        view.addSubview(lottoResultLabel)
        view.addSubview(collectionView)
         */
        view.addSubviews(lottoRoundTextField, lottoInfoLabel, lottoDateLabel, lottoInfoDivider, lottoResultLabel, collectionView)
    }
    
    func configureLayout() {
        lottoRoundTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        lottoInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(lottoRoundTextField.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(16)
        }
        
        lottoDateLabel.snp.makeConstraints { make in
            make.top.equalTo(lottoRoundTextField.snp.bottom).offset(32)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        lottoInfoDivider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(lottoInfoLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        lottoResultLabel.snp.makeConstraints { make in
            make.top.equalTo(lottoInfoDivider.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(lottoResultLabel.snp.bottom).offset(32)
            make.height.equalTo(100)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension LotteryAPIViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func configurePickerView() {
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lotteryRoundList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // TODO: String(row) 와 "\(row)" 차이는?
        return String(lotteryRoundList[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let round: Int = row + 1
        lottoRoundTextField.text = "\(round)"
        AF.request("https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(round)").responseDecodable(of: LotteryData.self) { response in
            switch response.result {
            case .success(let data):
                self.currentData = data
                self.view.endEditing(true)
            case .failure(let error): print(error)
            }
        }
    }
}

extension LotteryAPIViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
