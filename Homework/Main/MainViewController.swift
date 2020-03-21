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
    
    override init(navigationBarConfig: TBNavigationBar.Config) {
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
        view.backgroundColor = .white
    }
}
