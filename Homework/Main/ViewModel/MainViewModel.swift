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

final class MainViewModel: ReactiveViewModel {
    struct Const {
        static let pagingSize: Int = 25
    }
    struct Input {
        struct RequestInfo {
            let isRefresh: Bool
            let filterType: FilterType
            let query: String
        }
        let request: PublishRelay<RequestInfo> = PublishRelay<RequestInfo>()
    }
    struct Output {
        let updateList: PublishRelay<Void> = PublishRelay<Void>()
    }
    
    enum FilterType {
        case all
        case blog
        case cafe
    }
    enum SortType {
        case title
        case dateTime
    }
    
    let bag: DisposeBag = DisposeBag()
    let blogRequester = BlogRequester(startPage: 1, sizeOfPage: Const.pagingSize)
    let cafeRequester = CafeRequester(startPage: 1, sizeOfPage: Const.pagingSize)

    private(set) var currentFilterType: FilterType = .all
    private(set) var currentSortType: SortType = .title
    private(set) var beforeQuery: String = ""
    
    private(set) var input: Input = Input()
    private(set) var output: Output = Output()
    
    private(set) var items: [SearchDocumentResponse] = []
    
    init() {
        rxBind()
    }
    
    private func rxBind() {
        input.request
            .subscribe(onNext: { [weak self] info in
                guard let self = self else { return }
                self.currentFilterType = info.filterType
                self.beforeQuery = info.query
                if info.isRefresh {
                    self.items = []
                }
            })
            .disposed(by: bag)
        
        rxBindForAll(request: input.request.filter { $0.filterType == .all })
        rxBindForOnlyBlog(request: input.request.filter { $0.filterType == .blog })
        rxBindForOnlyCafe(request: input.request.filter { $0.filterType == .cafe })
    }
    
    private func rxBindForAll(request: Observable<Input.RequestInfo>) {
        let toRequestInfo = request
            .map { info -> RequestViewModel.Input.RequestInfo in
                return .init(isRefresh: info.isRefresh, query: info.query)
            }
        toRequestInfo.bind(to: blogRequester.input.nextRequest).disposed(by: bag)
        toRequestInfo.bind(to: cafeRequester.input.nextRequest).disposed(by: bag)
    }
    private func rxBindForOnlyBlog(request: Observable<Input.RequestInfo>) {
        let toRequestInfo = request
            .map { info -> RequestViewModel.Input.RequestInfo in
                return .init(isRefresh: info.isRefresh, query: info.query)
            }
        toRequestInfo.bind(to: blogRequester.input.nextRequest).disposed(by: bag)
        
        blogRequester.output.items
            .asObservable()
            .do(onNext: { [weak self] items in
                guard let self = self else { return }
                self.items.append(contentsOf: items)
                //현재 정렬방법에 맞춰 다시 정렬을 진행한다.
                if items.count > 0 {
                    self.sortItems()
                }
            })
            .map { _ in Void() }
            .bind(to: output.updateList)
            .disposed(by: bag)
    }
    private func rxBindForOnlyCafe(request: Observable<Input.RequestInfo>) {
        let toRequestInfo = request
            .map { info -> RequestViewModel.Input.RequestInfo in
                return .init(isRefresh: info.isRefresh, query: info.query)
            }
        toRequestInfo.bind(to: cafeRequester.input.nextRequest).disposed(by: bag)
        
        cafeRequester.output.items
            .asObservable()
            .do(onNext: { [weak self] items in
                guard let self = self else { return }
                self.items.append(contentsOf: items)
                //현재 정렬방법에 맞춰 다시 정렬을 진행한다.
                if items.count > 0 {
                    self.sortItems()
                }
            })
            .map { _ in Void() }
            .bind(to: output.updateList)
            .disposed(by: bag)
    }
    
    private func sortItems() {
        //현재 정렬방법에 맞춰 다시 정렬을 진행한다.
        switch self.currentSortType {
        case .title:
            self.items.sort { (first, second) -> Bool in
                return first.title < second.title
            }
        case .dateTime:
            self.items.sort { (first, second) -> Bool in
                return first.datetime < second.datetime
            }
        }
    }
}
