//
//  SearchBlogAPI.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/21.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import UIKit
import Alamofire

protocol TBAPI {
    func url() -> URLConvertible
    func method() -> HTTPMethod
    func params() -> Parameters
}

enum SearchBlogAPI: TBAPI {
    case search(query: String, page: Int, size: Int)
    
    func url() -> URLConvertible {
        let endpoint: String = "https://dapi.kakao.com"
        switch self {
        case .search:
            guard var url = URL(string: endpoint) else { return "" }
            url.appendPathComponent("v2")
            url.appendPathComponent("search")
            url.appendPathComponent("blog")
            return url
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .search: return .get
        }
    }
    
    func params() -> Parameters {
        switch self {
        case .search(let query, let page, let size):
            var params: Parameters = [:]
            params["query"] = query
            params["page"] = page
            params["size"] = size
            return params
        }
    }
}
