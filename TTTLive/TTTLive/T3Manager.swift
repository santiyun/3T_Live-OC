//
//  T3Manager.swift
//  TTTLive
//
//  Created by yanzhen on 2018/11/14.
//  Copyright © 2018 yanzhen. All rights reserved.
//

import UIKit
import TTTRtcEngineKit

let AppManager = T3Manager.manager

extension TTTRtcVideoProfile {
    func getProfileInfo() -> (String, String, Int, Int, CGSize) {
        switch self {
        case ._VideoProfile_120P:
            return ("65", "160x120", 15, 0, CGSize(width: 120, height: 160))
        case ._VideoProfile_180P:
            return ("140", "320x180", 15, 1, CGSize(width: 180, height: 320))
        case ._VideoProfile_240P:
            return ("200", "320x240", 15, 2, CGSize(width: 240, height: 320))
        case ._VideoProfile_480P:
            return ("1000", "848x480", 15, 4, CGSize(width: 480, height: 848))
        case ._VideoProfile_640x480:
            return ("800", "640x480", 15, 5, CGSize(width: 480, height: 640))
        case ._VideoProfile_960x540:
            return ("1600", "960x540", 24, 6, CGSize(width: 540, height: 960))
        case ._VideoProfile_720P:
            return ("2400", "1280x720", 30, 7, CGSize(width: 720, height: 1280))
        case ._VideoProfile_1080P:
            return ("3000", "1920x1080", 30, 8, CGSize(width: 1080, height: 1920))
        default:
            return ("600", "640x360", 15, 3, CGSize(width: 360, height: 640))
        }
    }
}

class T3Manager: NSObject {

    public static let manager = T3Manager()
    public var rtcEngine: TTTRtcEngineKit!
    public var roomID: Int64 = 0
    public let me = YZUser(0)
    
    //--setting
    public var isCustom = false
    //--local
    public var isHighQualityAudio = false
    public var localProfile = TTTRtcVideoProfile._VideoProfile_Default
    public var localCustomProfile = (isCustom: false, videoSize: CGSize.zero, bitrate: 0, fps: 0)
    //--cdn
    var h265 = false
    var doubleChannel = false
    public var cdnProfile = TTTRtcVideoProfile._VideoProfile_Default
    public var cdnCustom = (isCustom: false, videoSize: CGSize.zero, bitrate: 0, fps: 0)
    
    private override init() {
        super.init()
        rtcEngine = TTTRtcEngineKit.sharedEngine(withAppId: <#AppId#>, delegate: nil)
    }
    
    public func getVoiceImage(_ audioLevel: UInt) -> UIImage {
        var image: UIImage = #imageLiteral(resourceName: "volume_1")
        if audioLevel < 4 {
            image = #imageLiteral(resourceName: "volume_1")
        } else if audioLevel < 7 {
            image = #imageLiteral(resourceName: "volume_2")
        } else {
            image = #imageLiteral(resourceName: "volume_3")
        }
        return image
    }
    
    func getProfileIndex(_ index: Int) -> TTTRtcVideoProfile {
        if index == 0 {
            return ._VideoProfile_120P
        } else if index == 1 {
            return ._VideoProfile_180P
        } else if index == 2 {
            return ._VideoProfile_240P
        } else if index == 3 {
            return ._VideoProfile_360P
        } else if index == 4 {
            return ._VideoProfile_480P
        } else if index == 5 {
            return ._VideoProfile_640x480
        } else if index == 6 {
            return ._VideoProfile_960x540
        } else if index == 7 {
            return ._VideoProfile_720P
        } else if index == 8 {
            return ._VideoProfile_1080P
        }
        return ._VideoProfile_360P
    }
}
