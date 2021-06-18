//
//  AFSessionManagerProtocol.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 16/06/21.
//

import Foundation
import Alamofire

protocol AFSessionManagerProtocol {
    func responseString(_ url:String,
                        method: HTTPMethod,
                        parameters: Parameters?,
                        enconding: ParameterEncoding,
                        completionHandler: @escaping (DataResponse<String>) -> Void)
}
