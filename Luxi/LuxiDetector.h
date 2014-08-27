//
//  ImageHelper.h
//  Luxi
//
//  Created by Alina Kholcheva on 2013-10-07.
//  Copyright (c) 2013 Alina Kholcheva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface LuxiDetector : NSObject

+(BOOL) isLuxiOn:(CMSampleBufferRef) sampleBuffer;



@end
