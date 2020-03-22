//
//  SearchDocumentResponse.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/21.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import Foundation

protocol SearchDocumentResponse {
    var type: ListRequestType { get }
    var name: String? { get }
    var contents: String? { get }
    var datetime: Date { get }
    var thumbnail: URL? { get }
    var title: String { get }
    var url: URL? { get }
}
