//
//  ApiClient.swift
//  TestWhitePixel
//
//  Created by DoanDuyPhuong on 8/30/20.
//  Copyright © 2020 prox.com. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import ObjectMapper

class ApiClient {
  
    
    static func test(urlString: String) -> Observable<[Post2]> {
        return request(urlString: urlString)
    }
 
    
    // MARK: - Request Mappable
    private static func request2<T: Mappable>(_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { (observer) -> Disposable in
            let request = AF.request(urlConvertible)
            request.responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    print("Log: Response: \(value)")
                    if let json = value as? [String: Any], let mapper = Mapper<T>().map(JSON: json) {
                        print("Log: Response JSON: \(json)")
                        observer.onNext(mapper)
                        observer.onCompleted()
                    }
                case .failure(let error):
                    print("Log: Error: \(error.localizedDescription) StatusCode: \(response.response?.statusCode)")
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

