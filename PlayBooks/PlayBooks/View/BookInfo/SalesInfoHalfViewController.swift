//
//  SalesInfoHalfViewController.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/10.
//

import UIKit

final class SalesInfoHalfViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.text = "가격 정보"
        label.textColor = .black
        return label
    }()

    private lazy var listPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    private lazy var retailPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    private lazy var labelsVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ titleLabel, listPriceLabel, retailPriceLabel])
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private var book: Book?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        setupViews()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(labelsVStackView)
        setupConstraint()
        let salesInfo = self.book?.saleInfo
        self.setPriceLabels(
            price: salesInfo?.listPrice?.amount,
            currency: salesInfo?.listPrice?.currencyCode,
            label: listPriceLabel,
            type: .listPrice)
        self.setPriceLabels(
            price: salesInfo?.retailPrice?.amount,
            currency: salesInfo?.retailPrice?.currencyCode,
            label: retailPriceLabel,
            type: .retailPrice)
    }
    
    private func setupConstraint() {
        labelsVStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    private func setPriceLabels(price: Int?, currency: String?, label: UILabel, type: PriceType) {
        let price = price ?? 0
        let currency = currency ?? "KRW"
        var textArray: [String] = []
        switch type {
        case .listPrice:
            textArray.append("🏷️ 정가")
        case .retailPrice:
            textArray.append("🏷️ 소매가")
        }
        textArray.append(contentsOf: [currency, String(price)])
        DispatchQueue.main.async {
            label.text = textArray.joined(separator: " ")
        }
    }
}

extension SalesInfoHalfViewController {
    enum PriceType {
        case listPrice
        case retailPrice
    }
}
