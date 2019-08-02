//
//  YoutubeAPIManager.swift
//  MVVM-RxSwiftDemo
//
//  Created by Tin Phan Thanh on 7/31/19.
//  Copyright © 2019 Tin Phan Thanh. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire


enum ApiPath: String {
    case search = "search"
    case videos = "videos"
}

enum SearchType: String {
    case video = "video"
    case channel = "channel"
    case playlist = "playlist"
}

class APIManager {
    
    static let shared = APIManager()


    private struct Constants {
        static let baseUrl = "https://www.googleapis.com/youtube/"
        static let apiVersion = "v3/"
        static let apiKey = "AIzaSyB6IhHqdWbDc1oBcwsxTOvZqRk4Pvyo5hs"
    }
    
    // MARK: Search video return list of 50 items
    func searchVideo(byKeyword keyword: String) -> Observable<[Video]> {
        let param: [String: Any] = [
            "q": keyword,
            "key": Constants.apiKey,
            "type": SearchType.video.rawValue,
            "part": "snippet",
            "maxResults": 50
        ]
        let url = Constants.baseUrl + Constants.apiVersion + ApiPath.search.rawValue

        return Observable<[Video]>.create({ observable -> Disposable in
            Alamofire.request(url,
                              method: .get,
                              parameters: param,
                              encoding: URLEncoding.default)
                .responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        guard let jsonDictionary = value as? [String: Any] else {
                            let userInfo: [String : Any] =
                            [NSLocalizedDescriptionKey : "Cannot parse data"]
                            let error = NSError(domain:"", code:0, userInfo:userInfo)
                            return observable.onError(error)
                        }
                        
                        if let itemResponse = Videos(JSON: jsonDictionary), let items = itemResponse.videos {
                            observable.onNext(items)
                        }
                    case .failure(let error): observable.onError(error)
                    }
                })
            return Disposables.create()
        })
    }
    
    // MARK: Search with pagination
    func searchVideoWithPagination(byKeyword keyword: String, pageToken: String) -> Observable<([Video], String)> {
        let param: [String: Any] = [
            "q": keyword,
            "apiKey": Constants.apiKey,
            "type": SearchType.video.rawValue,
            "pageToken": pageToken,
            "part": "snippet"
        ]
        let url = Constants.baseUrl + Constants.apiVersion + ApiPath.search.rawValue
        
        return Observable<([Video], String)>.create({ observable -> Disposable in
            Alamofire.request(url,
                              method: .get,
                              parameters: param,
                              encoding: URLEncoding.default)
                .responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        guard let jsonDictionary = value as? [String: Any] else {
                            let userInfo: [String : Any] =
                                [NSLocalizedDescriptionKey : "Cannot parse data"]
                            let error = NSError(domain:"", code:0, userInfo:userInfo)
                            return observable.onError(error)
                        }
                        
                        if let pageToken = jsonDictionary["nextPageToken"] as? String, let itemResponse = Videos(JSON: jsonDictionary), let items = itemResponse.videos {
                            observable.onNext((items, pageToken))
                        }
                    case .failure(let error): observable.onError(error)
                    }
                })
            return Disposables.create()
        })
    }
}
