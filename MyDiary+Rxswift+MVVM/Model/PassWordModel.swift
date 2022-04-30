//
//  PassWordModel.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/04/30.
//

import Foundation
import RealmSwift

class Password : Object {
    @objc dynamic var password: String = ""

    convenience init(password: String) {
        self.init()
        self.password = password
    }
}
