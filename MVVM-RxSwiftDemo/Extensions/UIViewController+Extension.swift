//
//  UIViewController+Extension.swift
//  MVVM-RxSwiftDemo
//
//  Created by Tin Phan Thanh on 8/2/19.
//  Copyright © 2019 Tin Phan Thanh. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

public protocol LoadingAble: class {
    func startAnimating()
    func stopAnimating()
}

extension LoadingAble where Self: UIViewController {
    func startAnimating() {
        let activityView = UIActivityIndicatorView(style: .gray)
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }

    func stopAnimating() {
        for item in view.subviews where item is UIActivityIndicatorView {
            UIView.animate(withDuration: 0.3, animations: {
                item.alpha = 0
            }) { (_) in
                item.removeFromSuperview()
            }
        }
    }
}

extension Reactive where Base: LoadingAble {
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        })
    }
}
