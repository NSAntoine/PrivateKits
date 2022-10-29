//
//  CoreSVG.h
//  
//
//  Created by Serena on 29/10/2022
//
	

#import <UIKit/UIKit.h>

#ifndef CoreSVG_h
#define CoreSVG_h

struct CGSVGDocument;

typedef struct CGSVGDocument *CGSVGDocumentRef;

CGSVGDocumentRef CGSVGDocumentCreateFromData(CFDataRef, CFDictionaryRef);
void CGContextDrawSVGDocument(CGContextRef, CGSVGDocumentRef);
CGSize CGSVGDocumentGetCanvasSize(CGSVGDocumentRef);

CGSVGDocumentRef CGSVGDocumentRetain(struct CGSVGDocument);
void CGSVGDocumentRelease(CGSVGDocumentRef);

// UIImage init from a SVG doc
@interface UIImage (CoreSVGPrivate)
+(instancetype)_imageWithCGSVGDocument:(struct CGSVGDocument *)arg0 scale:(CGFloat)arg1 orientation:(NSInteger)arg2;
-(IOSurfaceRef)_copyIOSurface;
@end

CGImageRef UICreateCGImageFromIOSurface(IOSurfaceRef ioSurface);

#endif /* CoreSVG_h */
