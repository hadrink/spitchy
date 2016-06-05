//
//  Preview.swift
//  Spitchy
//
//  Created by Rplay on 05/06/16.
//  Copyright © 2016 rplay. All rights reserved.
//

import Foundation
import AVFoundation

class Preview {
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    func createPreview(size: CGSize, session: AVCaptureSession) -> AVCaptureVideoPreviewLayer? {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        print(size)
        previewLayer?.frame.size = size
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
        
        return previewLayer
    }
}

