//
//  ScreenSizeClass.h
//  Luxi
//
//  Created by Alina Kholcheva on 2019-05-18.
//  Copyright © 2019 Alina Kholcheva. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ScreenSizePhone3_5inch, // 320 x 480: iPhone 4, iPads except iPad Pro 12.9
    ScreenSizePhone4inch,   // 320 x 568: iPhone 5
    ScreenSizePhone4_7inch, // 375 x 667: iPhones 6, 7, 8, iPad Pro 12.9"
    ScreenSizePhone5_5inch, // 414 x 736: iPhones 6+, 7+, 8+
    ScreenSizePhone5_8inch, // 375 x 812: iPhones X, XS
    ScreenSizePhone6_5inch, // 414 x 896: iPhones XS Max, XR
    ScreenSizeIPad
} ScreenSize;

@interface ScreenSizeClass : NSObject

+(ScreenSize) phoneSize;

@end


// Expected: full screen size
//ScreenSizePhone3_5inch, // 320 x 480: iPhone 4, iPads except iPad Pro 12.9
//ScreenSizePhone4inch,   // 320 x 568: iPhone 5
//ScreenSizePhone4_7inch, // 375 x 667: iPhones 6, 7, 8, iPad Pro 12.9"
//ScreenSizePhone5_5inch, // 414 x 736: iPhones 6+, 7+, 8+
//ScreenSizePhone5_8inch, // 375 x 812: iPhones X, XS
//ScreenSizePhone6_5inch, // 414 x 896: iPhones XS Max, XR
//ScreenSizeIPad


// Reality: app does not take full screen on the borderless X-type phones
// xr 736
// xs max 736
