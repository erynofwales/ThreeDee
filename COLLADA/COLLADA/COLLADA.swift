//
//  COLLADA.swift
//  COLLADA
//
//  Created by Eryn Wells on 10/29/15.
//  Copyright © 2015 Eryn Wells. All rights reserved.
//

import Foundation

private enum Node: String {
    case Geometry = "geometry"
    case LibraryGeometries = "library_geometries"
    case Vertices = "vertices"
}

public class Scene: Object {
    public enum Error: ErrorType {
        case MissingRootElement
    }

    private let document: NSXMLDocument

    public lazy var geometries: [Geometry] = {
        do {
            return try self.xml.elementsForName(Node.LibraryGeometries.rawValue).flatMap {
                try $0.elementsForName(Node.Geometry.rawValue).map {
                    try Geometry(element: $0)
                }
            }
        } catch {
            return []
        }
    }()

    init(document: NSXMLDocument) throws {
        self.document = document
        if let root = document.rootElement() {
            try super.init(element: root)
        } else {
            try super.init(element: nil)
            throw Error.MissingRootElement
        }
    }
}

public class Geometry: Object {
}

public class Mesh: Object {
    private lazy var vertices: NSXMLElement! = {
        return self.xml.elementsForName("vertices").first
    }()
}

public class Polygons: Object {

}

public class Object {
    public enum Error: ErrorType {
        case MissingElement
        case MultipleElementsWithSameID
    }

    // TODO: When the Swift compiler gets its shit together and lets you throw from init() without all stored properties being initialized, change these to `let` and clean up the initializer.
    public private(set) var elements = [NSXMLElement]()
    public private(set) var elementsByID = [String: NSXMLElement]()

    let xml: NSXMLElement!

    init(element: NSXMLElement!) throws {
        xml = element
        guard xml != nil else { throw Error.MissingElement }

        for node in element.children ?? [] {
            if node.kind != .ElementKind {
                continue
            }
            if let element = node as? NSXMLElement {
                elements.append(element)
            }
        }

        for element in elements {
            if let id = element.attributeForName("id")?.stringValue {
                if elementsByID[id] != nil {
                    throw Error.MultipleElementsWithSameID
                }
                elementsByID[id] = element
            }
        }
    }

    public var id: String? {
        return xml.attributeForName("id")?.stringValue
    }

    public var name: String? {
        return xml.attributeForName("name")?.stringValue
    }

    private func idWithoutHash(id: String) -> String {
        if id.hasPrefix("#") {
            let indexAfterHash = id.startIndex.advancedBy(1)
            return id.substringFromIndex(indexAfterHash)
        } else {
            return id
        }
    }
}

extension NSXMLElement {
    func stringValueForAttributeWithName(name: String) -> String? {
        if let value = self.attributeForName(name)?.stringValue {
            return value
        } else {
            return nil
        }
    }

    func unsignedIntValueForAttributeWithName(name: String) -> UInt? {
        if let value = stringValueForAttributeWithName(name) {
            return UInt(value)
        } else {
            return nil
        }
    }
}