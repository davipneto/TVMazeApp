//
//  ApiRequest.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 08/01/23.
//

import Alamofire
import RxSwift
import SwiftyJSON

class ApiRequest {
    static func call(path: String, method: HTTPMethod = .get) -> Observable<JSON> {
        let observable = Observable.create { observer in
            AF.request(path, method: method)
                .responseJSON { response in
                    switch response.result {
                    case .success(let object):
                        observer.onNext(JSON(object))
                        observer.onCompleted()
                        
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
        return observable
    }
}

