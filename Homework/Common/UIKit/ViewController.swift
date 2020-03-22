//
//  ViewController.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/21.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class TBNavigationBar: UIView {
    enum Config {
        case title(_ with: String, _ isVisibleBackButton: Bool, _ isVisibleRightButton: Bool)
        case view(_ with: UIView, _ isVisibleBackButton: Bool)
    }
    
    struct Frame {
        static let height: CGFloat = 44
        static let buttonItemSize: CGFloat = 44
    }
    
    let stackView: UIStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
    }
    
    lazy var leftButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setImage(#imageLiteral(resourceName: "back.pdf"), for: .normal)
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        return button
    }()
    
    lazy var customView: UIView? = {
        switch config {
        case .view(let searchBar, _):
            return searchBar
        default:
            return nil
        }
    }()
    
    let titleLabel: UILabel = UILabel().then {
        $0.textAlignment = .center
    }
    
    private let config: Config
    
    init(config: Config) {
        self.config = config
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        
        
        switch config {
        case .title(let string, let visibleLeft, let visibleRight):
            let leftStackView: UIStackView = UIStackView().then {
                $0.axis = .horizontal
                $0.spacing = 4
            }
            stackView.addArrangedSubview(leftStackView)
            leftStackView.snp.makeConstraints { make in
                make.width.equalTo(Frame.buttonItemSize)
            }
            
            titleLabel.text = string
            titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
            stackView.addArrangedSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.height.equalTo(Frame.buttonItemSize)
            }
            
            let rightStackView: UIStackView = UIStackView().then {
                $0.axis = .horizontal
                $0.spacing = 4
            }
            stackView.addArrangedSubview(rightStackView)
            rightStackView.snp.makeConstraints { make in
                make.width.equalTo(Frame.buttonItemSize)
            }
            
            if visibleLeft {
                leftStackView.addArrangedSubview(leftButton)
                leftButton.snp.makeConstraints { make in
                    make.width.height.equalTo(Frame.buttonItemSize)
                }
            }
            if visibleRight {
                rightStackView.addArrangedSubview(rightButton)
                rightButton.snp.makeConstraints { make in
                    make.width.height.equalTo(Frame.buttonItemSize)
                }
            }
        case .view(let view, let visibleLeft):
            view.setContentHuggingPriority(.defaultLow, for: .horizontal)
            stackView.addArrangedSubview(view)
            if visibleLeft {
                let leftStackView: UIStackView = UIStackView().then {
                    $0.axis = .horizontal
                    $0.spacing = 4
                }
                stackView.addArrangedSubview(leftStackView)
                leftStackView.addArrangedSubview(leftButton)
                leftButton.snp.makeConstraints { make in
                    make.width.height.equalTo(Frame.buttonItemSize)
                }
                leftStackView.snp.makeConstraints { make in
                    make.width.equalTo(Frame.buttonItemSize)
                }
            }
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Frame.height)
        }
    }
}

class ViewController: UIViewController {
    let customNavigationBar: TBNavigationBar
    
    init(navigationBarConfig: TBNavigationBar.Config) {
        customNavigationBar = TBNavigationBar(config: navigationBarConfig)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            if UIDevice.current.hasNotch {
                make.height.equalTo(TBNavigationBar.Frame.height+safeAreaTopHeight)
            } else {
                make.height.equalTo(TBNavigationBar.Frame.height+UIApplication.shared.statusBarFrame.height)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController {
    var safeAreaTopHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
}

extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
    }
}
