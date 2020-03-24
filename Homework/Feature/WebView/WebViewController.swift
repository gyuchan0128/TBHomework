//
//  WebViewController.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/23.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import SwiftyUserDefaults

final class WebViewController: ViewController {

    let webView: WKWebView = WKWebView()
    
    let url: URL
    
    init(navigationBarConfig: TBNavigationBar.Config, url: URL) {
        self.url = url
        super.init(navigationBarConfig: navigationBarConfig)
        webView.load(URLRequest(url: url))
        Defaults[\.viewed].append(url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(self.customNavigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension DefaultsKeys {
    var viewed: DefaultsKey<[URL]> { .init("viewed", defaultValue: []) }
}
