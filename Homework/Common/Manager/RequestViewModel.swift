//
//  RequestManager.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/22.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import RxSwift
import RxCocoa

enum PageableRequestState {
    case ready
    case requesting
}

protocol PageableRequest {
    var state: PageableRequestState { get }
    var isEnd: Bool { get }
    var currentPage: Int { get }
    var sizeOfPage: Int { get }
}

class RequestViewModel: ReactiveViewModel {
    typealias InputType = Input
    typealias OutputType = Output
    
    struct Input {
        struct RequestInfo {
            let isRefresh: Bool
            let query: String
        }
        let nextRequest: PublishRelay<RequestInfo> = PublishRelay<RequestInfo>()
    }
    struct Output {
        let items: PublishRelay<[SearchDocumentResponsable]> = PublishRelay<[SearchDocumentResponsable]>()
    }

    let bag: DisposeBag = DisposeBag()

    private(set) var input: Input = Input()
    private(set) var output: Output = Output()
}
