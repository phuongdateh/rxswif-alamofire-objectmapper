//
//  ApiRouter.swift
//  TestWhitePixel
//
//  Created by DoanDuyPhuong on 8/30/20.
//  Copyright © 2020 prox.com. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import ObjectMapper

// MARK: - ApiRouter
enum ApiRouter: URLRequestConvertible {
    
    case getFilm
    case getPosts(userId: Int)
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseUrl.asURL()
        var urlRequest = URLRequest.init(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    //MARK: - HttpMethod
    //This returns the HttpMethod type. It's used to determine the type if several endpoints are peresent
    private var method: Alamofire.HTTPMethod {
        switch self {
        case .getPosts:
            return .post
        case .getFilm:
            return .get
        }
    }
    
    //MARK: - Path
    //The path is the part following the base url
    private var path: String {
        switch self {
        case .getPosts:
            return "posts"
        case .getFilm:
            return "films"
        }
    }
    
    //MARK: - Parameters
    //This is the queries part, it's optional because an endpoint can be without parameters
    private var parameters: Parameters? {
        switch self {
        case .getPosts(let userId):
            return [Constants.Parameters.userId: userId]
        default:
            return [:]
        }
    }
}

// MARK: - ApiError
enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
}
