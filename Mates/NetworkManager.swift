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
    
    let serverUrl = "http://192.168.1.5:5000/api"
    
    static var shared: NetworkManager = {
        let instance = NetworkManager()
        return instance
    }()
    
    func signUp(urlString: String, user: User, _ completion: @escaping (_ data: [String: Any]) -> ()) {
        
        guard let url = URL(string: "\(serverUrl)\(urlString)") else { return }
        
        let headers: [String: String] = ["Content-Type": "application/json"]
        
        let httpHeaders = HTTPHeaders(headers)
        
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
    
    func signIn(urlString: String, email: String?, password: String?, _ completion: @escaping (_ data: [String: Any]) -> () ) {
        
        // Создаем URL на основе urlString - строки
        guard let url = URL(string: "\(serverUrl)\(urlString)") else { return }
        
        let headers: [String: String] = ["Content-Type": "application/json"]
        
        let httpHeaders = HTTPHeaders(headers)
        
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
    
    func getUserById(_ id: Int, _ completion: @escaping (_ user: User) -> ()) {
        guard let url = URL(string: "\(serverUrl)/user/\(id)") else { return }
        
        let token = UserDefaults.standard.value(forKey: "token") as! String
        
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "token": token
        ]
        
        let httpHeaders = HTTPHeaders(headers)
        
        AF.request(url, method: .get, headers: httpHeaders).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                
                let data = JSON(value)
                
                let userFromServer = User(first_name: data["first_name"].stringValue,
                                          last_name: data["last_name"].stringValue,
                                          b_date: data["b_date"].stringValue,
                                          gender: data["gender"].intValue,
                                          email: data["email"].stringValue,
                                          phone: data["phone"].stringValue,
                                          password: "")
                
                completion(userFromServer)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func uploadImage(_ image: UIImage, adID: String, _ completion: @escaping () -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {return}
        
        AF.upload(multipartFormData: { (form) in
            form.append(imageData, withName: "file_data", fileName: "\(Helper.shared.randomString(length: 7)).jpg", mimeType: "image/jpeg")
            form.append((adID as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: "ad_id")
        }, to: "\(serverUrl)/images/upload", method: .post).response { result in
            print(result)
            completion()
        }
    }
    
    func sendAd(data: [String: Any], _ completion: @escaping (_ adID: Int) -> ()) {
        let headersDict: [String: String] = [
            "Content-Type": "application/json",
            "token": UserDefaults.standard.value(forKey: "token") as! String
        ]
        
        let headers = HTTPHeaders(headersDict)
        
        let url = URL(string: "\(serverUrl)/ad/add")
        
        AF.request(url!,
                   method: .post,
                   parameters: data,
                   encoding: JSONEncoding.default,
                   headers: headers).validate().responseJSON { (response) in
                    switch response.result {
                    case .success(let adID):
                        completion(adID as! Int)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
        }
    }
    
    func getAds(_ completion: @escaping (_ ads: [Ad]) -> ()) {
        let headersDict: [String: String] = [
            "Content-Type": "application/json",
            "token": UserDefaults.standard.value(forKey: "token") as! String
        ]
        
        let headers = HTTPHeaders(headersDict)
        let url = URL(string: "\(serverUrl)/ad/all")
        
        AF.request(url!, method: .get, headers: headers).validate().responseJSON { (response) in
            switch response.result {
            case .success(let dataJson):
                
                let data = JSON(dataJson)

                if !data.array!.isEmpty {
                    
                    var adsArray = Array<Ad>()
                    
                    data.array!.forEach { (item) in
                        let ad = Ad(id: item["id"].intValue,
                                    type: item["type"].intValue,
                                    subway: item["subway"].stringValue,
                                    timeToSubway: item["time_to_subway"].stringValue,
                                    street: item["street"].stringValue,
                                    numberOfHouse: item["number_of_house"].stringValue,
                                    housing: item["housing"].stringValue,
                                    numberOfRooms: item["number_of_rooms"].intValue,
                                    numberOfSalesRooms: item["number_of_sales_rooms"].intValue,
                                    genderMate: item["gender_mate"].intValue,
                                    timeToSale: item["time_to_sale"].intValue,
                                    animals: item["animals"].boolValue,
                                    price: item["price"].intValue,
                                    priceToTime: item["price_to_time"].intValue,
                                    infoText: item["info_text"].stringValue,
                                    userID: item["UserId"].intValue,
                                    attachmets: nil)
                        adsArray.append(ad)
                    }
                    
                    completion(adsArray)
                    
                } else {
                    print("empty")
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
}
