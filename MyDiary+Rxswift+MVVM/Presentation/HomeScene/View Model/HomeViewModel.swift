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
    lazy var diary = self.realm.objects(Diary.self).filter({!$0.title.isEmpty})
    lazy var filteredDiary = diary.filter({$0.isFav == true})
    lazy var allDiary = PublishSubject<LazyFilterSequence<Results<Diary>>>() //BehaviorRelay(value: diary)
    lazy var filteredDiaryList = BehaviorRelay(value: filteredDiary)
    let nsPredicateFormat = "title == %@"
    
    var diaryList : LazyFilterSequence<Results<Diary>>?
    
    func reload(){
//        allDiary.accept(diary)
        allDiary.onNext(diary)
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
    func searchMemo(queryValue: String) {        
        let searchedDiary = diary.filter({$0.title.contains(queryValue)})
//        allDiary.accept(searchedDiary)
        allDiary.onNext(searchedDiary)
    }
    
    func fetchData(title:String,condent:String) -> Results<Diary> {
        let nsPredicateFormat2 = "title == %@ and content == %@"
        let predicate = NSPredicate(format: nsPredicateFormat2, title, condent)
        let searchedDiary = self.realm.objects(Diary.self).filter(predicate)
        return searchedDiary
    }
    
    func editMemo(t:String?,c:String?,title:String,condent:String,isLocked: Bool, isFav: Bool){
        do {
            try realm.write {
                guard let t = t, let c = c else { return }
                let d = fetchData(title: t, condent: c)
                let currDiary = d.first!
                currDiary.title = title
                currDiary.content = condent
                currDiary.isLocked = isLocked
                currDiary.isFav = isFav
            }
        } catch {
                print("Error")
        }
    }
}
