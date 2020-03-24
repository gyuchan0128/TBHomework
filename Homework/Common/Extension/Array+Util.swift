//
//  Array+Util.swift
//  Homework
//
//  Created by jeongyuchan on 2020/03/21.
//  Copyright © 2020 gyuchan. All rights reserved.
//

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
    
    mutating func sortDocumentItems(sortType: MainViewModel.SortType) {
        //현재 정렬방법에 맞춰 다시 정렬을 진행한다.
        guard self is [SearchDocumentResponsable] else {
            return
        }
        
        switch sortType {
        case .title:
            self.sort { (first, second) -> Bool in
                guard let firstString = (first as? SearchDocumentResponsable)?.title else {
                    return false
                }
                guard let secondString = (second as? SearchDocumentResponsable)?.title else {
                    return false
                }
                return firstString < secondString
            }
        case .dateTime:
            self.sort { (first, second) -> Bool in
                guard let first = first as? SearchDocumentResponsable else {
                    return false
                }
                guard let second = second as? SearchDocumentResponsable else {
                    return false
                }
                return first.datetime < second.datetime
            }
        }
    }
}
