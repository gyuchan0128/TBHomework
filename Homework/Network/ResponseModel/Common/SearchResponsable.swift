//
//  SearchResponsable.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/24.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import ObjectMapper

protocol SearchResponsable {
    associatedtype T
    var documents: [T]? { get set }
    var meta: SearchMetaResponseModel? { get set }
}

protocol ResponseObject: Mappable, SearchResponsable { }
