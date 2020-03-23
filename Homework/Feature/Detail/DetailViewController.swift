//
//  DetailViewController.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/23.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class DetailViewController: ViewController {
    private let contentView: DetailView
    private let viewModel: DetailViewModel
    
    init(navigationBarConfig: TBNavigationBar.Config, viewModel: DetailViewModel) {
        self.viewModel = viewModel
        self.contentView = DetailView()
        super.init(navigationBarConfig: navigationBarConfig)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(self.customNavigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        if let thumbnailImageURL = viewModel.imageURL {
            contentView.imageView.af_setImage(withURL: thumbnailImageURL)
        } else {
            contentView.imageBackgroundView.isHidden = true
        }
        
        if let name = viewModel.name, name.count > 0 {
            contentView.nameLabel.text = name
        } else {
            contentView.nameLabel.isHidden = true
        }
        
        if let title = viewModel.title {
            contentView.titleLabel.text = title.htmlDecoded
        } else {
            contentView.titleLabel.isHidden = true
        }
        
        if let contents = viewModel.contents {
            contentView.contentLabel.text = contents.htmlDecoded
        } else {
            contentView.contentLabel.isHidden = true
        }
        
        if let dateTimeString = viewModel.dateTime {
            contentView.datetimeLabel.text = dateTimeString
        } else {
            contentView.datetimeLabel.isHidden = true
        }
        
        if let urlLink = viewModel.link {
            contentView.urlLinkLabel.text = urlLink.absoluteString
        } else {
            contentView.linkStackView.isHidden = true
        }
    }
}
