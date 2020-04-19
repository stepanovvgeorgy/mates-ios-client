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
    
    let serverUrl = "http://192.168.1.5:5500/api"
    let uploadsUrl = "http://192.168.1.5:5500/uploads"
    
    static var shared: NetworkManager = {
        let instance = NetworkManager()
        return instance
    }()
    
    var headers: HTTPHeaders {
        get {
            let headersDict: [String: String] = ["Content-Type": "application/json"]
            let headers = HTTPHeaders(headersDict)
            return headers
        }
    }
    
    var headersWithToken: HTTPHeaders {
        get {
            let headersDict: [String: String] = [
                "Content-Type": "application/json",
                "token": UserDefaults.standard.value(forKey: "token") as! String
            ]
            
            let headers = HTTPHeaders(headersDict)
            
            return headers
        }
    }
    
    
    func signUp(urlString: String, user: User, _ completion: @escaping (_ data: [String: Any]) -> (), failure: @escaping (_ error: [String: String]) -> ()) {
        
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
                   headers: headers).validate().responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        
                        if response.response?.statusCode == 201 {
                            completion(value as! [String: Any])
                        } else {
                            failure(value as! [String: String])
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
        }
        
    }
    
    func signIn(urlString: String, email: String?, password: String?, completion: @escaping (_ data: [String: Any]) -> (), failure: @escaping (_ error: [String: String]) -> () ) {
        
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
                   headers: headers).validate().responseJSON { (response) in
                    
                    switch response.result {
                    case .success(let value):
                        if response.response?.statusCode == 202 {
                            completion(value as! [String: Any])
                        } else {
                            failure(value as! [String: String])
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    
        }
    }
    
    func getUserById(_ id: Int, _ completion: @escaping (_ user: User) -> ()) {
        guard let url = URL(string: "\(serverUrl)/user/\(id)") else { return }
        
        AF.request(url, method: .get, headers: headersWithToken).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                
                let data = JSON(value)
                
                let userFromServer = User(first_name: data["first_name"].stringValue,
                                          last_name: data["last_name"].stringValue,
                                          b_date: data["b_date"].stringValue,
                                          gender: data["gender"].intValue,
                                          email: data["email"].stringValue,
                                          phone: data["phone"].stringValue,
                                          password: nil,
                                          avatar: "\(self.uploadsUrl)/\(data["avatar"].stringValue)")
                
                completion(userFromServer)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func uploadImage(url: String, _ image: UIImage, adID: String?, resize: CGSize?, _ completion: @escaping () -> ()) {
        
        let croppedImage = Helper.shared.resizeImage(image: image, targetSize: resize ?? CGSize(width: 320, height: 240))
        
        guard let imageData = croppedImage.jpegData(compressionQuality: 0.9) else {return}
        
        AF.upload(multipartFormData: { (form) in
            form.append(imageData, withName: "file_data", fileName: "\(Helper.shared.randomString(length: 7)).jpg", mimeType: "image/jpeg")
            
            if adID != nil {
                form.append((adID as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: "ad_id")
            }
            
            let token = UserDefaults.standard.value(forKey: "token") as! String

            form.append((token as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: "token")
            
        }, to: "\(serverUrl)\(url)", method: .post).response { result in
            completion()
        }
    }
    
    
    func sendAd(data: [String: Any], _ completion: @escaping (_ adID: Int) -> ()) {
        let url = URL(string: "\(serverUrl)/ad/add")
        
        AF.request(url!,
                   method: .post,
                   parameters: data,
                   encoding: JSONEncoding.default,
                   headers: headersWithToken).validate().responseJSON { (response) in
                    switch response.result {
                    case .success(let adID):
                        completion(adID as! Int)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
        }
    }
    
    func getAds(url: String, _ completion: @escaping (_ ads: [Ad], _ total: String) -> ()) {

        let url = URL(string: "\(serverUrl)\(url)")
        
        AF.request(url!, method: .get, headers: headersWithToken).validate().responseJSON { (response) in
            switch response.result {
            case .success(let dataJson):
                
                let data = JSON(dataJson)
                                
                let totalCount = response.response?.headers["total"]
                
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
                                    previewImage: "\(self.uploadsUrl)/\(item["Images"][0]["name"].stringValue)",
                                    images: nil,
                                    userFirstName: item["User"]["first_name"].stringValue,
                                    userLastName: nil,
                                    userAvatarString: "\(self.uploadsUrl)/\(item["User"]["avatar"].stringValue)",
                                    userBDate: nil,
                                    createdDate: nil)
                        
                        
                        adsArray.append(ad)
                    }
                    
                    completion(adsArray, totalCount!)
                    
                } else {
                    print("empty")
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getAdByID(_ id: Int, _ completion: @escaping (Ad) -> ()) {
        
        guard let url = URL(string: "\(serverUrl)/ad/\(id)") else {return}
        
        AF.request(url, method: .get, headers: headersWithToken).validate().responseJSON { (response) in
            switch response.result {
            case .success(let data):
                
                let item = JSON(data)
                
                let images = JSON(item["Images"])
                
                var imagesUrls = Array<String>()
                
                images.array!.forEach({ (item) in
                    let imageUrlString = "\(self.uploadsUrl)/\(item["name"].stringValue)"
                    imagesUrls.append(imageUrlString)
                })
                                    
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
                            previewImage: nil,
                            images: imagesUrls,
                            userFirstName: item["User"]["first_name"].stringValue,
                            userLastName: item["User"]["last_name"].stringValue,
                            userAvatarString: "\(self.uploadsUrl)/\(item["User"]["avatar"].stringValue)",
                            userBDate: item["User"]["b_date"].stringValue,
                            createdDate: item["createdAt"].stringValue)
                
                completion(ad)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
    
    func sendReview(toUserID: Int, review: Review, completion: @escaping () -> ()) {
        
        guard let url = URL(string: "\(serverUrl)/review/add/\(toUserID)") else {return}
                
        let parameters: [String : Any] = [
            "text": review.text!,
            "star": review.star!,
            "result": review.result!
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headersWithToken).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if response.response?.statusCode == 201 {
                    print(value)
                    completion()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
}
