//
//  NetworkServiceProtocol.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 16/06/21.
//

import Foundation
import Alamofire

enum ServiceResult<T> {
    case Success(T, Int)
    case Error(String, Int?)
}

protocol NetworkServiceProtocol {
    func request(url:String,
                 method:HTTPMethod,
                 parameters:Parameters?,
                 completion: @escaping(ServiceResult<String?>) -> Void)
}
