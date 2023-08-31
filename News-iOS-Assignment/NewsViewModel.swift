//
//  NewsViewModel.swift
//  News-iOS-Assignment
//
//  Created by Jay Firke on 31/08/23.
//

import Foundation
import SwiftUI

class NewsViewModel:ObservableObject {
    @Published var alertMsg: String = ""
    @Published var news:[Article] = []
    
    public init(){
    }
    
    func callAPI(){
        let errorHandler: (String) -> Void = { (strError) in
            self.alertMsg = strError
            print("Error: ", strError)
        }
        
        let successHandler: (News) -> Void = { (response) in
            self.news = response.articles
            print("Success Handle")
        }
        
        let url = String(format:"&q=apple")
        NetworkManager().get(urlString: url, successHandler: successHandler, errorHandler: errorHandler)
        
    }
}
