//
//  MainViewModel.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/21.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional


final class MainViewModel {
    struct Const {
        static let pagingSize: Int = 25
    }
    
    let bag: DisposeBag = DisposeBag()
    private var currentPage: UInt = 1
    private var hasNextPage: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    init() {
        let request: Single<SearchBlogResponseModel> = Networker()
            .request(api: SearchBlogAPI.search(query: "여행",
                                               page: 1,
                                               size: Const.pagingSize))
        request.asObservable()
            .map { $0.meta?.isEnd }
            .filterNil()
            .bind(to: hasNextPage)
            .disposed(by: bag)
    }
}
