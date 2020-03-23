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
    
    let stackView: UIStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    let filterButton: UIButton = UIButton()
    
    let sortButton: UIButton = UIButton()
    
    init(filter: MainViewModel.FilterType, sort: MainViewModel.SortType) {
        super.init(frame: .zero)
        
        let separatorView: UIView = UIView().then {
            $0.backgroundColor = UIColor.separatorColor()
        }
        
        let bottomBorderLine: UIView = UIView().then {
            $0.backgroundColor = UIColor.separatorColor()
        }
        
        let topBorderLine: UIView = UIView().then {
            $0.backgroundColor = UIColor.separatorColor()
        }
        
        filterButton.setTitle(filter.rawValue, for: .normal)
        filterButton.setTitleColor(.blue, for: .normal)
        sortButton.setTitle(sort.rawValue, for: .normal)
        sortButton.setTitleColor(.blue, for: .normal)

        addSubview(stackView)
        addSubview(topBorderLine)
        addSubview(bottomBorderLine)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        topBorderLine.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(1)
        }
        bottomBorderLine.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        stackView.addArrangedSubview(filterButton)
        filterButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        stackView.addArrangedSubview(sortButton)
        sortButton.snp.makeConstraints { make in
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
