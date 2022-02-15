//
//  RootViewController.swift
//  BehaviorRelayAsync
//
//  Created by 이건준 on 2022/02/15.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class RootViewController: UIViewController {
    let newestButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("최신순", for: .normal)
        return btn
    }()
    
    let oldestButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("과거순", for: .normal)
        return btn
    }()
    
    let oneMonthButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("1월", for: .normal)
        return btn
    }()
    
    let threeMonthButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("3월", for: .normal)
        return btn
    }()
    
    let sixMothButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("6월", for: .normal)
        return btn
    }()
    
    let answerButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("확인", for: .normal)
        btn.isEnabled = false
        return btn
    }()
    
    let cancelButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("취소", for: .normal)
        return btn
    }()
    
    enum SortType {
        case none
        case newest
        case oldest
    }
    
    enum MonthType {
        case none
        case one
        case three
        case six
    }
    
    let sortRelay = BehaviorRelay<SortType>(value: .none)
    let monthRelay = BehaviorRelay<MonthType>(value: .none)
    let disposeBag = DisposeBag()
    
    let ob1 = Observable.from([1, 2, 3])
    let ob2 = Observable.from([15, 4, 6])
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
            
        Observable.combineLatest(
            sortRelay.map{ $0 != .none },
            monthRelay.map{ $0 != .none }
        ) { $0 && $1 }
        .bind(to: answerButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        Observable.merge(
            newestButton.rx.tap.map {SortType.newest},
            oldestButton.rx.tap.map {SortType.oldest}
        )
        .bind(to: sortRelay)
        .disposed(by: disposeBag)
        
        Observable.merge(
            oneMonthButton.rx.tap.map{ MonthType.one },
            threeMonthButton.rx.tap.map{ MonthType.three },
            sixMothButton.rx.tap.map{ MonthType.six }
        )
        .bind(to: monthRelay)
        .disposed(by: disposeBag)
        
        let sortIsSelected = sortRelay.flatMap{ [weak self] in
            Observable.from([
                ($0 == .newest, self?.newestButton),
                ($0 == .oldest, self?.oldestButton)
            ])
        }
        
        sortIsSelected.asDriver(onErrorJustReturn: (false, nil))
            .drive(onNext: { (selected, button) in
                button?.isSelected = selected
            }).disposed(by: disposeBag)
        
        let monthIsSelected = monthRelay.flatMap { [weak self] in
            Observable.from([
                ($0 == .one, self?.oneMonthButton),
                ($0 == .three, self?.threeMonthButton),
                ($0 == .six, self?.sixMothButton)
            ])
        }
        
        
        
        
        
        
        
//        sortRelay.map{$0 == .newest}.bind(to: newestButton.rx.isSelected).disposed(by: disposeBag)
//        sortRelay.map{$0 == .oldest}.bind(to: oldestButton.rx.isSelected).disposed(by: disposeBag)
//        monthRelay.map{$0 == .one}.bind(to: oneMonthButton.rx.isSelected).disposed(by: disposeBag)
//        monthRelay.map{$0 == .three}.bind(to: threeMonthButton.rx.isSelected).disposed(by: disposeBag)
//        monthRelay.map{$0 == .six}.bind(to: sixMothButton.rx.isSelected).disposed(by: disposeBag)
        
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(newestButton)
        newestButton.translatesAutoresizingMaskIntoConstraints = false
        newestButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width / 4).isActive = true
        newestButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.width / 4).isActive = true
        
        view.addSubview(oldestButton)
        oldestButton.translatesAutoresizingMaskIntoConstraints = false
        oldestButton.centerYAnchor.constraint(equalTo: newestButton.centerYAnchor).isActive = true
        oldestButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -(view.frame.width / 4)).isActive = true
        
        view.addSubview(oneMonthButton)
        oneMonthButton.translatesAutoresizingMaskIntoConstraints = false
        oneMonthButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width / 6).isActive = true
        oneMonthButton.topAnchor.constraint(equalTo: oldestButton.bottomAnchor, constant: 30).isActive = true
        
        view.addSubview(threeMonthButton)
        threeMonthButton.translatesAutoresizingMaskIntoConstraints = false
        threeMonthButton.centerYAnchor.constraint(equalTo: oneMonthButton.centerYAnchor).isActive = true
        threeMonthButton.leftAnchor.constraint(equalTo: oneMonthButton.rightAnchor, constant: view.frame.width / 6).isActive = true
        
        view.addSubview(sixMothButton)
        sixMothButton.translatesAutoresizingMaskIntoConstraints = false
        sixMothButton.centerYAnchor.constraint(equalTo: threeMonthButton.centerYAnchor).isActive = true
        sixMothButton.leftAnchor.constraint(equalTo: threeMonthButton.rightAnchor, constant: view.frame.width / 6).isActive = true
        
        view.addSubview(answerButton)
        answerButton.translatesAutoresizingMaskIntoConstraints = false
        answerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width / 4).isActive = true
        answerButton.topAnchor.constraint(equalTo: oneMonthButton.bottomAnchor, constant: 30).isActive = true
        
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.centerYAnchor.constraint(equalTo: answerButton.centerYAnchor).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: answerButton.rightAnchor, constant: view.frame.width / 4).isActive = true
        
    }
}
