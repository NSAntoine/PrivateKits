//
//  SVGDocument.swift
//  
//
//  Created by Serena on 29/10/2022
//


@_exported
import CoreSVGBridge
import Foundation

public class SVGDocument {
    public var doc: CGSVGDocumentRef
    
    public init(doc: CGSVGDocumentRef) {
        self.doc = doc
    }
    
    convenience public init?(fileURL: URL) {
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        self.init(data: data)
    }
    
    public init(data: Data) {
        self.doc = CGSVGDocumentCreateFromData(data as CFData, nil)
    }
    
    #if canImport(UIKit)
    public var uiImage: UIImage? {
        return UIImage._image(with: doc, scale: UIScreen.main.scale, orientation: UIImage.Orientation.up.rawValue)
    }
    #endif
    
    deinit {
        CGSVGDocumentRelease(doc)
    }
}
