//
//  APIClient.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 31/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class APIClient {
    private let baseURL = URL(string: "https://quanti.serveo.net/")!
    
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            var request = apiRequest.request(with: self.baseURL)
            request.httpBody = apiRequest.httpBody.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
