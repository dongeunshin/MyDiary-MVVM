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

@objcMembers class Diary : Object {
    dynamic var id: String = ""
    dynamic var date: String = ""
    dynamic var title: String = ""
    dynamic var content: String = ""
    dynamic var weather: String = ""
    dynamic var isFav: Bool = false
    dynamic var isLocked: Bool = false
    
    convenience init(date: String, title:String, content:String, weather:String, isFav:Bool, isLocked: Bool) {
        self.init()
        self.date = date
        self.title = title
        self.content = content
        self.weather = weather
        self.isFav = isFav
        self.isLocked = isLocked
    }
}
