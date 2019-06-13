//
//  ScreenSizeClass.m
//  Luxi
//
//  Created by Alina Kholcheva on 2019-05-18.
//  Copyright © 2019 Alina Kholcheva. All rights reserved.
//

#import "ScreenSizeClass.h"


@implementation ScreenSizeClass

+(ScreenSize) phoneSize {
    NSInteger screenHeight = MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    NSInteger screenWidth = MIN(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    
    ScreenSize size;
    switch (screenHeight) {
        case   0 ... 480 : size = ScreenSizePhone3_5inch; break;
        case 481 ... 568 : size = ScreenSizePhone4inch;   break;
        case 569 ... 667 : size = ScreenSizePhone4_7inch; break;
        case 668 ... 736 : size = ScreenSizePhone5_5inch; break;
        case 737 ... 812 : size = ScreenSizePhone5_8inch; break;
        case 813 ... 896 : size = ScreenSizePhone6_5inch; break;
        default : size = ScreenSizeIPad;
    }
    
    NSString *sizeStr = [ScreenSizeClass description:size];
    NSLog(@"%@: (%zd, %zd), resolution: %f", sizeStr, screenWidth, screenHeight, UIScreen.mainScreen.scale);
    return size;
}

+(NSString*) description:(ScreenSize) size {
    switch (size) {
        case ScreenSizePhone3_5inch: return @"ScreenSizePhone3_5inch"; break;
        case ScreenSizePhone4inch:   return @"ScreenSizePhone4inch";   break;
        case ScreenSizePhone4_7inch: return @"ScreenSizePhone4_7inch"; break;
        case ScreenSizePhone5_5inch: return @"ScreenSizePhone5_5inch"; break;
        case ScreenSizePhone5_8inch: return @"ScreenSizePhone5_8inch"; break;
        case ScreenSizePhone6_5inch: return @"ScreenSizePhone6_5inch"; break;
        case ScreenSizeIPad:         return @"ScreenSizeIPad";         break;
    }
}

// Expected: full screen size
//ScreenSizePhone3_5inch, // 320 x 480: iPhone 4
//ScreenSizePhone4inch,   // 320 x 568: iPhone 5
//ScreenSizePhone4_7inch, // 375 x 667: iPhones 6, 7, 8, iPad Pro 12.9"
//ScreenSizePhone5_5inch, // 414 x 736: iPhones 6+, 7+, 8+
//ScreenSizePhone5_8inch, // 375 x 812: iPhones X, XS
//ScreenSizePhone6_5inch, // 414 x 896: iPhones XS Max, XR
//ScreenSizeIPad

@end
