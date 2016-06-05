//
//  Session.swift
//  Spitchy
//
//  Created by Rplay on 05/06/16.
//  Copyright © 2016 rplay. All rights reserved.
//

import Foundation
import AVFoundation

class Session: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    var session: AVCaptureSession?
    var connection: AVCaptureConnection?
    var sessionQueue: dispatch_queue_t?
    var inputVideo: AVCaptureDeviceInput?
    var inputAudio: AVCaptureDeviceInput?
    var outputVideo: AVCaptureVideoDataOutput?
    var outputAudio: AVCaptureAudioDataOutput?
    
    //lazy var videoWriter = VideoWriter.sharedInstance
    //lazy var writerInputVideo = VideoWriter.sharedInstance.writerInputVideo
    //lazy var writerInputAudio = VideoWriter.sharedInstance.writerInputAudio
    
    let deviceSettings = DeviceSettings()
    
    func createSession() -> AVCaptureSession {
        sessionQueue = dispatch_queue_create("cameraQueue", DISPATCH_QUEUE_SERIAL)
        session = AVCaptureSession()
        session?.sessionPreset = AVCaptureSessionPreset640x480
        
        addVideoInput()
        addAudioInput()
        
        addVideoOutput()
        addAudioOutput()
        
        
        return session!
    }
    
    func addVideoInput() {
        
        let deviceVideo = deviceSettings.getVideoDevice()
        deviceSettings.configureDevice(deviceVideo)
        var addInputVideoError: NSError?
        
        do {
            try inputVideo = AVCaptureDeviceInput(device: deviceVideo)
        } catch let err as NSError {
            addInputVideoError = err
        }
        
        if addInputVideoError == nil {
            session?.addInput(inputVideo)
        } else {
            print("camera input error: \(addInputVideoError)")
        }
        
    }
    
    func addAudioInput() {
        
        let deviceAudio = deviceSettings.getAudioDevice()
        var addInputAudioError: NSError?
        
        do {
            let inputAudio = try AVCaptureDeviceInput(device: deviceAudio)
            session?.addInput(inputAudio)
        } catch let err as NSError {
            addInputAudioError = err
            print(addInputAudioError)
        }
    }
    
    func addVideoOutput() {
        outputVideo = AVCaptureVideoDataOutput()
        outputVideo?.alwaysDiscardsLateVideoFrames = true
        outputVideo?.setSampleBufferDelegate(self, queue: sessionQueue)
        
        if session!.canAddOutput(outputVideo) {
            session!.addOutput(outputVideo)
        }
    }
    
    
    func addAudioOutput() {
        outputAudio = AVCaptureAudioDataOutput()
        outputAudio?.setSampleBufferDelegate(self, queue: sessionQueue)
        
        if session!.canAddOutput(outputAudio) {
            session!.addOutput(outputAudio)
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        if connection.supportsVideoOrientation {
            connection.videoOrientation = AVCaptureVideoOrientation.Portrait
        }
        
        //videoWriter.write(sampleBuffer)
    }
    
    func startSession() {
        session?.startRunning()
    }
    
}
