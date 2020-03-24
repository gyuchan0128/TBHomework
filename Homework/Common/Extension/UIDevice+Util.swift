//
//  UIDevice+Util.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/24.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
    }
}
