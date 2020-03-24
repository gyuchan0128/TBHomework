//
//  SearchCafeResponseModel.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/21.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import ObjectMapper

struct SearchCafeResponseModel: ResponseObject {
    var documents: [SearchCafeDocumentsResponseModel]?
    var meta: SearchMetaResponseModel?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        documents <- map["documents"]
        meta <- map["meta"]
    }
}

struct SearchCafeDocumentsResponseModel: SearchDocumentResponsable, Mappable {
    var type: ListRequestType = .cafe
    var name: String?
    var contents: String?
    var datetime: Date = Date(timeIntervalSince1970: .zero)
    var thumbnail: URL?
    var title: String = ""
    var url: URL?
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        name <- map["cafename"]
        contents <- map["contents"]
        if let isoDate = map.JSON["datetime"] as? String {
            let formatter = DateFormatter().iso8601()
            if let date = formatter.date(from: isoDate) {
                datetime = date
            } else {
                datetime = Date(timeIntervalSince1970: 0)
            }
        }
        thumbnail <- (map["thumbnail"], URLTransform())
        title <- map["title"]
        url <- (map["url"], URLTransform())
    }
}
