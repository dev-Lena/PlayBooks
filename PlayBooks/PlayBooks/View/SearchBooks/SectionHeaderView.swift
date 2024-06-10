//
//  SectionHeaderView.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/10.
//

import UIKit
import SnapKit

final class SectionHeaderView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.text = "Google Play 검색결과"
        return label
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
        self.addSubview(titleLabel)
        self.backgroundColor = .white
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }
}
