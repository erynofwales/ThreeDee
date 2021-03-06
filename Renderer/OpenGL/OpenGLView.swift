//
//  OpenGLView.swift
//  OpenGLRenderer
//
//  Created by Eryn Wells on 11/12/15.
//  Copyright © 2015 Eryn Wells. All rights reserved.
//

import Foundation
import Cocoa
import GLKit
import CoreVideo

public class OpenGLView: NSOpenGLView {
    private var didSetupOpenGL = false
    private var displayLink: CVDisplayLink? = nil

    public var renderer: FrameRenderer? = nil

    deinit {
        stopRenderingLoop()
    }

    override public func prepareOpenGL() {
        super.prepareOpenGL()

        setupOpenGL()

        glClearColor(0.16, 0.17, 0.21, 1.0)
        glEnable(GLenum(GL_DEPTH_TEST))
        glDepthFunc(GLenum(GL_LESS))

        setupDisplayLink()
    }

    private func setupOpenGL() {
        guard !didSetupOpenGL else { return }
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

    private func setupDisplayLink() {
        var success = kCVReturnSuccess

        success = CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        guard success == kCVReturnSuccess && displayLink != nil else {
            // TODO: Throw an error?
            return
        }

        let unsafeSelf = UnsafeMutablePointer<Void>(unsafeAddressOf(self))
        success = CVDisplayLinkSetOutputCallback(displayLink!, displayLinkCallback, unsafeSelf)
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
    }

    private func startRenderingLoop() {
        guard displayLink != nil else { return }
        CVDisplayLinkStart(displayLink!)
    }

    private func stopRenderingLoop() {
        guard displayLink != nil else { return }
        CVDisplayLinkStop(displayLink!)
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
        renderer!.renderOntoSurface(self, atTime: time)
        context.flushBuffer()

        return kCVReturnSuccess
    }
}

extension OpenGLView: RenderingSurface {
    public func start() {
        startRenderingLoop()
    }

    public func stop() {
        stopRenderingLoop()
    }
}

private func displayLinkCallback(
    displayLink: CVDisplayLink,
    currentTime: UnsafePointer<CVTimeStamp>,
    outputTime: UnsafePointer<CVTimeStamp>,
    flags: CVOptionFlags,
    flagsOut: UnsafeMutablePointer<CVOptionFlags>,
    context: UnsafeMutablePointer<Void>) -> CVReturn
{
    var result = kCVReturnSuccess
    autoreleasepool {
        let glView = unsafeBitCast(context, OpenGLView.self)
        result = glView.renderAtTime(currentTime.memory)
    }
    return result
}