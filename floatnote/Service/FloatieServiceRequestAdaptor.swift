//
//  FloatieServiceRequestAdaptor.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/17/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import Alamofire
import SwiftKeychainWrapper

/// Retry token when it expires and use token on headers
final class FloatieServiceRequestAdaptor: Alamofire.RequestInterceptor {
    
    private let baseURL = FloatieEnvironment.FLOATIE_SERVER_URL + "/api/v1"
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(FloatieEnvironment.FLOATIE_SERVER_URL + "/api/v1/auth") {
            return completion(.success(urlRequest))
        }
        var urlRequest = urlRequest
        guard let token = KeychainWrapper.standard.string(forKey: "token") else {
            // TODO - use token storage
            return
        }
        urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            return completion(.doNotRetryWithError(error))
        }
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            completion(.doNotRetryWithError(error))
            return
        }
        guard let password = KeychainWrapper.standard.string(forKey: "password") else {
            completion(.doNotRetryWithError(error))
            return
        }
//        FloatieService.login(
//            usernameOrEmail: username,
//            password: password,
//            onSuccess: {
//                completion(.retry)
//            },
//            onFailure: { error in
//                completion(.doNotRetryWithError(error))
//            }
//        )
        let request = session.request(
            baseURL + "/auth/login",
            method: .post,
            parameters: [
                "usernameOrEmail": username,
                "password": password
            ],
            encoding: JSONEncoding.default
        ).validate()
        request.responseJSON { (response) in
            switch response.result {
            case .success(let json):
                if let data = json as? [String: Any], let token: String = data["token"] as? String {
                    FloatieService.saveAccessToken(usernameOrEmail: username, password: password, token: token)
                    completion(.retry)
                }
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
    }

}
