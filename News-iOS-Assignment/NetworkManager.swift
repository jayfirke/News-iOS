//
//  NetworkManager.swift
//  News-iOS-Assignment
//
//  Created by Jay Firke on 31/08/23.
//

import UIKit
import Alamofire



typealias NetworkCompletionHandlerAlamofire = (AFDataResponse<Data>) -> Void
public typealias ErrorHandlerAlamofire = (String) -> Void


public enum WebUrl
{
    static let QaEnvironment = ""
    static let UATEnvironment = "https://newsapi.org/v2/everything?apiKey=\(Keys.apiKey)"
    static let ProdEnvironment = ""
}

open class NetworkManager
{
    static let genericError = Constant.something_went_wrong
    static let invalidLogin = Constant.session_expired
    static let parsingError = Constant.decoding_error
    
    public init()
    {
        
    }
    //MARK:- URL base end point
    
    func createBaseUrl(endPoint: String ,baseUrl:String?) -> String
    {
        if let baseurl = baseUrl
        {
            var finalEndpoint = ""
            finalEndpoint = String(format:"%@%@",baseurl,endPoint)
            return finalEndpoint
        }
        
        var url = WebUrl.UATEnvironment
        if(baseUrl != nil){
            url = baseUrl ?? ""
        }
        var  BaseUrl = url
        var finalEndpoint = ""
        finalEndpoint = String(format:"%@%@",BaseUrl,endPoint)
        return finalEndpoint
    }
    
    
    
    func checkForNetworkConnection(errorHandler: @escaping ErrorHandlerAlamofire)
    {
        if !NetworkRechability.isConnectedToNetwork()
        {
            errorHandler(Constant.internet_connection_issue)
            return
        }
    }
    
    //MARK:- GET API
    
    open func get<F:Decodable>(urlString: String,
                                            headers: [String: String] = [:],
                                            successHandler: @escaping (F) -> Void,
                                            errorHandler: @escaping ErrorHandlerAlamofire)
    {
        checkForNetworkConnection(errorHandler: errorHandler)
        
        let completionHandler: NetworkCompletionHandlerAlamofire = { (DataResponse) in
            self.genericResponseParsing(DataResponse: DataResponse, successHandler: successHandler, errorHandler: errorHandler)
        }
        
        guard let url = URL(string: createBaseUrl(endPoint: urlString, baseUrl: nil)) else {
            return errorHandler(Constant.unable_create_url)
        }
        
        var request = URLRequest(url: url)
        if(!headers.isEmpty){
            for (key,value) in headers{
                request.allHTTPHeaderFields?[key] = value
            }
        }
        
        print("\n date : \(Date()) urlRequest \(String(describing: request.url)) \n\n")
        request.timeoutInterval = 90
        AF.request(request).responseData(completionHandler: completionHandler)
    }
    
    func genericResponseParsing<F: Decodable>(DataResponse: AFDataResponse<Data>, successHandler: @escaping (F) -> Void, errorHandler: @escaping ErrorHandlerAlamofire) {
        if let error = DataResponse.error {
            errorHandler(error.localizedDescription)
            return
        }
        
        guard let data = DataResponse.data else {
            errorHandler(NetworkManager.parsingError)
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
            print(json)
            
            if let jsonDictionary = json as? [String: Any], let error = jsonDictionary["error"] as? String {
                errorHandler(error)
                return
            } else {
                let responseObject = try JSONDecoder().decode(F.self, from: data)
                successHandler(responseObject)
                return
            }
        } catch {
            errorHandler(error.localizedDescription)
        }
    }
}
