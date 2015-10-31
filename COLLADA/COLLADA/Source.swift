//
//  Source.swift
//  COLLADA
//
//  Created by Eryn Wells on 10/31/15.
//  Copyright © 2015 Eryn Wells. All rights reserved.
//

import Foundation
import Math

private enum Node: String {
    case Accessor = "accessor"
    case FloatArray = "float_array"
    case Source = "source"
    case TechniqueCommon = "technique_common"
}

enum SourceError: ErrorType {
    case MissingAccessor
}

protocol Source: SequenceType { }

class FloatSource: Object, Source {
    // TODO: When the Swift compiler gets its shit together and lets you throw from init() without all stored properties being initialized, change these to `let` and clean up the initializer.
    private var accessor: Accessor! = nil

    override init(element: NSXMLElement!) throws {
        try super.init(element: element)
        if let techniqueNode = element.elementsForName(Node.TechniqueCommon.rawValue).first,
            accessorNode = techniqueNode.elementsForName(Node.Accessor.rawValue).first {
            accessor = try Accessor(element: accessorNode)
        } else {
            throw SourceError.MissingAccessor
        }
    }
}

extension FloatSource: SequenceType {
    typealias Element = [String: Float]
    typealias Generator = AnyGenerator<[String: Float]>

    func generate() -> Generator {
        return anyGenerator { () -> Element? in
            return nil
        }
    }
}

class Vertices: Object {

}

class Accessor: Object {
    typealias Param = (name: String, type: String)

    enum Error: ErrorType {
        case MissingSource
        case MissingCount
        case MissingStride
        case MissingParamName
        case MissingParamType
    }

    // TODO: When the Swift compiler gets its shit together and lets you throw from init() without all stored properties being initialized, change these to `let` and clean up the initializer.
    private(set) var source: String! = nil
    private(set) var count: UInt! = nil
    private(set) var stride: UInt! = nil
    private(set) var params: [Param]! = nil

    override init(element: NSXMLElement!) throws {
        try super.init(element: element)

        source = element.stringValueForAttributeWithName("source")
        guard source != nil else { throw Error.MissingSource }

        count = element.unsignedIntValueForAttributeWithName("count")
        guard count != nil else { throw Error.MissingCount }

        stride = element.unsignedIntValueForAttributeWithName("stride")
        guard stride != nil else { throw Error.MissingStride }

        params = try element.elementsForName("param").map {
            let name = $0.stringValueForAttributeWithName("name")
            let type = $0.stringValueForAttributeWithName("type")
            guard name != nil else { throw Error.MissingParamName }
            guard type != nil else { throw Error.MissingParamType }
            return (name: name!, type: type!)
        }
    }
}