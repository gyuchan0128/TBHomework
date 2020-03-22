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
    
    private var currentPageOfBlog: Int = 1
    private var currentPageOfCafe: Int = 1
    private var isEndPageOfBlog: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    private var isEndPageOfCafe: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private(set) var currentFilterType: FilterType = .all
    private(set) var currentSortType: SortType = .title
    
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
            })
            .disposed(by: bag)
        
        let baseRequest = input.request
            .do(onNext: { [weak self] info in
                guard let self = self else { return }
                if info.isRefresh {
                    self.items = []
                    self.currentPageOfBlog = 1
                    self.currentPageOfCafe = 1
                    self.isEndPageOfBlog.accept(false)
                    self.isEndPageOfCafe.accept(false)
                }
            })
        rxBindForAll(request: baseRequest)
        rxBindForOnlyBlog(request: baseRequest.filter { $0.filterType == .blog })
        rxBindForOnlyCafe(request: baseRequest.filter { $0.filterType == .cafe })
    }
    
    private func rxBindForAll(request: Observable<Input.RequestInfo>) {
        let requestAll = request
            .filter { $0.filterType == .all }
            .flatMap { [weak self] info -> Single<(SearchBlogResponseModel?, SearchCafeResponseModel?)> in
                guard let self = self else { return .never() }
                
                let requestBlog: Single<SearchBlogResponseModel?>
                if self.isEndPageOfBlog.value {
                    requestBlog = .just(nil)
                } else {
                    requestBlog = Networker()
                        .request(api: SearchBlogAPI.search(query: info.query,
                                                           page: self.currentPageOfBlog+1,
                                                           size: Const.pagingSize))
                }
                
                let requestCafe: Single<SearchCafeResponseModel?>
                if self.isEndPageOfCafe.value {
                    requestCafe = .just(nil)
                } else {
                    requestCafe = Networker()
                        .request(api: SearchCafeAPI.search(query: info.query,
                                                           page: self.currentPageOfCafe+1,
                                                           size: Const.pagingSize))
                }
                return Single.zip(requestBlog, requestCafe)
            }
        requestAll.asObservable()
            .map { $0.0?.meta?.isEnd }
            .filterNil()
            .bind(to: isEndPageOfBlog)
            .disposed(by: bag)
        requestAll.asObservable()
            .map { $0.1?.meta?.isEnd }
            .filterNil()
            .bind(to: isEndPageOfCafe)
            .disposed(by: bag)
        requestAll
            .do(onNext: { [weak self] (blog, cafe) in
                guard let self = self else { return }
                if let blogList = blog?.documents {
                    self.items.append(contentsOf: blogList)
                }
                if let cafeList = cafe?.documents {
                    self.items.append(contentsOf: cafeList)
                }
                //현재 정렬방법에 맞춰 다시 정렬을 진행한다.
                if blog != nil, cafe != nil {
                    self.sortItems()
                }
            })
            .map { _ in Void() }
            .bind(to: output.updateList)
            .disposed(by: bag)
    }
    private func rxBindForOnlyBlog(request: Observable<Input.RequestInfo>) {
        let requestOnlyBlog = request
            .filter({ [weak self] _ -> Bool in
                guard let self = self else { return false }
                return !self.isEndPageOfCafe.value
            })
            .flatMap { [weak self] info -> Single<SearchBlogResponseModel?> in
                guard let self = self else { return .never() }
                let request: Single<SearchBlogResponseModel?> = Networker()
                    .request(api: SearchBlogAPI.search(query: info.query,
                                                       page: self.currentPageOfBlog+1,
                                                       size: Const.pagingSize))
                return request
            }
        requestOnlyBlog
            .do(onNext: { [weak self] responseModel in
                guard let self = self else { return }
                guard let list = responseModel?.documents else { return }
                self.currentPageOfBlog += 1
                self.items.append(contentsOf: list)
                //현재 정렬방법에 맞춰 다시 정렬을 진행한다.
                self.sortItems()
            })
            .map { _ in Void() }
            .bind(to: output.updateList)
            .disposed(by: bag)
        requestOnlyBlog.asObservable()
            .map { $0?.meta?.isEnd }
            .filterNil()
            .bind(to: isEndPageOfBlog)
            .disposed(by: bag)
    }
    private func rxBindForOnlyCafe(request: Observable<Input.RequestInfo>) {
        let requestOnlyCafe = request
            .filter({ [weak self] _ -> Bool in
                guard let self = self else { return false }
                return !self.isEndPageOfCafe.value
            })
            .flatMap { [weak self] info -> Single<SearchCafeResponseModel?> in
                guard let self = self else { return .never() }
                let request: Single<SearchCafeResponseModel?> = Networker()
                    .request(api: SearchCafeAPI.search(query: info.query,
                                                       page: self.currentPageOfCafe+1,
                                                       size: Const.pagingSize))
                return request
            }
        requestOnlyCafe
            .do(onNext: { [weak self] responseModel in
                guard let self = self else { return }
                guard let list = responseModel?.documents else { return }
                self.currentPageOfCafe += 1
                self.items.append(contentsOf: list)
                //현재 정렬방법에 맞춰 다시 정렬을 진행한다.
                self.sortItems()
            })
            .map { _ in Void() }
            .bind(to: output.updateList)
            .disposed(by: bag)
        requestOnlyCafe.asObservable()
            .map { $0?.meta?.isEnd }
            .filterNil()
            .bind(to: isEndPageOfCafe)
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
