//
//  WeatherModel.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/02/11.
//

import Foundation

struct WeatherModel: Codable{
    let weather:[weather]
}

struct weather: Codable{
    let id: Int
    let main: String
    let description: String
}
