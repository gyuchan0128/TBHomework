//
//  SearchBarView.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/21.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class SearchTextField: UITextField {
    var inset: CGFloat = 12
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: inset,
                      y: 0,
                      width: bounds.size.width-inset*2,
                      height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

final class SearchBarView: UIView {
    let searchBar: UITextField = SearchTextField().then {
        $0.backgroundColor = UIColor(white: 0.9, alpha: 1)
        $0.autocorrectionType = .no
    }
    let button: UIButton = UIButton(type: .custom).then {
        $0.setTitle("검색", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        $0.backgroundColor = .clear
    }
    let stackView: UIStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    struct Frame {
        static let buttonWidthHeight: CGFloat = 44
        static let leftInset: CGFloat = 12
        static let rightInset: CGFloat = -8
    }
    
    init() {
        super.init(frame: .zero)
        searchBar.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(searchBar)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.addArrangedSubview(button)
        button.snp.makeConstraints { make in
            make.width.height.equalTo(Frame.buttonWidthHeight)
        }

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(Frame.leftInset)
            make.trailing.equalTo(Frame.rightInset)
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
