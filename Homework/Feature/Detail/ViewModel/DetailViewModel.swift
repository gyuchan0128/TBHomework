//
//  DetailViewModel.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/23.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import Foundation

final class DetailViewModel {
    private let model: SearchDocumentResponse
    
    init(model: SearchDocumentResponse) {
        self.model = model
    }
    
    var imageURL: URL? {
        return model.thumbnail
    }
    
    var type: ListRequestType {
        return model.type
    }
    
    var name: String? {
        return model.name
    }
    
    var title: String? {
        return model.title
    }
    
    var contents: String? {
        return model.contents
    }
    
    var dateTime: String? {
        let dateFormatter = DateFormatter.iso8601
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
        return dateFormatter.string(from: model.datetime)
    }
    
    var link: URL? {
        return model.url
    }
}
