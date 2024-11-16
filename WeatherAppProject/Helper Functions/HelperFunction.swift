//
//  HelperFunction.swift
//  WeatherAppProject
//
//  Created by mac on 4/12/24.
//

import Foundation


func searchWeatherIcon(conditionCode: String) -> URL? {
    let baseURLString = "https://openweathermap.org/img/wn/"
    let urlString = "\(baseURLString)\(conditionCode)@2x.png"
    
    if let url = URL(string: urlString) {
        return url
    } else {
        print("Invalid URL")
        return nil
    }
}
 var API_KEY = "47aa69ae74fd9d16e9cab50e6815a59e"

func kelvinToCelsius(kelvin: Double) -> Double {
    let celsius = kelvin - 273.15
    return (celsius * 100).rounded() / 100
}
//// Example usage:
//if let weatherIconURL = searchWeatherIcon(conditionCode: "02n") {
//    print(weatherIconURL)
//} else {
//    print("Failed to generate weather icon URL")
//}
