//
//  DetailView.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/23.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import UIKit
import SnapKit

final class DetailView: UIView {
    
    struct Frame {
        static let imageSize: CGFloat = 100
    }
    struct Const {
        static let titleFont: UIFont = .systemFont(ofSize: 16, weight: .semibold)
        static let contentFont: UIFont = .systemFont(ofSize: 14, weight: .light)
        static let contentWidth = UIScreen.main.bounds.size.width-16*2
    }
    
    private let scrollView: UIScrollView = UIScrollView().then {
        $0.alwaysBounceHorizontal = false
        $0.alwaysBounceVertical = true
    }
    
    let mainStackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    let imageBackgroundView: UIView = UIView().then {
        $0.backgroundColor = .white
    }
    let imageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let nameLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .thin)
        $0.numberOfLines = 0
    }
    
    let titleLabel: UILabel = UILabel().then {
        $0.font = Const.titleFont
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 2
        $0.textAlignment = .right
    }
    
    let contentLabel: UILabel = UILabel().then {
        $0.font = Const.contentFont
        $0.numberOfLines = 0
    }
    
    let datetimeLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10, weight: .regular)
        $0.numberOfLines = 0
        $0.textAlignment = .right
    }
    
    let linkStackView: UIStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    let urlLinkLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: Const.contentWidth-50-8, height: 0)).then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
    }
    
    let linkButton: UIButton = UIButton().then {
        $0.setTitle("이동하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        $0.setTitleColor(.blue, for: .normal)
    }
    
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.width.equalTo(Const.contentWidth)
        }
        
        imageBackgroundView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Frame.imageSize).priority(751)
            make.top.bottom.equalToSuperview()
        }
        mainStackView.addArrangedSubview(imageBackgroundView)
        imageBackgroundView.snp.makeConstraints { make in
            make.height.equalTo(Frame.imageSize).priority(751)
        }
        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(contentLabel)
        mainStackView.addArrangedSubview(datetimeLabel)

        linkStackView.addArrangedSubview(urlLinkLabel)
        urlLinkLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        linkStackView.addArrangedSubview(linkButton)
        linkButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        mainStackView.addArrangedSubview(linkStackView)
    }
}
