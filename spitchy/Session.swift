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
    
    var fakePreview = FakePreview.sharedInstance
    
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
        
        let videoSettings = [kCVPixelBufferPixelFormatTypeKey as NSString:Int(kCVPixelFormatType_32BGRA), AVVideoCodecKey : AVVideoCodecH264 ]
        
        outputVideo?.videoSettings = videoSettings as! [NSObject : AnyObject]
        
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
            
            
            
            /*var pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            
            CVPixelBufferLockBaseAddress(pixelBuffer!, 0)
            
            let rawImageBytes = CVPixelBufferGetBaseAddress(pixelBuffer!)
            let bufferData = UnsafeMutablePointer<UInt8>(CVPixelBufferGetBaseAddress(pixelBuffer!))
            
            CVPixelBufferUnlockBaseAddress(pixelBuffer!, 0)

            let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer!)
            let bufferWidth = CVPixelBufferGetWidth(pixelBuffer!)
            let bufferHeight = CVPixelBufferGetHeight(pixelBuffer!)
            let formatType: OSType = CVPixelBufferGetPixelFormatType(pixelBuffer!)

            let dataSize = CVPixelBufferGetDataSize(pixelBuffer!)
            
            print("Data size pixel buffer 1 \(dataSize)")
            
            
            print("Image Bytes \(rawImageBytes)")
            print("Bytes Per Row \(bytesPerRow)")
            print("Buffer Width \(bufferWidth)")
            print("Buffer Height \(bufferHeight)")
            print("Buffer data \(bufferData[3])")
            print("Format Type \(formatType)")
            
            //var buffer = [UInt8](count: 4*bufferWidth*bufferHeight, repeatedValue: 0)
            
            var PTS : CMTime = kCMTimeZero
            let time: Float = Float( CMTimeGetSeconds(PTS) * 0.6 )
            let scale: Float = 1.0
            let componentsPerPixel = 4
            let buffer: UnsafeMutablePointer<__uint8_t> = UnsafeMutablePointer<__uint8_t>.alloc(Int(bufferWidth * bufferHeight) * componentsPerPixel)
            
            let bpr = bufferWidth * componentsPerPixel
            
            for y in 0..<Int(bufferHeight) {
                for x in 0..<Int(bufferWidth) {
                    
                    var cx: Float = Float(x) / Float(componentsPerPixel) * scale;
                    var cy = Float(y) * scale;
                    
                    var v: Float = sinf(cx+time);
                    v += sinf(cy+time);
                    v += sinf(cx+cy+time);
                    
                    cx += scale * sinf(time*0.33);
                    cy += scale * cosf(time*0.2);
                    
                    v += sinf(sqrtf(cx*cx + cy*cy + 1.0)+time);
                    
                    //Set the R, G, B channels to the desired color
                    buffer[(y * bpr) + (componentsPerPixel*x)] = __uint8_t( max( Double(sinf( v * Float(M_PI) )) * Double(UINT8_MAX), 0) );
                    buffer[(y * bpr) + (componentsPerPixel*x)+1] = __uint8_t( max( Double(cosf( v * Float(M_PI) )) * Double(UINT8_MAX), 0) );
                    buffer[(y * bpr) + (componentsPerPixel*x)+2] = 0;
                }
            }
            //print(buffer)
            
            var newPixelBuffer: CVPixelBufferRef?
            var status = CVPixelBufferCreateWithBytes(kCFAllocatorDefault, bufferWidth, bufferHeight, kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange, buffer, bytesPerRow, nil, &newPixelBuffer, nil, &newPixelBuffer)
            
            if(status != kCVReturnSuccess) {
                NSLog("Failed to create buffer pixel");
            }
            
            
            CVPixelBufferLockBaseAddress(newPixelBuffer!, 0)
            
            let baseAddressNewPixel = CVPixelBufferGetBaseAddress(newPixelBuffer!)
            print("Base Address \(baseAddressNewPixel)")

            CVPixelBufferUnlockBaseAddress(newPixelBuffer!, 0)

            let dataSizeNewPixelBuffer = CVPixelBufferGetDataSize(newPixelBuffer!)
            print("Data size pixel buffer 2 \(dataSizeNewPixelBuffer)")
            
            var videoInfo: CMVideoFormatDescriptionRef?
            status = CMVideoFormatDescriptionCreateForImageBuffer(kCFAllocatorDefault, newPixelBuffer!, &videoInfo)
            
            print(videoInfo)
            
            var sampleTimingInfo = CMSampleTimingInfo()
            //status = CMSampleBufferGetSampleTimingInfo(<#T##sbuf: CMSampleBuffer##CMSampleBuffer#>, <#T##sampleIndex: CMItemIndex##CMItemIndex#>, <#T##timingInfoOut: UnsafeMutablePointer<CMSampleTimingInfo>##UnsafeMutablePointer<CMSampleTimingInfo>#>)
            
            status = CMSampleBufferGetSampleTimingInfo(sampleBuffer, 0, &sampleTimingInfo)
            
            if(status != kCVReturnSuccess) {
                NSLog("Failed to create timing ingo");
            }
            
            
            //print("Timing info \(sampleTimingInfo)")
            
            let dataSizeNewPixelBuffer2 = CVPixelBufferGetDataSize(newPixelBuffer!)
            print("Data size pixel buffer 2 \(dataSizeNewPixelBuffer2)")
            
            
            var newSampleBuffer: CMSampleBufferRef?
            status = CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault, newPixelBuffer!, true, nil, nil, videoInfo!, &sampleTimingInfo, &newSampleBuffer)
            
            if(status != kCVReturnSuccess) {
                NSLog("Failed to create CMSampleBuffer");
            }
            
            //status = CMSampleBufferCreateReadyWithImageBuffer(kCFAllocatorDefault, newPixelBuffer!, videoInfo!, &sampleTimingInfo, &newSampleBuffer)
            
            
            let dataSizeNewPixelBuffer3 = CVPixelBufferGetDataSize(newPixelBuffer!)
            print("Data size pixel buffer 2 \(dataSizeNewPixelBuffer3)")

            
            //print(newSampleBuffer)
 
            */
            
            
            
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                // do some task
                self.cloneBuffer(sampleBuffer!)
                dispatch_async(dispatch_get_main_queue(), {
                    // update some UI
                    });
                });
            
            
           
        }
        
        // OutputBytes
        // BytesPerRow
        // Output_Width
        // Output_Height
        //CVPixelBufferCreateWithBytes
        
        
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
