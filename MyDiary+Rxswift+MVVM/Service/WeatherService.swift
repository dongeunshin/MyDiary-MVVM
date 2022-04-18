//
//  WeatherService.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/02/11.
//

import Foundation

class WeatherService{
    let repository = WeatherRepository()
    var currentWeatherModel = CurrentWeatherModel(description: "")
    
    func fetchWeather(completion: @escaping (CurrentWeatherModel)->()){
        repository.fetchWeather { [weak self] entity in
//            print("service")
//            print(entity.weather.first?.main)
            let model = CurrentWeatherModel(description: entity.weather.first?.description ?? "cantfind")
            self?.currentWeatherModel = model
            completion(model)
        }
    }
}
