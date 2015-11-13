//
//  OpenGLView.swift
//  OpenGLRenderer
//
//  Created by Eryn Wells on 11/12/15.
//  Copyright © 2015 Eryn Wells. All rights reserved.
//

import Foundation
import Cocoa
import OpenGL
import CoreVideo

class OpenGLView: NSOpenGLView {
    private var didSetupOpenGL = false
    private var displayLink: CVDisplayLink? = nil

    override func viewWillMoveToSuperview(newSuperview: NSView?) {
        if newSuperview != nil {
            setupOpenGL()
            startRenderingLoop()
        } else {
            stopRenderingLoop()
        }
    }

    private func setupOpenGL() {
        if didSetupOpenGL {
            return
        }

        defer { didSetupOpenGL = true }

        let attrs = [NSOpenGLPFAAccelerated,
                     NSOpenGLPFADoubleBuffer,
                     NSOpenGLPFADepthSize, 24,
                     NSOpenGLPFAOpenGLProfile,
                     NSOpenGLProfileVersion4_1Core]

        let format = NSOpenGLPixelFormat(attributes: UnsafePointer<UInt32>(attrs))
        guard format != nil else {
            // TODO: Throw an error?
            return
        }
        
        let context = NSOpenGLContext(format: format!, shareContext: nil)
        guard context != nil else {
            // TODO: Throw an error?
            return
        }

        CGLEnable(context!.CGLContextObj, kCGLCECrashOnRemovedFunctions)

        pixelFormat = format
        openGLContext = context
        wantsBestResolutionOpenGLSurface = true
    }

    private func startRenderingLoop() {
        var success = kCVReturnSuccess

        success = CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        guard success == kCVReturnSuccess && displayLink != nil else {
            // TODO: Throw an error?
            return
        }

        success = CVDisplayLinkSetOutputHandler(displayLink!) {
            (displayLink: CVDisplayLink,
             currentTime: UnsafePointer<CVTimeStamp>,
             displayTime: UnsafePointer<CVTimeStamp>,
             optionsIn: CVOptionFlags,
             optionsOut: UnsafeMutablePointer<CVOptionFlags>) -> CVReturn in
            var result = kCVReturnSuccess
            autoreleasepool {
                result = self._renderAtTime(currentTime.memory)
            }
            return result
        }
        guard success == kCVReturnSuccess else {
            // TODO: Throw an error?
            return
        }

        if let context = self.openGLContext?.CGLContextObj, format = self.pixelFormat?.CGLPixelFormatObj {
            CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink!, context, format)
        } else {
            // TODO: Throw an error?
            return
        }

        CVDisplayLinkStart(displayLink!)
    }

    private func stopRenderingLoop() {
        guard displayLink != nil else { return }
        CVDisplayLinkStop(displayLink!)
        displayLink = nil
    }

    private func _renderAtTime(time: CVTimeStamp) -> CVReturn {
        return kCVReturnSuccess
    }
}