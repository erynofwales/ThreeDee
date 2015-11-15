//
//  Renderer.swift
//  Renderer
//
//  Created by Eryn Wells on 11/14/15.
//  Copyright © 2015 Eryn Wells. All rights reserved.
//

import CoreVideo

public typealias FrameTimeStamp = CVTimeStamp

public protocol RenderingSurface {
    /// Bounds in pixels of this surface.
    var bounds: CGRect { get }

    /// Start the rendering loop for this surface.
    func start()
    /// Stop the rendering loop for this surface.
    func stop()
}

public protocol FrameRenderer {
    func renderOntoSurface(surface: RenderingSurface, atTime time: FrameTimeStamp)
}