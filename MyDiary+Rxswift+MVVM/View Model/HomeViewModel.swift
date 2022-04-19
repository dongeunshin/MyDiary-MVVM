//
//  HomeViewModel.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/02/11.
//

import Foundation
import RxSwift
import RealmSwift
import RxRelay

class HomeViewModel {

    let realm = try! Realm()
    lazy var diary = self.realm.objects(Diary.self)
    lazy var allDiary = BehaviorRelay(value: diary) //BehaviorSubject<Results<Diary>>(value: diary)
    lazy var filteredDiary = diary.filter({$0.isFav == false})
    lazy var filteredDiaryList = BehaviorRelay(value: filteredDiary)
    
    func reload(){
        allDiary.accept(diary)
    }
    func reloadFavList(){
        filteredDiaryList.accept(filteredDiary)
    }
    func delete(index : Int) {
        do {
            try self.realm.write {
                self.realm.delete(self.diary[index])
            }
        } catch {
                print("Error: \(error)")
        }
        reload()
    }
}
