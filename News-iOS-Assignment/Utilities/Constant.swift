//
//  Constant.swift
//  News-iOS-Assignment
//
//  Created by Jay Firke on 31/08/23.
//

import Foundation

public func saveUserSignedInStatus(_ isSignedIn: Bool) {
    UserDefaults.standard.set(isSignedIn, forKey: "isUserSignedIn")
}

public func getUserSignedInStatus() -> Bool {
    return UserDefaults.standard.bool(forKey: "isUserSignedIn")
}


class Constant{
    static let internet_connection_issue = "please check your iternet connection."
    static let unable_create_url = "Unable to create URL."
    static let something_went_wrong = "Something went wrong. Please try again."
    static let session_expired = "Session is expired. Please Re-Login."
    static let decoding_error = "Something went wrong in decoding response. Please try again later"
    enum API: String{
        case EVERYTHING = ""
    }
}

