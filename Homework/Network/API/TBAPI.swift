//
//  TBAPI.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/24.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import Alamofire

protocol TBAPI {
    func url() -> URLConvertible
    func method() -> HTTPMethod
    func params() -> Parameters
}
