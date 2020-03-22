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
    struct Const {
        static let cellIdentifier: String = "cell"
    }
    let viewModel: MainViewModel = MainViewModel()
    
    let tableView: UITableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(UITableViewCell.self, forCellReuseIdentifier: Const.cellIdentifier)
    }
    
    override init(navigationBarConfig: TBNavigationBar.Config) {
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
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellIdentifier) else {
            return UITableViewCell()
        }
        guard let item = viewModel.items[safe: indexPath.row] else {
            return cell
        }
        
        cell.textLabel?.text = item.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.detailTextLabel?.text = dateFormatter.string(from: item.datetime)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > viewModel.items.count-5 {
            viewModel.input.request.accept(MainViewModel.Input.RequestInfo(isRefresh: false,
                                                                           filterType: viewModel.currentFilterType,
                                                                           query: viewModel.beforeQuery))
        }
    }

}
