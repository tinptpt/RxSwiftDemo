//
//  Video.swift
//  MVVM-RxSwiftDemo
//
//  Created by Tin Phan Thanh on 7/31/19.
//  Copyright © 2019 Tin Phan Thanh. All rights reserved.
//

import ObjectMapper

class Video: Mappable {
    var videoId: String?
    var videoTitle: String?
    var videoChannelTitle: String?
    var videoThumbnailUrl: URL?
    
    required init?(map: Map) {
        videoId = try? map.value("snippet.id.videoId")
        videoTitle = try? map.value("snippet.title")
        videoThumbnailUrl = (try? map.value("snippet.thumbnails.high", using: URLTransform())) ?? (try?  map.value("snippet.thumbnails.medium", using: URLTransform()))
    }
    
    func mapping(map: Map) {}
}

class Videos: Mappable {
    var videos: [Video]?
    
    required init?(map: Map) {
        videos = try? map.value("items")
    }
    
    func mapping(map: Map) {}
}
