//
//  APICaller.swift
//  Covid Tracker
//
//  Created by Alley Pereira on 10/06/21.
//

import Foundation

class APICaller {

    static let shared = APICaller()

    private init() {}

    private struct Constants {
        static let allStatesURL = URL(string: "https://api.covidtracking.com/v2/states.json")
    }

    enum DataScope {
        case national
        case state(State)
    }

    public func getCovidData(for scope: DataScope,
                             completion: @escaping (Result<[DayData], Error>) -> Void) {

        let urlString: String
        switch scope {
        case .national:
            urlString = "https://api.covidtracking.com/v2/us/daily.json"
        case .state(let state):
            urlString = "https://api.covidtracking.com/v2/states/\(state.state_code.lowercased())/daily.json"

        }

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let result = try JSONDecoder().decode(CovidDataResponse.self, from: data)
                
//                result.data.forEach { model in
//                    print(model.date)
//                }
                let models: [DayData] = result.data.compactMap {
                    guard let value = $0.cases?.total.value
                    else {
                        return nil
                    }
                    return DayData(
                        date: $0.date,
                        count: value
                    )
                }
                completion(.success(models))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    public func getStateList(completion: @escaping (Result<[State], Error>) -> Void) {

        guard let url = Constants.allStatesURL else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let result = try JSONDecoder().decode(StateListResponse.self, from: data)
                let states = result.data
                completion(.success(states))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
