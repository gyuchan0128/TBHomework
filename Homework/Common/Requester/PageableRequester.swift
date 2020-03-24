//
//  PageableRequester.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/24.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional
import ObjectMapper

class PageableRequester<T: ResponseObject>: RequestViewModel, PageableRequest {
    private(set) var state: PageableRequestState = .ready
    private(set) var isEnd: Bool = false
    private(set) var currentPage: Int = 1
    let sizeOfPage: Int
    
    init(startPage: Int, sizeOfPage: Int) {
        self.currentPage = startPage
        self.sizeOfPage = sizeOfPage
        super.init()
        
        rxBind()
    }
    
    private func rxBind() {
        let request = input.nextRequest
            .filter { [weak self] info -> Bool in
                guard let self = self else { return false }
                // 쿼리가 비어있거나, 요청중이면 실행하지 않는다.
                guard info.query.count > 0, self.state == .ready else {
                    return false
                }
                return true
            }
            .do(onNext: { [weak self] info in
                guard let self = self else { return }
                if info.isRefresh {
                    self.isEnd = false
                    self.currentPage = 1
                }
            })
        // 페이징이 끝났을 때를 위한 바인딩
        rxBindForEnded(request:
            request
                .filter { [weak self] _ -> Bool in
                    guard let self = self else { return false }
                    return self.isEnd
                }
        )
        // 다음 페이지 요청을 위한 바인딩
        rxBindForNext(request:
            request
                .filter { [weak self] _ -> Bool in
                    guard let self = self else { return false }
                    return !self.isEnd
                }
        )
    }
    
    // 페이징이 끝났을 때를 위한 바인딩 함수
    private func rxBindForEnded(request: Observable<RequestViewModel.Input.RequestInfo>) {
        request
            .map { _ -> [SearchDocumentResponsable] in
                return []
            }
            .bind(to: output.items)
            .disposed(by: bag)
    }
    
    // 다음 페이지 요청을 위한 바인딩 함수
    private func rxBindForNext(request: Observable<RequestViewModel.Input.RequestInfo>) {
        request
            .flatMap { [weak self] info -> Single<T?> in
                guard let self = self else { return .just(nil) }
                self.state = .requesting
                if SearchBlogResponseModel.self == T.self {
                    let request: Single<T?> = Networker()
                        .request(api: SearchBlogAPI.search(query: info.query,
                                                           page: self.currentPage+1,
                                                           size: self.sizeOfPage))
                    return request
                } else if SearchCafeResponseModel.self == T.self {
                    let request: Single<T?> = Networker()
                        .request(api: SearchCafeAPI.search(query: info.query,
                                                           page: self.currentPage+1,
                                                           size: self.sizeOfPage))
                    return request
                } else {
                    return .just(nil)
                }
            }
            .observeOn(MainScheduler.instance)
            // 요청 완료 후 property update
            .do(onNext: { [weak self] response in
                guard let self = self else { return }
                self.state = .ready
                guard let searchResponse = response else { return }
                guard let meta = searchResponse.meta else { return }
                self.isEnd = meta.isEnd
                self.currentPage += 1
            })
            .map { response -> [SearchDocumentResponsable] in
                guard let response = response else { return [] }
                guard let list = response.documents as? [SearchDocumentResponsable] else { return [] }
                return list
            }
            .bind(to: output.items)
            .disposed(by: bag)
    }
}
