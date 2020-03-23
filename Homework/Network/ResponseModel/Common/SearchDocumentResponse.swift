//
//  SearchDocumentResponse.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/21.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import Foundation

protocol SearchDocumentResponse {
    var type: ListRequestType { get }   // 값이 반드시 존재한다.
    var name: String? { get }
    var contents: String? { get }
    var datetime: Date { get }          // 값이 반드시 존재한다고 가정한다.
    var thumbnail: URL? { get }
    var title: String { get }           // Response값이 안오더라도 빈 값이라도 채워넣도록 한다. (sorting의 기준이 된다.)
    var url: URL? { get }
}
