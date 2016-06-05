//
//  DeviceSettings.swift
//  Spitchy
//
//  Created by Rplay on 05/06/16.
//  Copyright © 2016 rplay. All rights reserved.
//

import Foundation
import AVFoundation

class DeviceSettings {
    
    //MARK: Variables
    
    var audioDevice: AVCaptureDevice?
    var videoDevice: AVCaptureDevice?
    
    
    //MARK: Functions
    
    func getAudioDevice() -> AVCaptureDevice {
        audioDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        return audioDevice!
    }
    
    func getVideoDevice() -> AVCaptureDevice {
        videoDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        return videoDevice!
    }
    
    func configureDevice(videoDevice: AVCaptureDevice) -> Void {
        do {
            try videoDevice.lockForConfiguration()
        } catch _ {
            print("Device KO");
        }
        //-- Lock focus
        videoDevice.focusMode = .AutoFocus
        
        //-- 1/20 of a second i.e 0.05seconds interval between frame
        //videoDevice.activeVideoMaxFrameDuration = CMTimeMake(10, 1)
        //videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1, 10)
        //videoDevice.activeVideoMinFrameDuration = CMTimeMake(1, 2)
        //videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1, 2)
        //--
        videoDevice.unlockForConfiguration()
        
    }
    
}
