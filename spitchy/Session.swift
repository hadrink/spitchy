//
//  Session.swift
//  Spitchy
//
//  Created by Rplay on 05/06/16.
//  Copyright © 2016 rplay. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class Session: UIView, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    var session: AVCaptureSession?
    var connection: AVCaptureConnection?
    var sessionQueue: dispatch_queue_t?
    var inputVideo: AVCaptureDeviceInput?
    var inputAudio: AVCaptureDeviceInput?
    var outputVideo: AVCaptureVideoDataOutput?
    var outputAudio: AVCaptureAudioDataOutput?
    var socket: SocketIOClient?
    
    var fakePreview = FakePreview.sharedInstance
    
    //lazy var videoWriter = VideoWriter.sharedInstance
    //lazy var writerInputVideo = VideoWriter.sharedInstance.writerInputVideo
    //lazy var writerInputAudio = VideoWriter.sharedInstance.writerInputAudio
    
    let deviceSettings = DeviceSettings()
    
    func createSession() -> AVCaptureSession {
        
        socket = SocketIOClient(socketURL: "http://vps224869.ovh.net:3005")
        socket?.connect()
        sessionQueue = dispatch_queue_create("cameraQueue", DISPATCH_QUEUE_SERIAL)
        session = AVCaptureSession()
        session?.sessionPreset = AVCaptureSessionPresetMedium
        
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
        
        let compressionSettings = [ AVVideoProfileLevelKey: AVVideoProfileLevelH264Main41, AVVideoAverageBitRateKey : 24*(1024.0*1024.0)]
        
        let videoSettings = [kCVPixelBufferPixelFormatTypeKey as NSString:Int(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange), AVVideoCodecKey : AVVideoCodecH264, AVVideoCompressionPropertiesKey: compressionSettings, AVVideoWidthKey : 480,  AVVideoHeightKey : 640 ]
        
        outputVideo?.videoSettings = videoSettings
        
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
    
    var count = 0
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
        if connection.supportsVideoOrientation {
            connection.videoOrientation = AVCaptureVideoOrientation.Portrait
        }
        
        
        
        
        /*if CMSampleBufferGetImageBuffer(sampleBuffer) != nil {
            print("get image")
            if fakePreview.preview != nil {
                fakePreview.enqueueSampleBuffer(fakePreview.preview!, sampleBuffer: sampleBuffer)
            }
        }*/
        
        // Pixel buffer
        
        
        if CMSampleBufferGetImageBuffer(sampleBuffer) != nil {
            
            if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                CVPixelBufferLockBaseAddress(imageBuffer, 0)
                let bytesPerRow: size_t = CVPixelBufferGetBytesPerRow(imageBuffer)
                let width: size_t = CVPixelBufferGetWidth(imageBuffer)
                let height: size_t = CVPixelBufferGetHeight(imageBuffer)
                let baseAddress = UnsafeMutablePointer<UInt8>(CVPixelBufferGetBaseAddress(imageBuffer))
                let pixelFormatType = CVPixelBufferGetPixelFormatType(imageBuffer)
                CVPixelBufferUnlockBaseAddress(imageBuffer, 0)
                
                let data = NSData(bytes: baseAddress, length: bytesPerRow * height)
                
                var ciImage: CIImage = CIImage(CVImageBuffer: imageBuffer)
                var context: CIContext = CIContext(options: nil)
                var videoImage: CGImageRef = context.createCGImage(ciImage, fromRect: CGRectMake(0, 0, 240, 320))
                var finalImage: UIImage = UIImage(CGImage: videoImage)
                
                var compressed = UIImageJPEGRepresentation(finalImage, 0)
                
                
                let imageCompress = compressed!.compressedDataUsingCompression(Compression.LZMA)
                
                
                socket?.emit("buffer_to_server", imageCompress!)
                
                
            }
            
                //self.cloneBuffer(sampleBuffer!)
           
        }
        
    }
    
    func cloneBuffer(sampleBuffer: CMSampleBuffer!) -> CMSampleBuffer? {
        var newSampleBuffer: CMSampleBuffer?
        
        if let oldImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            if let newImageBuffer = cloneImageBuffer(oldImageBuffer) {
                // NG?
                /*
                 I was able to fix the problem by creating a format description off the newly created image buffer and using it instead of the format description off the original sample buffer. Unfortunately while that fixes the problem here, the format descriptions don't match and causes problem further down.
                 */
                if let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer) {
                    let dataIsReady = CMSampleBufferDataIsReady(sampleBuffer)
                    let refCon = NSMutableData()
                    var timingInfo: CMSampleTimingInfo = kCMTimingInfoInvalid
                    let timingInfoSuccess = CMSampleBufferGetSampleTimingInfo(sampleBuffer, 0, &timingInfo)
                    if timingInfoSuccess == noErr {
                        let allocator: Unmanaged<CFAllocatorRef>! = CFAllocatorGetDefault()
                        var videoInfo: CMVideoFormatDescriptionRef?
                        
                        let attachments :CFArrayRef = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true)!
                        let dict :CFMutableDictionaryRef = unsafeBitCast(CFArrayGetValueAtIndex(attachments, 0),CFMutableDictionaryRef.self)
                        CFDictionarySetValue(dict, unsafeAddressOf(kCMSampleAttachmentKey_DisplayImmediately), unsafeAddressOf(kCFBooleanTrue))
                        CFDictionarySetValue(dict, unsafeAddressOf(kCMSampleAttachmentKey_DoNotDisplay), unsafeAddressOf(kCFBooleanFalse))
                    
                        CMVideoFormatDescriptionCreate(allocator.takeRetainedValue(), kCVPixelFormatType_32BGRA, 480, 640, dict, &videoInfo)
                        //var status = CMVideoFormatDescriptionCreateForImageBuffer(allocator.takeRetainedValue(), oldImageBuffer, &videoInfo)
                        let success = CMSampleBufferCreateForImageBuffer(allocator.takeRetainedValue(), newImageBuffer, dataIsReady, nil, refCon.mutableBytes, videoInfo!, &timingInfo, &newSampleBuffer)
                        if success == noErr {
                            //bufferArray.append(newSampleBuffer!)
                            
                            if fakePreview.preview != nil {
                                fakePreview.enqueueSampleBuffer(fakePreview.preview!, sampleBuffer: newSampleBuffer!)
                            }
                            
                        } else {
                            NSLog("Failed to create new image buffer. Error: \(success)")
                        }
                    } else {
                        NSLog("Failed to get timing info. Error: \(timingInfoSuccess)")
                    }
                }
            }
        }
        
        return newSampleBuffer
    }
    
    func cloneImageBuffer(imageBuffer: CVImageBuffer!) -> CVImageBuffer? {
        CVPixelBufferLockBaseAddress(imageBuffer, 0)
        let bytesPerRow: size_t = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width: size_t = CVPixelBufferGetWidth(imageBuffer)
        let height: size_t = CVPixelBufferGetHeight(imageBuffer)
        let baseAddress = UnsafeMutablePointer<UInt8>(CVPixelBufferGetBaseAddress(imageBuffer))
        
        //print("Base Address \(baseAddress[4])")
        let pixelFormatType = CVPixelBufferGetPixelFormatType(imageBuffer)
        
        
        let data = NSMutableData(bytes: baseAddress, length: bytesPerRow * height)
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0)
        
        var clonedImageBuffer: CVPixelBuffer?
        let allocator: Unmanaged<CFAllocatorRef>! = CFAllocatorGetDefault()
        let refCon = NSMutableData()
        
        
        var options = [
                        kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA),
                        kCVPixelBufferIOSurfacePropertiesKey as String: [NSObject: NSObject]()]
        
        if CVPixelBufferCreateWithBytes(allocator.takeRetainedValue(), width, height, pixelFormatType, data.mutableBytes, bytesPerRow, nil, refCon.mutableBytes, nil, &clonedImageBuffer) == noErr {
            
            var ciImage: CIImage = CIImage(CVImageBuffer: clonedImageBuffer!)
            var context: CIContext = CIContext(options: nil)
            var videoImage: CGImageRef = context.createCGImage(ciImage, fromRect: CGRectMake(0, 0, 480, 640))
            var finalImage: UIImage = UIImage(CGImage: videoImage)
            
            fakePreview.imageTest(finalImage)
            return clonedImageBuffer
        } else {
            return nil
        }
    }
    
    func returnData(sampleBuffer: CMSampleBuffer) -> NSData {
        let block = CMSampleBufferGetDataBuffer(sampleBuffer)
        
        var length = 0
        var data: UnsafeMutablePointer<Int8> = nil
        if block != nil {
            let status = CMBlockBufferGetDataPointer(block!, 0, nil, &length, &data)    // TODO: check for errors
        }
        let result = NSData(bytes: data, length: length)
        print("Result size \(result.length / 1024)")
        
        
        return result
        
        
    }
    
    func startSession() {
        session?.startRunning()
    }
    
}


class FakePreview {
    
    static let sharedInstance = FakePreview()
    var preview: AVSampleBufferDisplayLayer?
    
    var image: UIImage?
    
    func createFakePreview(size: CGSize) {
        let fakePreview = AVSampleBufferDisplayLayer()
        fakePreview.frame.size = size
        preview = fakePreview
    }
    
    
    func imageTest(image: UIImage) {
        self.image = image
    }
    
    func enqueueSampleBuffer(preview: AVSampleBufferDisplayLayer, sampleBuffer: CMSampleBuffer) {
        if preview.readyForMoreMediaData {
            //print("Video layer 2")
            
            var pts:Double  = CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer));
            
            var presentationTimeStamp: CMTime = CMTimeMake((Int64(pts) - 0)*1000000,1000000);
            
            CMSampleBufferSetOutputPresentationTimeStamp(sampleBuffer, presentationTimeStamp);
            
            
            if CMSampleBufferIsValid(sampleBuffer) {
                preview.enqueueSampleBuffer(sampleBuffer)
            
                //print("Preview Status \(preview.status)")
                
            }
        }
    }
    
}
