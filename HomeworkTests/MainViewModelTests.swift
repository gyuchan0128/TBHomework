//
//  MainViewModelTests.swift
//  HomeworkTests
//
//  Created by jeongyuchan on 2020/03/24.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import XCTest
@testable import Homework

class MainViewModelTests: XCTestCase {

    var blogResponse: SearchBlogResponseModel!
    var cafeResponse: SearchCafeResponseModel!
    
    override func setUp() {
        guard let blog = LoadJSON<[String: Any]>.get(fileName: "BlogResponse", bundle: Bundle(for: type(of: self))) else {
            return
        }
        guard let cafe = LoadJSON<[String: Any]>.get(fileName: "CafeResponse", bundle: Bundle(for: type(of: self))) else {
            XCTFail("Can't load json file")
            return
        }
        guard let blogModel = SearchBlogResponseModel(JSON: blog) else {
            XCTFail("Can't blog response initialization")
            return
        }
        guard let cafeModel = SearchCafeResponseModel(JSON: cafe) else {
            XCTFail("Can't cafe response initialization")
            return
        }
        blogResponse = blogModel
        cafeResponse = cafeModel
    }

    func testSorting() {
        guard var documents = blogResponse.documents else {
            XCTFail("Empty list")
            return
        }
        
        documents.sortDocumentItems(sortType: .title)
        XCTAssertEqual(documents.first?.name, "소소일기")
        XCTAssertEqual(documents.last?.name, "열정과 냉정")

        documents.sortDocumentItems(sortType: .dateTime)
        XCTAssertEqual(documents.first?.name, "뉴엣 스토리")
        XCTAssertEqual(documents.last?.name, "진심")
    }
}
