//
//  Networker.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/21.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa
import ObjectMapper

enum ListRequestType: Hashable {
    case blog
    case cafe
    
    func toPresentableFilterType() -> CellPresentableModel.FilterType {
        switch self {
        case .blog:
            return .blog
        case .cafe:
            return .cafe
        }
    }
}

struct Networker {
    private let manager = SessionManager.default
    
    init() {
    }
    
    private func commonHeader() -> [String: String] {
        return ["Authorization": "KakaoAK eb4859c8095d99411e0c184b3bb36bb0"]
    }
    
    func request<T: Mappable>(api: TBAPI) -> Single<T?> {
        let request = manager.rx.json(api.method(),
                                  api.url(),
                                  parameters: api.params(),
                                  headers: commonHeader())
            .mapObject(type: T.self)
            .asSingle()
        return request
    }
}


extension ObservableType {
    public func mapObject<T: Mappable>(type: T.Type) -> Observable<T?> {
        return flatMap { data -> Observable<T?> in
            let json = data as AnyObject
            guard let object = Mapper<T>().map(JSONObject: json) else {
                return .just(nil)
            }
            return Observable.just(object)
        }
    }

    public func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]?> {
        return flatMap { data -> Observable<[T]?> in
            let json = data as AnyObject
            guard let object = Mapper<T>().mapArray(JSONObject: json) else {
                return .just(nil)
            }
            return Observable.just(object)
        }
    }
}
