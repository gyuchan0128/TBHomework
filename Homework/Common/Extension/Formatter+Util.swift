//
//  Formatter+Util.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/23.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import Foundation

extension DateFormatter {
    func iso8601() -> Self {
        calendar = Calendar(identifier: .iso8601)
        locale = Locale.current
        timeZone = TimeZone.current
        dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return self
    }
}
