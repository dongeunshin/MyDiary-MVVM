//
//  DiaryModel.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/02/08.
//

// TODO: - foundation 삭제
import Foundation
import RealmSwift
import UIKit

class Diary : Object {
    @objc dynamic var id: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var weather: String = ""
    @objc dynamic var isFav: Bool = false
    @objc dynamic var isLocked: Bool = false
//    @objc dynamic var img: Data = Data()
    // 생성자
    convenience init(date: String, title:String, content:String, weather:String, isFav:Bool, isLocked: Bool) {
        self.init()
        self.date = date
        self.title = title
        self.content = content
        self.weather = weather
        self.isLocked = isLocked
//        self.img = img
    }
}
