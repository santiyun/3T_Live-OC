//
//  TLSLViewController.swift
//  TTTLive
//
//  Created by yanzhen on 2018/12/10.
//  Copyright © 2018 yanzhen. All rights reserved.
//

import UIKit
import TTTRtcEngineKit

class TLSLViewController: UIViewController {

    @IBOutlet private weak var videoTitleTF: UITextField!
    @IBOutlet private weak var videoSizeTF: UITextField!
    @IBOutlet private weak var videoBitrateTF: UITextField!
    @IBOutlet private weak var videoFpsTF: UITextField!
    @IBOutlet private weak var audioSwitch: UISwitch!
    @IBOutlet private weak var pickBGView: UIView!
    @IBOutlet private weak var pickView: UIPickerView!
    private let videoSizes = ["120P", "180P", "240P", "360P", "480P", "640x480", "960x540", "720P", "1080P", "自定义"]
    override func viewDidLoad() {
        super.viewDidLoad()
        audioSwitch.isOn = AppManager.isHighQualityAudio
        let isCustom = AppManager.localCustomProfile.isCustom
        refreshState(isCustom, profile: AppManager.localProfile)
        if isCustom {
            pickView.selectRow(9, inComponent: 0, animated: true)
            let custom = AppManager.localCustomProfile
            videoSizeTF.text = "\(Int(custom.videoSize.width))x\(Int(custom.videoSize.height))"
            videoBitrateTF.text = custom.bitrate.description
            videoFpsTF.text = custom.fps.description
        } else {
            pickView.selectRow(AppManager.localProfile.getProfileInfo().3, inComponent: 0, animated: true)
        }
    }
    
    public func saveAction() -> String? {
        
        if videoTitleTF.text == "自定义" {
            //videoSize必须以x分开两个数值
            if videoSizeTF.text == nil || videoSizeTF.text?.count == 0 {
                return "请输入正确参数"
            }
            
            let sizes = videoSizeTF.text?.components(separatedBy: "x")
            if sizes?.count != 2 {
                return "请输入正确视频参数"
            }
            
            guard let sizeW = Int(sizes![0]), sizeW > 0 else {
                return "请输入正确视频参数"
            }
            
            if sizeW > 1920 {
                return "视频宽最大为1920"
            }
            
            guard let sizeH = Int(sizes![1]), sizeH > 0 else {
                return "请输入正确视频参数"
            }
            
            if sizeH > 1080 {
                return "视频高最大为1080"
            }
            
            guard let bitrate = Int(videoBitrateTF.text!), bitrate > 0 else {
                return "请输入正确码率参数"
            }
            
            if bitrate > 5000 {
                return "码率不能大于5000"
            }
            
            guard let fps = Int(videoFpsTF.text!), fps > 0 else {
                return "请输入正确帧率参数"
            }
            
            if fps > 25 {
                return "帧率不能大于25"
            }
            
            AppManager.localCustomProfile = (true,CGSize(width: sizeW, height: sizeH),bitrate,fps)
        } else {
            AppManager.localCustomProfile.isCustom = false
            let index = pickView.selectedRow(inComponent: 0)
            AppManager.localProfile = AppManager.getProfileIndex(index)
        }
        AppManager.isHighQualityAudio = audioSwitch.isOn
        return nil
    }
    
    private func refreshState(_ isCustom: Bool, profile: TTTRtcVideoProfile) {
        if isCustom {
            videoTitleTF.text = "自定义"
            videoSizeTF.isEnabled = true
            videoBitrateTF.isEnabled = true
            videoFpsTF.isEnabled = true
        } else {
            let index = profile.getProfileInfo().3
            videoTitleTF.text = videoSizes[Int(index)]
            videoSizeTF.isEnabled = false
            videoBitrateTF.isEnabled = false
            videoFpsTF.isEnabled = false
            videoSizeTF.text = profile.getProfileInfo().1
            videoBitrateTF.text = profile.getProfileInfo().0
            videoFpsTF.text = profile.getProfileInfo().2.description
        }
    }
    
    @IBAction private func showMoreVideoPara(_ sender: Any) {
        pickBGView.isHidden = false
    }
    
    @IBAction private func cancelSetting(_ sender: Any) {
        pickBGView.isHidden = true
    }
    
    @IBAction private func sureSetting(_ sender: Any) {
        pickBGView.isHidden = true
        let index = pickView.selectedRow(inComponent: 0)
        let profile: TTTRtcVideoProfile = AppManager.getProfileIndex(index)
        refreshState(index == 9, profile: profile)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension TLSLViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return videoSizes.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return videoSizes[row]
    }
}
