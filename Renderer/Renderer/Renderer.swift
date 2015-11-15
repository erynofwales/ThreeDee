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
    var bounds: CGRect { get }
}

public protocol FrameRenderer {
    func renderOntoSurface(surface: RenderingSurface, atTime time: FrameTimeStamp)
}