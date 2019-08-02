//
//  VideoTableViewCell.swift
//  MVVM-RxSwiftDemo
//
//  Created by Tin Phan Thanh on 8/2/19.
//  Copyright © 2019 Tin Phan Thanh. All rights reserved.
//

import Kingfisher
import UIKit

class VideoTableViewCell: UITableViewCell {
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoChannelTitleLabel: UILabel!

    func config(_ video: Video) {
        videoImageView.kf.setImage(with: video.videoThumbnailUrl)
        videoTitleLabel.text = video.videoTitle
        videoChannelTitleLabel.text = video.videoChannelTitle
    }
}
