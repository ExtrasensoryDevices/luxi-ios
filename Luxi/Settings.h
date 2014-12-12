//
//  Settings.h
//  Luxi
//
//  Created by Alina Kholcheva on 2013-10-09.
//  Copyright (c) 2013 Alina Kholcheva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject 

+ (Settings*)userSettings;

@property (atomic) BOOL luxiModeOn;

@property (atomic) BOOL showOnboarding;

@property (atomic) NSNumber *calibrationEV;
@property (atomic) NSNumber *calibrationLUX;

@property (atomic, readonly) NSNumber *fstop;
@property (atomic, readonly) NSNumber *time;
@property (atomic, readonly) NSNumber *iso;


-(void)setFstop:(NSNumber*)fstop time:(NSNumber*) time iso:(NSNumber*) iso;

@end
