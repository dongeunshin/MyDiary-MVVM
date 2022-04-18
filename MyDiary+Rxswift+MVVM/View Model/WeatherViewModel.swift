//
//  WeatherViewModel.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/02/11.
//

import Foundation
import RxRelay
import SwiftUI
import RealmSwift

class WeatherViewModel{
    var realm = try! Realm()
    let service = WeatherService()
    let todayWeather = BehaviorRelay(value: "Loading...")
    
    func reload() {
        service.fetchWeather { data in
//            print(data.description)
            self.todayWeather.accept(data.description)
        }
    }
    
    func save(diary: Diary){
        do{
            
            try realm.write{ realm.add(diary) }
        } catch {
            print("Error: \(error)")
        }
    }
}
