//
//  TableViewHeader.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/23.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class TableViewHeader: UIView {
    
    let filterButton: UIButton = UIButton()
    
    let sortButton: UIButton = UIButton()
    
    init(filter: MainViewModel.FilterType, sort: MainViewModel.SortType) {
        super.init(frame: .zero)
        
        filterButton.setTitle(filter.rawValue, for: .normal)
        filterButton.setTitleColor(.blue, for: .normal)
        sortButton.setTitle(sort.rawValue, for: .normal)
        sortButton.setTitleColor(.blue, for: .normal)

        addSubview(filterButton)
        addSubview(sortButton)
        
        filterButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(sortButton.snp.leading)
        }
        
        sortButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(80)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func filterDidChange(type: MainViewModel.FilterType) {
        filterButton.setTitle(type.rawValue, for: .normal)
    }
    
    func sortDidChange(type: MainViewModel.SortType) {
        sortButton.setTitle(type.rawValue, for: .normal)
    }
}
