//
//  UITableViewCell+Extension.swift
//  MVVM-RxSwiftDemo
//
//  Created by Tin Phan Thanh on 8/2/19.
//  Copyright © 2019 Tin Phan Thanh. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var identifer: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifer, bundle: nil)
    }
}
