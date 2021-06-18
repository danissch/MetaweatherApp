//
//  NetworkService.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 16/06/21.
//

import Foundation
import Alamofire

class NetworkService: NetworkServiceProtocol {
    
    static let get = NetworkService()
    private init(){}
    var afSessionManager:AFSessionManagerProtocol?
    private let verbose = true
    
    private func verbosePrint(_ msg:String){
        if verbose {
            print(msg)
        }
    }
    
    
    private func treatError(url:String, response: DataResponse<String>) -> String{
        verbosePrint("error =\(response.description)")
        if let localizedDescription = response.result.error?.localizedDescription{
            return localizedDescription
        } else if response.result.debugDescription.count > 0 {
            return response.result.debugDescription
        }
        return "error: \(response.response?.statusCode ?? 0)"
    }
    
    func request(url: String, method: HTTPMethod, parameters: Parameters?, completion: @escaping (ServiceResult<String?>) -> Void) {
        
        guard let sessionManager = afSessionManager else {
            return completion(.Error("Error creating request", 0))
        }
        
        sessionManager.responseString(url, method: method, parameters: parameters, enconding: JSONEncoding.default)
        { [weak self] response in
            self?.verbosePrint("url=\(response.request?.url?.description ?? "")")
            let statusCode = response.response?.statusCode ?? -1
            self?.verbosePrint("status code=\(statusCode)")
            if response.result.isSuccess {
                return completion(.Success(response.result.value, statusCode))
            }
            return completion(.Error(self?.treatError(url: url, response: response) ?? "", response.response?.statusCode))
            
        }
        
        
    }
    
}
