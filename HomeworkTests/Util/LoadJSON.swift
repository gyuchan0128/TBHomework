//
//  LoadJSON.swift
//  HomeworkTests
//
//  Created by jeongyuchan on 2020/03/24.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import Foundation

class LoadJSON<T> {
    static func get(fileName: String, bundle: Bundle) -> T? {
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {
            print("--- file not found : \(fileName).json")
            return nil
        }
        let fileURL = URL(fileURLWithPath: path)
        guard let data = try? Data.init(contentsOf: fileURL) else {
            print("--- can not access the file : \(fileName).json")
            return nil
        }
        do {
            let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            guard let result = object as? T else {
                throw NSError(domain: "can not serialization the file : \(fileName).json", code: -1, userInfo: nil)
            }
            return result
        } catch {
            print("--- can not serialization the file : \(fileName).json")
            return nil
        }
    }
}
