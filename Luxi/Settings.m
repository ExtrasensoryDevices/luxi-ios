//
//  Settings.m
//  Luxi
//
//  Created by Alina Kholcheva on 2013-10-09.
//  Copyright (c) 2013 Alina Kholcheva. All rights reserved.
//

#import "Settings.h"


@interface Settings(){
    
    
    BOOL                _luxiModeOn;
    BOOL                _showOnboarding;
    __strong NSNumber*  _calibrationEV;
    __strong NSNumber*  _calibrationLUX;
    
}
@end

NSString *const ShowOnboarding = @"showOnboarding";

NSString *const LuxiIsOn = @"luxiMode";

NSString *const Iso = @"Iso";
NSString *const Fstop = @"Fstop";
NSString *const Time = @"Time";

NSString *const CalibrationEV = @"CalibrationEV";
NSString *const CalibrationLUX = @"CalibrationLUX";


@implementation Settings


static Settings *settings = nil;




+ (Settings*)userSettings
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settings = [[Settings alloc] init];

    });
    return settings;
}

-(id)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:LuxiIsOn] == nil){
            [userDefaults setBool:YES forKey:LuxiIsOn];
            [userDefaults synchronize];
        }
        //TODO: remove this
//        [userDefaults setBool:YES forKey:ShowOnboarding];
        
        [userDefaults synchronize];
        if ([userDefaults objectForKey:ShowOnboarding] == nil){
            [userDefaults setBool:YES forKey:ShowOnboarding];
            [userDefaults synchronize];
        }
        _luxiModeOn = [userDefaults boolForKey:LuxiIsOn];
        _showOnboarding = [userDefaults boolForKey:ShowOnboarding];
        _iso = [userDefaults objectForKey:Iso];
        _fstop = [userDefaults objectForKey:Fstop];
        _time = [userDefaults objectForKey:Time];
        _calibrationEV = [userDefaults objectForKey:CalibrationEV];
        _calibrationLUX = [userDefaults objectForKey:CalibrationLUX];
    }
    return self;
}




-(BOOL) luxiModeOn
{
    @synchronized(self) {
        return _luxiModeOn;
    }
}

-(void)setLuxiModeOn:(BOOL)luxiMode
{
    @synchronized(self) {
        if (_luxiModeOn != luxiMode){
            _luxiModeOn = luxiMode;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:luxiMode forKey:LuxiIsOn];
            [userDefaults synchronize];
        }
    }
}


-(BOOL) showOnboarding
{
    @synchronized(self) {
        return _showOnboarding;
    }
}

-(void)setShowOnboarding:(BOOL)showOnboarding
{
    @synchronized(self) {
        if (_showOnboarding != showOnboarding){
            _showOnboarding = showOnboarding;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:showOnboarding forKey:ShowOnboarding];
            [userDefaults synchronize];
        }
    }
}





-(NSNumber*) calibrationEV
{
    @synchronized(self) {
        return _calibrationEV;
    }
}

-(void)setCalibrationEV:(NSNumber*)calibrationEV
{
    @synchronized(self) {
        if (_calibrationEV != calibrationEV){
            _calibrationEV = calibrationEV;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_calibrationEV forKey:CalibrationEV];
            [userDefaults synchronize];
        }
    }
}





-(NSNumber*) calibrationLUX
{
    @synchronized(self) {
        return _calibrationLUX;
    }
}

-(void)setCalibrationLUX:(NSNumber*)calibrationLUX
{
    @synchronized(self) {
        if (_calibrationLUX != calibrationLUX){
            _calibrationLUX = calibrationLUX;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_calibrationLUX forKey:CalibrationLUX];
            [userDefaults synchronize];
        }
    }
}


-(void)setFstop:(NSNumber*)fstop time:(NSNumber*) time iso:(NSNumber*) iso
{
    @synchronized(self) {
        _fstop = fstop;
        _time = time;
        _iso = iso;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:_fstop forKey:Fstop];
        [userDefaults setObject:_time forKey:Time];
        [userDefaults setObject:_iso forKey:Iso];
        [userDefaults synchronize];
    }
}



@end