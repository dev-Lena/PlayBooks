//
//  ButtonsView.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/09.
//

import UIKit

protocol ButtonsViewDelegate: AnyObject {
    func didBuyButtonTapped()
    func didsalesInfoButtonTapped()
}

final class ButtonsView: UIView {
    
    weak var delegate: ButtonsViewDelegate?
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("구매하기", for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(didBuyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var salesInfoButton: UIButton = {
        let button = UIButton()
        button.setTitle("구매정보", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(didsalesInfoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buyButton, salesInfoButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(buttonsHStackView)
        buttonsHStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func didBuyButtonTapped() {
        delegate?.didBuyButtonTapped()
    }
    
    @objc private func didsalesInfoButtonTapped() {
        delegate?.didsalesInfoButtonTapped()
    }
    
}
