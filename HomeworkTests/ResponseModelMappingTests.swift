//
//  ResponseModelMappingTests.swift
//  HomeworkTests
//
//  Created by jeongyuchan on 2020/03/24.
//  Copyright © 2020 gyuchan. All rights reserved.
//

import XCTest
@testable import Homework

class ResponseModelMappingTests: XCTestCase {

    var blogResponse: [String: Any] = [:]
    var cafeResponse: [String: Any] = [:]
    
    override func setUp() {
        guard let blog = LoadJSON<[String: Any]>.get(fileName: "BlogResponse", bundle: Bundle(for: type(of: self))) else {
            return
        }
        guard let cafe = LoadJSON<[String: Any]>.get(fileName: "CafeResponse", bundle: Bundle(for: type(of: self))) else {
            XCTFail("Can't load json file")
            return
        }
        blogResponse = blog
        cafeResponse = cafe
    }
    
    func testBlogMapping() {
        let mapping = SearchBlogResponseModel(JSON: blogResponse)
        guard let result = mapping else {
            XCTFail("Can't blog response initialization")
            return
        }
        
        //first object
        XCTAssertEqual(result.documents?.count, 25)
        XCTAssertEqual(result.documents?.first?.name, "새옹지마 기록소")
        XCTAssertEqual(result.documents?.first?.contents, "오늘은 내가 제일 기다리던 사막투어를 하는 날이다. 두바이를 <b>여행</b>하려고 마음먹은 이유 중에 매일 책이나 미디어로만 보던 사막에 직접 가보자!라는 마음이 제일 컸기에 사막투어를 하는 오늘이 가장 기다려졌고 설렜다. 사막 투어에 가기 전에 두바이에 북한 음식점 옥류관이 있다고 해서 들렸다가 가기로했다...")

        let formatter = DateFormatter().iso8601()
        XCTAssertEqual(result.documents?.first?.datetime, formatter.date(from: "2020-03-19T23:13:00.000+09:00"))
        XCTAssertEqual(result.documents?.first?.thumbnail, URL(string: "https://search4.kakaocdn.net/argon/130x130_85_c/4JXixGgPSzr"))
        XCTAssertEqual(result.documents?.first?.title, "두바이, 아부다비 <b>여행</b> 5")
        XCTAssertEqual(result.documents?.first?.url, URL(string: "http://9uzzang.tistory.com/32"))

        //last object
        XCTAssertEqual(result.documents?.last?.name, "longagomens")
        XCTAssertEqual(result.documents?.last?.contents, "필리핀 중에서도 물가가 저렴하고 여러가지 액티비티를 체험할 수 있어 클락 여행객들로 부터 높은 점수를 얻고 있죠 특히 골프를 저렴하게 칠 수 있어 골프 <b>여행</b>을 떠나는 분들이 있을 정도인데요 이런 여러 가지 매력을 가지고 있는 클락을 200% 즐기기 위해서는 클락에서 무엇을 할 수 있는지 알아야겠죠? 클락의...")

        XCTAssertEqual(result.documents?.last?.datetime, formatter.date(from: "2020-03-16T16:52:00.000+09:00"))
        XCTAssertEqual(result.documents?.last?.thumbnail, URL(string: ""))
        XCTAssertEqual(result.documents?.last?.title, "클락 <b>여행</b> 꿀팁")
        XCTAssertEqual(result.documents?.last?.url, URL(string: "http://going.arlstory.com/66"))
        
        //meta
        XCTAssertEqual(result.meta?.isEnd, false)
        XCTAssertEqual(result.meta?.pageableCount, 765)
        XCTAssertEqual(result.meta?.totalCount, 34839126)

    }

    func testCafeMapping() {
        let mapping = SearchCafeResponseModel(JSON: cafeResponse)
        guard let result = mapping else {
            XCTFail("Can't cafe response initialization")
            return
        }
        
        //first object
        XCTAssertEqual(result.documents?.count, 25)
        XCTAssertEqual(result.documents?.first?.name, "TRUSPACERKOREA")
        XCTAssertEqual(result.documents?.first?.contents, "소방관 안전진입 우수제품 <b>DH</b>-SE창 5가지 필수 조건 -건축설계사무소 설계자료/시험성적서/감리문의 소방관 안전진입 우수제품 <b>DH</b>-SE창 5가지 필수 조건 ▶ 유튜브...")

        let formatter = DateFormatter().iso8601()
        XCTAssertEqual(result.documents?.first?.datetime, formatter.date(from: "2020-03-18T09:06:18.000+09:00"))
        XCTAssertEqual(result.documents?.first?.thumbnail, URL(string: "https://search1.kakaocdn.net/thumb/P100x100/?fname=https%3A%2F%2Fsearch1.kakaocdn.net%2Fargon%2F130x130_85_c%2FLXHnWFT36Sb"))
        XCTAssertEqual(result.documents?.first?.title, "소방관 안전진입 우수제품 <b>DH</b>-SE창 5가지 필수 조건...")
        XCTAssertEqual(result.documents?.first?.url, URL(string: "http://cafe.daum.net/truspacerkorea/jeFr/17"))

        //last object
        XCTAssertEqual(result.documents?.last?.name, "탄성포장재 전문 시공 업체 DH인프라 010-7594-6550")
        XCTAssertEqual(result.documents?.last?.contents, "매트포장 부산 동구 좌천4동어린이집 어린이놀이터바닥재 친환경고무매트포장 50mm <b>DH</b>인프라 #좌천4동어린이집 #어린이놀이터친환경탄성고무매트포장 #헬스장바닥재...")

        XCTAssertEqual(result.documents?.last?.datetime, formatter.date(from: "2020-03-02T06:59:58.000+09:00"))
        XCTAssertEqual(result.documents?.last?.thumbnail, URL(string: "https://search1.kakaocdn.net/thumb/P100x100/?fname=https%3A%2F%2Fsearch3.kakaocdn.net%2Fargon%2F130x130_85_c%2F2fplij8NXHr"))
        XCTAssertEqual(result.documents?.last?.title, "어린이놀이터바닥재 친환경고무매트포장 50mm <b>DH</b>인프라")
        XCTAssertEqual(result.documents?.last?.url, URL(string: "http://cafe.daum.net/DHART7/gT7A/45"))
        
        //meta
        XCTAssertEqual(result.meta?.isEnd, false)
        XCTAssertEqual(result.meta?.pageableCount, 975)
        XCTAssertEqual(result.meta?.totalCount, 166607)
    }
}
