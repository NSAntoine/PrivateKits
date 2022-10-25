//
//  Header.h
//  
//
//  Created by Serena on 24/10/2022
//


#ifndef DIDeviceHandle_h
#define DIDeviceHandle_h

@import Foundation;

@interface DIDeviceHandle : NSObject
@property (retain, nonatomic) NSString * _Nonnull BSDName;
@property (readonly, nonatomic) NSUInteger regEntryID;
@property (nonatomic) BOOL handleRefCount;
@end

#endif /* DIDeviceHandle_h */
