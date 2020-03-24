//
//  MainViewController.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/21.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import SwiftyUserDefaults

final class MainViewController: ViewController {
    
    let viewModel: MainViewModel = MainViewModel()
    
    let sectionHeaderView: TableViewHeader
    
    let tableView: UITableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .white
        $0.register(UINib(nibName: TableViewCell.Const.cellIdentifier,
                          bundle: nil),
                    forCellReuseIdentifier: TableViewCell.Const.cellIdentifier)
        $0.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: $0.frame.size.width, height: 0.1))
        $0.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: $0.frame.size.width, height: 0.1))
    }
    
    let recentView: RecentView = RecentView()
    
    override init(navigationBarConfig: TBNavigationBar.Config) {
        sectionHeaderView = TableViewHeader(filter: viewModel.currentFilterType,
                                            sort: viewModel.currentSortType)
        super.init(navigationBarConfig: navigationBarConfig)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        rxBind()
    }
        
    private func setUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(recentView)
        recentView.delegate = self
        recentView.isHidden = true
        recentView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(SearchBarView.Frame.leftInset)
            make.top.equalTo(customNavigationBar.snp.bottom).offset(1)
            make.trailing.equalToSuperview().inset(80)
            make.height.equalTo(220)
        }
    }
    private func rxBind() {
        rx.viewWillAppear.subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadData()
            })
            .disposed(by: viewModel.bag)
        viewModel.output.updateList.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadData()
            })
            .disposed(by: viewModel.bag)
        
        if let view = customNavigationBar.customView as? SearchBarView {
            view.button.rx.tap.withLatestFrom(view.searchBar.rx.text)
                .filterNil()
                .map({ [weak self] query -> MainViewModel.Input.RequestInfo? in
                    guard let self = self else { return nil }
                    return MainViewModel.Input.RequestInfo(isRefresh: true,
                                                           filterType: self.viewModel.currentFilterType,
                                                           query: query)
                })
                .filterNil()
                .observeOn(MainScheduler.instance)
                .do(onNext: { [weak self] info in
                    guard let self = self else { return }
                    self.addRecentHistory(query: info.query)
                    self.recentView.isHidden = true
                    self.view.endEditing(true)
                    self.tableView.setContentOffset(.zero, animated: false)
                })
                .bind(to: viewModel.input.nextRequest)
                .disposed(by: viewModel.bag)
            view.searchBar.delegate = self
            
            view.searchBar.rx.controlEvent(.editingDidBegin).asObservable()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self]  in
                    guard let self = self else { return }
                    if Defaults[\.recent].count > 0 {
                        self.recentView.isHidden = false
                        self.recentView.tableView.reloadData()
                    } else {
                        self.recentView.isHidden = true
                    }
                })
                .disposed(by: viewModel.bag)
        }
        
        // HeaderView
        sectionHeaderView.sortButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                actionSheet.addAction(
                    UIAlertAction(title: MainViewModel.SortType.title.rawValue,
                                  style: .default, handler: { result in
                                    let toType: MainViewModel.SortType = .title
                                    self.sectionHeaderView.sortDidChange(type: toType)
                                    self.viewModel.input.changeSort.accept(toType)
                }))
                actionSheet.addAction(
                    UIAlertAction(title: MainViewModel.SortType.dateTime.rawValue,
                                  style: .default,
                                  handler: { result in
                                    let toType: MainViewModel.SortType = .dateTime
                                    self.sectionHeaderView.sortDidChange(type: toType)
                                    self.viewModel.input.changeSort.accept(toType)

                }))
                actionSheet.addAction(UIAlertAction(title: "취소",
                                                    style: .cancel,
                                                    handler: nil))
                self.present(actionSheet,
                             animated: true,
                             completion: nil)
            })
            .disposed(by: viewModel.bag)
        sectionHeaderView.filterButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                actionSheet.addAction(
                    UIAlertAction(title: MainViewModel.FilterType.all.rawValue,
                                  style: .default, handler: { result in
                                    let toType: MainViewModel.FilterType = .all
                                    self.sectionHeaderView.filterDidChange(type: toType)
                                    self.viewModel.input.changeFilter.accept(toType)
                }))
                actionSheet.addAction(
                    UIAlertAction(title: MainViewModel.FilterType.blog.rawValue,
                                  style: .default,
                                  handler: { result in
                                    let toType: MainViewModel.FilterType = .blog
                                    self.sectionHeaderView.filterDidChange(type: toType)
                                    self.viewModel.input.changeFilter.accept(toType)

                }))
                actionSheet.addAction(
                    UIAlertAction(title: MainViewModel.FilterType.cafe.rawValue,
                                  style: .default,
                                  handler: { result in
                                    let toType: MainViewModel.FilterType = .cafe
                                    self.sectionHeaderView.filterDidChange(type: toType)
                                    self.viewModel.input.changeFilter.accept(toType)

                }))
                actionSheet.addAction(UIAlertAction(title: "취소",
                                                    style: .cancel,
                                                    handler: nil))
                self.present(actionSheet,
                             animated: true,
                             completion: nil)
            })
            .disposed(by: viewModel.bag)
    }
    
    private func addRecentHistory(query: String) {
        guard query.count > 0 else { return }
        // 같은 query string을 삭제해준다.
        Defaults[\.recent].removeAll { item -> Bool in
            return item == query
        }
        Defaults[\.recent].insert(query, at: 0)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.Const.cellIdentifier) as? TableViewCell else {
            return UITableViewCell()
        }
        guard let item = viewModel.items[safe: indexPath.row] else {
            return cell
        }
        cell.selectionStyle = .none
        cell.bind(pModel: CellPresentableModel(title: item.title,
                                               imageURL: item.thumbnail,
                                               type: item.type,
                                               name: item.name ?? "",
                                               date: item.datetime,
                                               linkURL: item.url))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = .zero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = .zero
        
        if indexPath.row == viewModel.items.count-5 {
            viewModel.input.nextRequest.accept(MainViewModel.Input.RequestInfo(isRefresh: false,
                                                                               filterType: viewModel.currentFilterType,
                                                                               query: viewModel.beforeQuery))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel.items[safe: indexPath.row] else {
            return
        }

        let vc: DetailViewController = DetailViewController(navigationBarConfig: .title(item.type.rawValue,
                                                                                        true,
                                                                                        false),
                                                            viewModel: DetailViewModel(model: item))
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text else { return true }
        addRecentHistory(query: text)
        recentView.isHidden = true
        viewModel.input.nextRequest.accept(MainViewModel.Input.RequestInfo(isRefresh: true,
                                                                           filterType: viewModel.currentFilterType,
                                                                           query: text))
        return true
    }
}

extension MainViewController: RecentViewDelegate {
    func didSelect(title: String) {
        addRecentHistory(query: title)
        if let view = customNavigationBar.customView as? SearchBarView {
            view.searchBar.text = title
            view.searchBar.resignFirstResponder()
        }
        recentView.isHidden = true
        viewModel.input.nextRequest.accept(MainViewModel.Input.RequestInfo(isRefresh: true,
                                                                           filterType: viewModel.currentFilterType,
                                                                           query: title))
    }
}
