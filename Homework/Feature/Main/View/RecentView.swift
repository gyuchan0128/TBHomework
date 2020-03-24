//
//  RecentView.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/24.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Then


protocol RecentViewDelegate: class {
    func didSelect(title: String)
}

final class RecentViewModel {
    var list: [String] {
        return Defaults[\.recent]
    }
}

extension DefaultsKeys {
    var recent: DefaultsKey<[String]> { .init("recent", defaultValue: []) }
}

final class RecentView: UIView {

    let tableView: UITableView = UITableView().then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
        $0.tableFooterView = UIView()
    }
    
    let viewModel: RecentViewModel = RecentViewModel()
    
    weak var delegate: RecentViewDelegate?
    
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension RecentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        guard let item = viewModel.list[safe: indexPath.row] else { return cell }
        cell.textLabel?.text = item
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel.list[safe: indexPath.row] else { return }
        delegate?.didSelect(title: item)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
