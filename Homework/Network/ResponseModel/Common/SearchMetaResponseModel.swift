//
//  SearchMetaResponseModel.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/21.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import Foundation
import ObjectMapper

struct SearchMetaResponseModel: Mappable {
    var isEnd: Bool = true
    var pageableCount: UInt64 = 0
    var totalCount: UInt64 = 0

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        isEnd <- map["is_end"]
        pageableCount <- map["pageable_count"]
        totalCount <- map["total_count"]
    }
}
