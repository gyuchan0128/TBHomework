//
//  BlogManager.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/22.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

final class BlogRequester: RequestViewModel, PageableRequest {
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
        // 페이징이 끝났다면 API 호출을 하지 않는다.
        request
            .filter { [weak self] _ -> Bool in
                guard let self = self else { return false }
                return self.isEnd
            }
            .map { _ -> [SearchDocumentResponse] in
                return []
            }
            .bind(to: output.items)
            .disposed(by: bag)
        
        // 다음 페이지 요청
        request
            .filter { [weak self] _ -> Bool in
                guard let self = self else { return false }
                return !self.isEnd
            }
            .flatMap { [weak self] info -> Single<SearchBlogResponseModel?> in
                guard let self = self else { return .just(nil) }
                self.state = .requesting
                let request: Single<SearchBlogResponseModel?> = Networker()
                    .request(api: SearchBlogAPI.search(query: info.query,
                                                       page: self.currentPage+1,
                                                       size: self.sizeOfPage))
                return request
            }
            // 요청 완료 후 property update
            .do(onNext: { [weak self] response in
                guard let self = self else { return }
                self.state = .ready
                guard let meta = response?.meta else { return }
                self.isEnd = meta.isEnd
                self.currentPage += 1
            })
            .map { response -> [SearchDocumentResponse] in
                guard let list = response?.documents else { return [] }
                return list
            }
            .bind(to: output.items)
            .disposed(by: bag)
    }
}
