//
//  FruitViewController.swift
//  ReactorKitSample
//
//  Created by 김정민 on 11/14/24.
//

import UIKit
import ReactorKit
import RxCocoa

final class FruitViewController: UIViewController {
    
    private lazy var appleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("사과", for: .normal)
        return button
    }()
    
    private lazy var bananaButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("바나나", for: .normal)
        return button
    }()
    
    private lazy var grapeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("포도", for: .normal)
        return button
    }()
    
    private lazy var selectedLabel: UILabel = {
        let label = UILabel()
        label.text = "선택되어진 과일 없음"
        return label
    }()
    
    // MARK: Binding Properties
    private let disposeBag = DisposeBag()
    private let fruitReactor = FruitReactor()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.appleButton, self.bananaButton, self.grapeButton, self.selectedLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setup()
        self.bind(reactor: self.fruitReactor)
    }

    private func setup() {
        view.addSubview(self.stack)
        NSLayoutConstraint.activate([
            self.stack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.stack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    private func bind(reactor: FruitReactor) {
        // View -> Reactor
        self.appleButton.rx.tap
            .map { FruitReactor.Action.apple }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.bananaButton.rx.tap
            .map { FruitReactor.Action.banana }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.grapeButton.rx.tap
            .map { FruitReactor.Action.grape }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // Reactor -> View
        reactor.state.map { $0.fruitName }
            .distinctUntilChanged()
            .map { $0 }
            .bind(to: self.selectedLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .map { $0 }
            .subscribe(with: self, onNext: { owner, isLoading in
                if isLoading {
                    owner.selectedLabel.text = "로딩중입니다"
                }
            })
            .disposed(by: self.disposeBag)
    }
}

