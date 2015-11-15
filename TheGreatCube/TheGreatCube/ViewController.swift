//
//  ViewController.swift
//  TheGreatCube
//
//  Created by Eryn Wells on 11/14/15.
//  Copyright © 2015 Eryn Wells. All rights reserved.
//

import Cocoa
import Renderer

class ViewController: NSViewController {
    @IBOutlet var glView: OpenGLView!
    let renderer = FrameRenderer()

    override func viewDidLoad() {
        super.viewDidLoad()
        glView.renderer = renderer
    }
}


class FrameRenderer: Renderer.FrameRenderer {
    func renderAtTime(time: FrameTimeStamp) {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
    }
}