//
//  ViewController.swift
//  WeatherAppProject
//
//  Created by mac on 4/12/24.
//

import UIKit
import Kingfisher
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var addCityButton: UIBarButtonItem! //when this is clicked, open a modally presented view controller that is controlled by SearchController
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listOfCitiesTableView: UITableView!
    
    var cityWeatherData : [FullWeatherData] = []
    var fullWeatherData : WeatherResponse?
    
    
    @IBAction func addCityButtonPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchController") as? SearchController {
                    searchVC.modalPresentationStyle = .popover
                    present(searchVC, animated: true, completion: nil)
//                    navigationController?.pushViewController(searchVC, animated: true)
                }
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        listOfCitiesTableView.delegate = self
        listOfCitiesTableView.dataSource = self
        listOfCitiesTableView.register(UINib(nibName: "CitiesTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
        
        fetchWeatherData(for: "LONDON")
        
        
    }

    func fetchWeatherData(for city: String) {
            let apiKey = API_KEY // Replace with your actual API key from OpenWeatherMap
            let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=47aa69ae74fd9d16e9cab50e6815a59e"
        
//        "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
            
        AF.request(urlString).responseDecodable(of: WeatherResponse.self) { response in
                switch response.result {
                case .success(let weatherResponse):
                    self.handleWeatherResponse(weatherResponse)
                case .failure(let error):
                    print("Error fetching weather data: \(error.localizedDescription)")
                }
            }
        }
    
    func handleWeatherResponse(_ weatherResponse: WeatherResponse) {
        // Access the weather data from the response and update UI or data models
        let weatherData = weatherResponse.main
        print(weatherResponse.weather[0].icon)
        print(weatherData) // Print the weather data for debugging
        
        // Example: Update your data model or UI with the weather data
        self.cityWeatherData.append(weatherData)
        self.fullWeatherData = weatherResponse
        self.listOfCitiesTableView.reloadData()
    }

    
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityWeatherData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! CitiesTableViewCell
        
        let weatherData = cityWeatherData[indexPath.row]
        
        cell.cityNameLabel.text = fullWeatherData?.name
        
        let temperature = fullWeatherData?.main.temp ?? 0.0
            //convert temp in kelvin to celsius
        
        let tempToCelsius = kelvinToCelsius(kelvin: temperature)
        cell.temperatureLabel.text = "\(tempToCelsius ?? 0.0) °C"
        
        if let weatherIcon = fullWeatherData?.weather.first?.icon {
            let iconURLString = "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png"
            if let iconURL = URL(string: iconURLString) {
                cell.citiesWeatherImageView.kf.setImage(with: iconURL)
            }
        }
        
        return cell
    }

    
    
}
