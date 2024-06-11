//
//  UIView+Extension.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/10.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
