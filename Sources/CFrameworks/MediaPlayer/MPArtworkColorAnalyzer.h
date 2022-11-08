//
//  MPArtworkColorAnalyzer.h
//  
//
//  Created by Serena on 09/11/2022
//
	

#ifndef MPArtworkColorAnalyzer_h
#define MPArtworkColorAnalyzer_h

#if __has_include(<UIKit/UIKit.h>)
@import MediaPlayer;

@interface MPArtworkColorAnalyzer : NSObject {

    long long _algorithm;
    UIImage* _image;

}

@property (nonatomic,readonly) long long algorithm;
@property (nonatomic,readonly) UIImage * image;

-(long long)algorithm;
-(UIImage *)image;
-(instancetype)initWithImage:(UIImage *)arg1 algorithm:(long long)arg2 ;
-(void)analyzeWithCompletionHandler:(/*^block*/id)arg1 ;
-(id)_fallbackColorAnalysis;
@end

#endif


#endif /* MPArtworkColorAnalyzer_h */
