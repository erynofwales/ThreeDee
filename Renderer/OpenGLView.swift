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

public class OpenGLView: NSOpenGLView {
    private var didSetupOpenGL = false
    private var displayLink: CVDisplayLink? = nil

    // TODO: Should this be weak?
    public var renderer: FrameRenderer? = nil

    override public func viewWillMoveToSuperview(newSuperview: NSView?) {
        if newSuperview != nil {
            setupOpenGL()
            startRenderingLoop()
        } else {
            stopRenderingLoop()
        }
    }

    private func setupOpenGL() {
        guard didSetupOpenGL else { return }
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
                result = self.renderAtTime(currentTime.memory)
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

    private func renderAtTime(time: CVTimeStamp) -> CVReturn {
        let context: NSOpenGLContext! = self.openGLContext

        guard context != nil else {
            // TODO: Throw an error? Log something?
            return kCVReturnError
        }
        guard renderer != nil else {
            // This is actually okay, we just don't render anything.
            return kCVReturnSuccess
        }

        context.makeCurrentContext()
        // TODO: OpenGLContext.clearCurrentContext()?

        CGLLockContext(context.CGLContextObj)
        defer { CGLUnlockContext(context.CGLContextObj) }

        // Render the frame.
        renderer!.renderAtTime(time)
        context.flushBuffer()

        return kCVReturnSuccess
    }
}