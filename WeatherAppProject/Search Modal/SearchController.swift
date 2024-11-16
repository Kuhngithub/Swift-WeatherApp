//
//  SearchController.swift
//  WeatherAppProject
//
//  Created by mac on 4/12/24.
//

import UIKit
import Alamofire
class SearchController: UIViewController, UISearchBarDelegate {

    var cities: [String] = ["ihgfd","hgfghjkjh"] // Array to hold autocomplete city names
    let apiKey = API_KEY
    var selectedCityIndexPath: IndexPath?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchBar.delegate = self
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let selectedIndexPath = selectedCityIndexPath else {
                    dismiss(animated: true, completion: nil)
                    return
                }

                let selectedCity = cities[selectedIndexPath.row]
                if let latitude = latitudeForSelectedCity(selectedCity), let longitude = longitudeForSelectedCity(selectedCity) {
                    dismiss(animated: true) {
                        // Call a completion handler or delegate method to pass latitude and longitude back to the presenting view controller
                        // Example: self.delegate?.didSelectCity(latitude: latitude, longitude: longitude)
                    }
                }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
    }
    @IBOutlet weak var searchTableView: UITableView!
    
    func autocompleteCity(query: String) {
            let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(query)&limit=5&appid=\(apiKey)"

            AF.request(urlString).responseJSON { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let value):
                    if let jsonArray = value as? [[String: Any]] {
                        self.cities = jsonArray.compactMap { $0["name"] as? String }
                        self.searchTableView.reloadData() // Reload table view with autocomplete results
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }


}

extension SearchController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
               cell.cityNameInSearchLabel?.text = cities[indexPath.row]
        if let selectedIndexPath = selectedCityIndexPath, selectedIndexPath == indexPath {
                    cell.isSelected = true
                    cell.accessoryType = .checkmark
                } else {
                    cell.isSelected = false
                    cell.accessoryType = .none
                }
               return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           selectedCityIndexPath = indexPath
           searchTableView.reloadData() // Update table view to show selection
       }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder() // Dismiss keyboard on search button click
       }
    
    func latitudeForSelectedCity(_ city: String) -> Double? {
           // Implement a function to get latitude for the selected city based on the data returned by the autocomplete API
           return 0.0 // Placeholder value
       }

       func longitudeForSelectedCity(_ city: String) -> Double? {
           // Implement a function to get longitude for the selected city based on the data returned by the autocomplete API
           return 0.0 // Placeholder value
       }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          autocompleteCity(query: searchText)
      }
}
