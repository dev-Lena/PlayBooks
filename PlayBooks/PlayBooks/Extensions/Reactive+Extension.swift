//
//  Reactive+Extension.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/07.
//

import UIKit.UIScrollView
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    var reachedBottom: Observable<Void> {
        return contentOffset
            .flatMap { [weak base] contentOffset -> Observable<Void> in
                guard let scrollView = base else { return Observable.empty() }
                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = scrollView.contentSize.height - visibleHeight
                return y > threshold ? Observable.just(()) : Observable.empty()
            }
    }
}
