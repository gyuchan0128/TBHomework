//
//  SearchBlogResponseModel.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/21.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import ObjectMapper

struct SearchBlogResponseModel: Mappable {
    var documents: [SearchBlogDocumentsResponseModel]?
    var meta: SearchMetaResponseModel?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        documents <- map["documents"]
        meta <- map["meta"]
    }
}

struct SearchBlogDocumentsResponseModel: SearchDocumentResponse, Mappable {
    var name: String?
    var contents: String?
    var datetime: Date?
    var thumbnail: URL?
    var title: String?
    var url: URL?
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        name <- map["blogname"]
        contents <- map["contents"]
        datetime <- (map["datetime"], DateTransform())
        thumbnail <- (map["thumbnail"], URLTransform())
        title <- map["title"]
        url <- (map["url"], URLTransform())
    }
}
