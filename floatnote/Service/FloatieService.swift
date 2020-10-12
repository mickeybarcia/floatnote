//
//  FloatieLoginService.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/11/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftUI
import SwiftKeychainWrapper

public class FloatieSession {
    public static let `default` = Session(interceptor: FloatieServiceRequestAdaptor())
}

open class FloatieService {

    private let baseURL = FloatieEnvironment.FLOATIE_SERVER_URL + "/api/v1"
    let session: Session
    
    public init(floatieSession: Session=FloatieSession.default) {
        self.session = floatieSession
    }
    
    static func saveAccessToken(usernameOrEmail: String, password: String, token: String) {
        UserDefaults.standard.set(usernameOrEmail, forKey: "username")  // TODO - refactor
        KeychainWrapper.standard.set(password, forKey: "password")
        KeychainWrapper.standard.set(token, forKey: "token")
    }
    
    open func login(
        usernameOrEmail: String,
        password: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (FloatieError) -> Void
    ) {
        let request = session.request(
            baseURL + "/auth/login",
            method: .post,
            parameters: [
                "usernameOrEmail": usernameOrEmail,
                "password": password
            ],
            encoding: JSONEncoding.default
        ).validate()
        request.responseJSON { (response) in
            switch response.result {
            case .success(let json):
                if let data = json as? [String: Any], let token: String = data["token"] as? String {
                    FloatieService.saveAccessToken(usernameOrEmail: usernameOrEmail, password: password, token: token)
                    onSuccess()
                }
            case .failure(_):
                if let code = response.response?.statusCode {
                    onFailure(FloatieError.checkErrorCode(code))
                    return
                }
                onFailure(FloatieError.serverError)
            }
        }
    }
    
    func logout(onSuccess: @escaping () -> Void) {
         KeychainWrapper.standard.removeObject(forKey: "password")
         KeychainWrapper.standard.removeObject(forKey: "token")
         UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
         onSuccess()
    }
        
    func register(
        user: User,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (FloatieError) -> Void
    ) {
        let request = session.request(
            baseURL + "/auth/register",
            method: .post,
            parameters: user.toDictionary(),
            encoding: JSONEncoding.default
        ).validate()
        request.responseJSON { (response) in
            switch response.result {
            case .success(let json):
                if let data = json as? [String: Any],
                    let isCreated = data["isCreated"] as? Bool,
                    isCreated == false
                {
                    onFailure(FloatieError.usernameExists)
                } else if let data = json as? [String: Any],
                    let token: String = data["token"] as? String,
                    let password = user.password
                {
                    UserDefaults.standard.set(user.username, forKey: "username")
                    KeychainWrapper.standard.set(password, forKey: "password")
                    KeychainWrapper.standard.set(token, forKey: "token")
                    onSuccess()
                }
            case .failure(_):
                onFailure(FloatieError.serverError)
            }
        }
    }
    
    func getCurrentUser(
        onSuccess: @escaping (User) -> Void,
        onFailure: @escaping () -> Void
    ) {
        let request = session.request(
            baseURL + "/user",
            method: .get
        ).validate()
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateUtil.entryJsonDateFormatter)
        request.responseDecodable(of: User.self, decoder: jsonDecoder) { (response) in
            switch response.result {
            case .success(let user):
                onSuccess(user)
            case .failure(_):
                onFailure()
            }
        }
    }
    
    func updateProfile(
        profileChanges: [String: String],
        onSuccess: @escaping (User) -> Void,
        onFailure: @escaping () -> Void
    ) {
        let request = session.request(
            baseURL + "/user",
            method: .patch,
            parameters: profileChanges,
            encoding: JSONEncoding.default
        ).validate()
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateUtil.entryJsonDateFormatter)
        request.responseDecodable(of: User.self, decoder: jsonDecoder) { (response) in
            switch response.result {
            case .success(let user):
                onSuccess(user)
            case .failure(_):
                onFailure()
            }
        }
    }
    
    func updateEmail(
        email: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping () -> Void
    ) {
        let request = session.request(
            baseURL + "/user/email",
            method: .put,
            parameters: ["email": email],
            encoding: JSONEncoding.default
        ).validate()
        request.response { (response) in
            switch response.result {
            case .success(_):
                onSuccess()
            case .failure(_):
                onFailure()
            }
        }
    }
    
    func updateUsername(
        username: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (FloatieError) -> Void
    ) {
        let request = session.request(
            baseURL + "/user/username",
            method: .put,
            parameters: ["username": username],
            encoding: JSONEncoding.default
        ).validate()
        request.responseJSON { (response) in
            switch response.result {
            case .success(let json):
                if let data = json as? [String: Any],
                    let isUpdated = data["isUpdated"] as? Bool,
                    isUpdated == false
                {
                    onFailure(FloatieError.usernameExists)
                    return
                }
                UserDefaults.standard.set(username, forKey: "username")
                onSuccess()
            case .failure(_):
                onFailure(FloatieError.serverError)
            }
        }
    }
    
    func validateUsername(
        username: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (FloatieError) -> Void
    ) {
        let request = session.request(
            baseURL + "/auth/username",
            method: .post,
            parameters: ["username": username],
            encoding: JSONEncoding.default
        ).validate()
        request.responseJSON { (response) in
            switch response.result {
            case .success(let json):
                if
                    let data = json as? [String: Any],
                    let isUnique = data["isUnique"] as? Bool,
                    isUnique == false
                {
                    onFailure(FloatieError.usernameExists)
                    return
                }
                onSuccess()
            case .failure(let error):
                print(error)
                onFailure(FloatieError.serverError)
            }
        }
    }
    
    func deleteUser(
        onSuccess: @escaping () -> Void,
        onFailure: @escaping () -> Void
    ) {
        let request = session.request(
            baseURL + "/user",
            method: .delete
        ).validate()
        request.response { (response) in
            switch response.result {
            case .success(_):
                onSuccess()
            case .failure(_):
                onFailure()
            }
        }
    }
    
    func forgotPassword(
        usernameOrEmail: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping () -> Void
    ) {
        let request = session.request(
            baseURL + "/auth/forgotPassword",
            method: .post,
            parameters: ["usernameOrEmail": usernameOrEmail],
            encoding: JSONEncoding.default
        ).validate()
        request.response { (response) in
            switch response.result {
            case .success(_):
                onSuccess()
            case .failure(_):
                onFailure()
            }
        }
    }
    
    func updatePassword(
        oldPassword: String,
        newPassword: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (FloatieError) -> Void
    ) {
        let request = session.request(
            baseURL + "/user/password",
            method: .put,
            parameters: [
                "oldPassword": oldPassword,
                "newPassword": newPassword
            ],
            encoding: JSONEncoding.default
        ).validate()
        request.response { (response) in
            switch response.result {
            case .success(_):
                KeychainWrapper.standard.set(newPassword, forKey: "password")
                onSuccess()
            case .failure(_):
                if let code = response.response?.statusCode {
                    onFailure(FloatieError.checkErrorCode(code))
                    return
                }
                onFailure(FloatieError.serverError)
            }
        }
    }
    
    func resendVerification(
        email: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping () -> Void
    ) {
        let request = session.request(
            baseURL + "/verify",
            method: .post,
            parameters: ["email": email],
            encoding: JSONEncoding.default
        ).validate()
        request.response { (response) in
            switch response.result {
            case .success(_):
                onSuccess()
            case .failure(_):
                onFailure()
            }
        }
    }
    
    func getEntries(
        startDate: Date?=nil,
        endDate: Date?=nil,
        page: Int,
        onSuccess: @escaping (Entries) -> Void,
        onFailure: @escaping () -> Void
    ) {
        var url = baseURL + "/entries?page=" + String(page)
        if let startDate = startDate, let endDate = endDate {
            url = url +
                "&startDate=" + DateUtil.getEntryRequestStringFromDate(date: startDate) +
                "&endDate=" + DateUtil.getEntryRequestStringFromDate(date: endDate)
        }
        let request = session.request(
            url,
            method: .get
        ).validate()
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateUtil.entryJsonDateFormatter)  // TODO set as json decoder
        request.responseDecodable(of: Entries.self, decoder: jsonDecoder) { (response) in
            switch response.result {
            case .success(let entries):
                onSuccess(entries)
            case .failure(_):
                onFailure()
            }
        }
    }
    
    func createEntry(
        entry: Entry,
        onSuccess: @escaping (Entry) -> Void,
        onFailure: @escaping () -> Void
    ) {
        let request = session.request(
            baseURL + "/entries",
            method: .post,
            parameters: entry.toDictionary(),
            encoding: JSONEncoding.default
        ).validate()
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateUtil.entryJsonDateFormatter)
        request.responseDecodable(of: Entry.self, decoder: jsonDecoder) { (response) in
            switch response.result {
            case .success(let entry):
                onSuccess(entry)
            case .failure(_):
                onFailure()
            }
        }
    }
    
    func saveImages(
        images: [UIImage],
        entryId: String,
        onSuccess: @escaping (Entry) -> Void,
        onFailure: @escaping (FloatieError) -> Void
    ) {
        let request = session.upload(
            multipartFormData: { multipartFormData in
                for (index, image) in images.enumerated() {
                    if let imageData = image.jpegData(compressionQuality: 0.5) {
                        multipartFormData.append(
                            imageData,
                            withName: "page",
                            fileName: "page" + String(index) + ".png",
                            mimeType: "image/jpeg"
                        )
                    } else {
                        onFailure(FloatieError.invalidRequest)
                    }
                }
            },
            to: baseURL + "/entries/" + entryId,
            method: .put
        ).validate()
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateUtil.entryJsonDateFormatter)
        request.responseDecodable(of: Entry.self, decoder: jsonDecoder) { (response) in
            switch response.result {
            case .success(let entry):
                onSuccess(entry)
            case .failure(_):
                onFailure(FloatieError.serverError)
            }
        }
    }
    
    func editEntry(
        entry: Entry,
        entryId: String,
        onSuccess: @escaping (Entry) -> Void,
        onFailure: @escaping () -> Void
    ) {
        let request = session.request(
            baseURL + "/entries/" + entryId,
            method: .put,
            parameters: entry.toDictionary(),
            encoding: JSONEncoding.default
        ).validate()
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateUtil.entryJsonDateFormatter)
        request.responseDecodable(of: Entry.self, decoder: jsonDecoder) { (response) in
            switch response.result {
            case .success(let entry):
                onSuccess(entry)
            case .failure(_):
                onFailure()
            }
        }
    }
    
    func loadImage(
        name: String,
        entryId: String,
        onSuccess: @escaping (UIImage) -> Void,
        onFailure: @escaping () -> Void
    ) {
        let request = session.request(
            baseURL + "/entries/" + String(entryId) + "/images/" + name,
            method: .get
        ).validate()
        request.responseImage {
            (response) in
            switch response.result {
            case .success(let image):
                onSuccess(image)
            case .failure(_):
                onFailure()
            }
        }
    }
    
    func validateImage(
        image: UIImage,
        onSuccess: @escaping (Bool) -> Void,
        onFailure: @escaping () -> Void
    ) {
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            let request = session.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(
                        imageData,
                        withName: "page",
                        fileName: "page.png",
                        mimeType: "image/jpeg"
                    )
                },
                to: baseURL + "/entries/images"
            ).validate()
            request.responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    if let data = json as? [String: String], let text: String = data["text"] {
                        onSuccess(text.count > 1)
                    } else {
                        onFailure()
                    }
                case .failure(_):
                    onFailure()
                }
            }
        } else {
            onFailure()
        }
    }
    
    func getSummary(
        startDate: Date,
        endDate: Date,
        onSuccess: @escaping (String) -> Void,
        onFailure: @escaping () -> Void
    ) {
        let request = session.request(
            baseURL + "/summary?startDate="
                + DateUtil.getEntryRequestStringFromDate(date: startDate)
                + "&endDate=" + DateUtil.getEntryRequestStringFromDate(date: endDate)
                + "&sentences=" + String(4),
            method: .get
        ).validate()
        request.responseJSON { (response) in
            switch response.result {
            case .success(let json):
                if let data = json as? [String: String], let summary: String = data["summary"] {
                    onSuccess(summary)
                } else {
                    onFailure()
                }
            case .failure(_):
                onFailure()
            }
        }
    }
    
    func deleteEntry(
        entryId: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping () -> Void
    ) {
        let request = session.request(
            baseURL + "/entries/" + entryId,
            method: .delete
        ).validate()
        request.response { response in
            switch response.result {
            case .success:
                onSuccess()
            case .failure:
                onFailure()
            }
        }
    }

}
