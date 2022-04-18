//
//  WatherAPI.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/02/11.
//

import Foundation
import Alamofire
import SwiftUI

class WeatherRepository {
    func fetchWeather(completion: @escaping (WeatherModel) -> ()){
        let apiKey = "2b38a93160926dfac229d1faa29bdff5"
        let urlString = "http://api.openweathermap.org/data/2.5/weather?id=524901&appid=\(apiKey)"
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do{
                    let decodedData = try decoder.decode(WeatherModel.self, from: data)
//                    print("repository")
//                    print(decodedData)
                    return completion(decodedData)
                }catch{
                    print("ERROR: decode fail")
                    return
                }
            case .failure(let error):
                print("ERROR: \(error)")
                return
            }
        }
    }
}
