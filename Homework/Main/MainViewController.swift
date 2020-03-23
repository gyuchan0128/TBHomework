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

final class MainViewController: ViewController {
    
    let viewModel: MainViewModel = MainViewModel()
    
    let sectionHeaderView: TableViewHeader
    
    let tableView: UITableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .white
        $0.register(UINib(nibName: TableViewCell.Const.cellIdentifier,
                          bundle: nil),
                    forCellReuseIdentifier: TableViewCell.Const.cellIdentifier)
        $0.tableFooterView = UIView(frame: .zero)
        $0.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: $0.frame.size.width, height: 0.1))
    }
    
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
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    private func rxBind() {
        viewModel.output.updateList.asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
                self.tableView.reloadData()
            })
            .disposed(by: viewModel.bag)
        
        if let view = customNavigationBar.customView as? SearchBarView {
            view.button.rx.tap
                .map { view.searchBar.text }
                .filterNil()
                .map({ [weak self] query -> MainViewModel.Input.RequestInfo? in
                    guard let self = self else { return nil }
                    return MainViewModel.Input.RequestInfo(isRefresh: true,
                                                           filterType: self.viewModel.currentFilterType,
                                                           query: query)
                })
                .filterNil()
                .do(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.view.endEditing(true)
                })
                .bind(to: viewModel.input.request)
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
        
        cell.bind(pModel: CellPresentableModel(title: item.title,
                                               imageURL: item.thumbnail,
                                               type: item.type,
                                               name: item.name ?? "",
                                               date: item.datetime))
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
        if indexPath.row > viewModel.items.count-5 {
            viewModel.input.request.accept(MainViewModel.Input.RequestInfo(isRefresh: false,
                                                                           filterType: viewModel.currentFilterType,
                                                                           query: viewModel.beforeQuery))
        }
    }

}
