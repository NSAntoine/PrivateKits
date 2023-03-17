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
    /// The document represented as a `CGSVGDocumentRef`
    public var doc: CGSVGDocumentRef
    
    /// Whether or not to destroy the document with `CGSVGDocumentRelease` in the deinit.
    public var destroyUponDeinitialization: Bool = true
    
    /// Initializes a new instance with a given `CGSVGDocumentRef`
    public init(doc: CGSVGDocumentRef) {
        self.doc = doc
    }
    
    /// Initializes a new SVG Document with the given string representation
    convenience public init?(string: String) {
        guard let data = string.data(using: .utf8) else { return nil }
        self.init(data: data)
    }
    
    /// Initializes a new SVG Document with the given SVG file URL
    convenience public init(fileURL: URL) throws {
        self.init(data: try Data(contentsOf: fileURL))
    }
    
    
    public init(data: Data) {
        self.doc = CGSVGDocumentCreateFromData(data as CFData, nil)
    }
    
    #if canImport(UIKit)
    public func uiImage(configuration: ImageCreationConfiguration? = nil) -> UIImage {
        if let configuration = configuration {
            return UIImage(svgDocument: doc, scale: configuration.scale, orientation: configuration.orientation)
        }
        
        return UIImage(svgDocument: doc)
    }
    
    public struct ImageCreationConfiguration: Hashable {
        public let scale: CGFloat
        public let orientation: UIImage.Orientation
        
        public init(scale: CGFloat, orientation: UIImage.Orientation) {
            self.scale = scale
            self.orientation = orientation
        }
    }
    #endif
    
    public func write(to url: URL) {
        CGSVGDocumentWriteToURL(doc, url as CFURL, nil)
    }
    
    /// Writes the SVG Document to a given CGContext
    ///
    /// - Parameters:
    ///   - context: The CGContext to write to
    public func write(to context: CGContext) {
        CGContextDrawSVGDocument(context, doc)
    }
    
    /// A cross platform-compatible representation of this image as a CGImage.
    public func cgImage(withSize size: CGSize? = nil) -> CGImage? {
        let size = size ?? canvasSize
        let context = CGContext(data: nil,
                          width: Int(ceil(size.width)),
                          height: Int(ceil(size.height)),
                          bitsPerComponent: 8,
                          bytesPerRow: 0,
                          space: CGColorSpaceCreateDeviceRGB(),
                          bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        CGContextDrawSVGDocument(context, doc)
        return context?.makeImage()
    }
    
    /// The size of the document.
    public var canvasSize: CGSize {
        return CGSVGDocumentGetCanvasSize(doc)
    }
    
    deinit {
        if destroyUponDeinitialization {
            CGSVGDocumentRelease(doc)
        }
    }
}
