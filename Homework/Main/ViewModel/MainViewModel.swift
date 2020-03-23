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
        struct RequestInfo: Equatable {
            let isRefresh: Bool
            let filterType: FilterType
            let query: String
            
            static func == (lhs: RequestInfo, rhs: RequestInfo) -> Bool {
                return lhs.isRefresh == rhs.isRefresh &&
                    lhs.filterType == rhs.filterType &&
                    lhs.query == rhs.query
            }
        }
        let nextRequest: PublishRelay<RequestInfo> = PublishRelay<RequestInfo>()
        let changeSort: PublishRelay<SortType> =  PublishRelay<SortType>()
        let changeFilter: PublishRelay<FilterType> =  PublishRelay<FilterType>()

    }
    struct Output {
        let updateList: PublishRelay<Void> = PublishRelay<Void>()
    }
    
    enum FilterType: String {
        case all = "All"
        case blog = "Blog"
        case cafe = "Cafe"
    }
    enum SortType: String {
        case title      = "Title"
        case dateTime   = "Datetime"
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
        let request = input.nextRequest
            .filter { return $0.query.count > 0 }
        request
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] info in
                guard let self = self else { return }
                self.currentFilterType = info.filterType
                self.beforeQuery = info.query
                if info.isRefresh {
                    self.items = []
                }
            })
            .disposed(by: bag)
        
        rxBindForAll(request: request.filter { $0.filterType == .all })
        rxBindForOnlyBlog(request: request.filter { $0.filterType == .blog })
        rxBindForOnlyCafe(request: request.filter { $0.filterType == .cafe })
        
        input.changeSort
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] type in
                guard let self = self else { return }
                self.currentSortType = type
                self.sortItems()
            })
            .map { _ in Void() }
            .bind(to: output.updateList)
            .disposed(by: bag)
        
        input.changeFilter
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] type in
                guard let self = self else { return }
                self.currentFilterType = type
            })
            .map { [weak self] type -> Input.RequestInfo? in
                guard let self = self else { return nil }
                return Input.RequestInfo(isRefresh: true,
                                         filterType: type,
                                         query: self.beforeQuery)
                
            }
            .filterNil()
            .bind(to: input.nextRequest)
            .disposed(by: bag)
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
                let firstString = first.title.removeHTMLTags()
                let secondString = second.title.removeHTMLTags()
                return firstString < secondString
            }
        case .dateTime:
            self.items.sort { (first, second) -> Bool in
                return first.datetime < second.datetime
            }
        }
    }
}
