//
//  TableViewCell.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/22.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import UIKit

struct CellPresentableModel {
    enum FilterType: String {
        case blog = "B"
        case cafe = "C"
    }
    let title: String       // title
    let imageURL: URL?
    let type: FilterType
    let name: String        // blog name or cafe name
    let date: String        // 오늘, 어제, 그외(YYYY년 MM월 DD일)
    
    init(title: String, imageURL: URL?, type: ListRequestType, name: String, date: Date) {
        self.title = title
        self.imageURL = imageURL
        self.name = name
        self.type = type.toPresentableFilterType()
        
        if Calendar.current.isDateInToday(date) {
            self.date = "오늘"
        } else if Calendar.current.isDateInYesterday(date) {
            self.date = "어제"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            self.date = dateFormatter.string(from: date)
        }
    }
}

class TableViewCell: UITableViewCell {
    struct Const {
        static let cellIdentifier: String = "TableViewCell"
    }
    
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var leftStackView: UIStackView!
    @IBOutlet weak var leftTopStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        badgeLabel.textAlignment = .center
        badgeLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        nameLabel.font = .systemFont(ofSize: 13, weight: .light)
        titleLabel.font = .systemFont(ofSize: 12, weight: .light)
        titleLabel.numberOfLines = 2
        dateLabel.font = .systemFont(ofSize: 10, weight: .thin)

        mainStackView.spacing = 16
        leftStackView.spacing = 8
        leftTopStackView.spacing = 4

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(pModel: CellPresentableModel) {
        self.badgeLabel.text = pModel.type.rawValue
        switch pModel.type {
        case .blog:
            self.badgeLabel.textColor = .white
            self.badgeLabel.backgroundColor = .blue
        case .cafe:
            self.badgeLabel.backgroundColor = .green
        }
        self.nameLabel.text = pModel.name
        self.titleLabel.text = pModel.title
        self.dateLabel.text = pModel.date
    }
    
}
