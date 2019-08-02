//
//  SearchVideoViewModel.swift
//  MVVM-RxSwiftDemo
//
//  Created by Tin Phan Thanh on 8/1/19.
//  Copyright © 2019 Tin Phan Thanh. All rights reserved.
//

import Foundation
import RxSwift

class SearchVideoViewModel {
    //MARK: Observables

//    let loading: PublishSubject<Bool> = PublishSubject()
    let keyword: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    var videos: Observable<[Video]> = .empty()
    
    init() {
        videos = keyword.asObservable()
                        .debounce(.milliseconds(300), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
                        .distinctUntilChanged()
                        .flatMapLatest({ text -> Observable<[Video]> in
                            if text.isEmpty {
                                return .just([])
                            }
                            return APIManager.shared.searchVideo(byKeyword: text)
                        }).share(replay: 1, scope: .whileConnected)
    }
    
}
