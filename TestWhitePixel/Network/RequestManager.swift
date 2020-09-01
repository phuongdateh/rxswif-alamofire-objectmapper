////
////  RequestManager.swift
////  TestWhitePixel
////
////  Created by DoanDuyPhuong on 8/30/20.
////  Copyright © 2020 prox.com. All rights reserved.
////
//
//import Foundation
//import Alamofire
//import RxSwift
//import ObjectMapper
//
//private struct Constant {
//    static var MappingObjectError: ApiError {
//        return ApiError(errCode: HTTPStatusCode.codeMapping.rawValue, message: HTTPStatusCode.codeMapping.message)
//    }
//}
//
//class RequestManager {
//    typealias SuccessHandle = ([String: Any]) -> Void
//    typealias FailedHandle = (ApiError) -> Void
//
//    static let shared = RequestManager()
//    private let sessionManager = Session!
//    private var headers: [String: String] = [:]
//
//    private init() {
//        headers["Content-Type"] = "application/json"
//
//        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = headers
//        configuration.timeoutIntervalForRequest = 30
//        sessionManager = Alamofire.SessionManager(configuration: configuration)
//    }
//
//    /// Base request response Json([String: Any])
//    func baseRequestAPI(url: Router) -> Observable<[String: Any]> {
//        return Observable.create({ observer -> Disposable in
//            self.sessionManager.request(url)
//                .responseJSON(completionHandler: { response in
//                    switch response.result {
//                    case .success(let value):
//                        Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: value)
//                        guard let json = value as? [String: Any] else {
//                            observer.onError(Constant.MappingObjectError)
//                            return
//                        }
//                        observer.onNext(json)
//                    case .failure(let error):
//                        let error = self.handleErrorResponse(error: error, response: response, url: url)
//                        observer.onError(error)
//                    }
//                    observer.onCompleted()
//                })
//            return Disposables.create()
//        })
//    }
//
//    /// Base request response Mappalbe of ObjectMapper
//    func baseRequestAPI<T: Mappable>(url: Router) -> Observable<T> {
//        return Observable.create({ observer -> Disposable in
//            self.sessionManager.request(url)
//                .responseJSON(completionHandler: { response in
//                    switch response.result {
//                    case .success(let value):
//                        Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: value)
//                        guard let json = value as? [String: Any], let mapper = Mapper<T>().map(JSON: json) else {
//                            observer.onError(Constant.MappingObjectError)
//                            return
//                        }
//                        observer.onNext(mapper)
//                    case .failure(let error):
//                        let error = self.handleErrorResponse(error: error, response: response, url: url)
//                        observer.onError(error)
//                    }
//                    observer.onCompleted()
//                })
//            return Disposables.create()
//        })
//    }
//
//    private func handleErrorResponse(error: Error, response: DataResponse<Any>, url: Router) -> ApiError {
//        if error._code == NSURLErrorTimedOut {
//            Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: error.localizedDescription)
//            return ApiError(errCode: HTTPStatusCode.code408.rawValue, message: HTTPStatusCode.code408.message)
//        } else {
//            guard let data = response.data else {
//                guard let httpStatus = response.response?.statusCode, let status = HTTPStatusCode(rawValue: httpStatus) else {
//                    return Constant.MappingObjectError
//                }
//                Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: error.localizedDescription)
//                return ApiError(errCode: status.rawValue, message: status.message)
//            }
//
//            do {
//                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any] {
//                    Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: jsonArray)
//                    if let code = jsonArray["code"] as? Int, let message = jsonArray["message"] as? String {
//                        return ApiError(errCode: code, message: message)
//                    } else {
//                        return Constant.MappingObjectError
//                    }
//                } else {
//                    Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: error.localizedDescription)
//                    return Constant.MappingObjectError
//                }
//            } catch let error as NSError {
//
//                Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: error.localizedDescription)
//                return ApiError(errCode: response.response?.statusCode ?? 0, message: error.localizedDescription)
//            }
//        }
//    }
//}
