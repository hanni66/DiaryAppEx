//
//  Diary.swift
//  DiaryApp
//
//  Created by 김하은 on 2023/09/23.
//

import Foundation

struct Diary {
    var uuidString: String  // 객체에 고유값을 부여하기 위한 uuid 프로퍼티
    var title: String
    var contents: String
    var date: Date
    var isStar: Bool
}
