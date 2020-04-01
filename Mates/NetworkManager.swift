//
//  NetworkManager.swift
//  Mates
//
//  Created by Georgy Stepanov on 29.03.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    
    static let serverUrl = "http://192.168.1.5:5000/api"
    
    static let headers: [String: String] = ["Content-Type": "application/json"]
    
    static let httpHeaders = HTTPHeaders(headers)
    
    static func signUp(urlString: String, user: User, _ completion: @escaping (_ data: [String: Any]) -> ()) {
        
        guard let url = URL(string: "\(serverUrl)\(urlString)") else { return }
        
        let userData: [String: Any] = [
            "first_name": user.first_name!,
            "last_name": user.last_name!,
            "b_date": user.b_date!,
            "gender": user.gender!,
            "email": user.email!,
            "password": user.password!,
            "phone": user.phone!
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: userData,
                   encoding: JSONEncoding.default,
                   headers: httpHeaders).validate().responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        completion(value as! [String: Any])
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
        }
        
    }
    
    static func signIn(urlString: String, email: String?, password: String?, _ completion: @escaping (_ data: [String: Any]) -> () ) {
        
        // Создаем URL на основе urlString - строки
        guard let url = URL(string: "\(serverUrl)\(urlString)") else { return }
        
        // создаем Dictionary, которое будем отправлять на сервер
        let userData: [String: String] = [
            "email": email ?? "",
            "password": password ?? ""
        ]
        
        // Создаем post запрос на сервер
        AF.request(url,
                   method: HTTPMethod.post,
                   parameters: userData,
                   encoding: JSONEncoding.default,
                   headers: httpHeaders).validate().responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        completion(value as! [String: Any])
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
        }
    }
}
