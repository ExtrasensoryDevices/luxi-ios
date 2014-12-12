//
//  HoldButtonUIView.h
//  Luxi
//
//  Created by Alina on 2014-12-09.
//  Copyright (c) 2014 Owen Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HoldButtonView;

@protocol HoldButtonViewDelegate <NSObject>

-(void)didTapHoldButtonView:(HoldButtonView *)button;

@end


@interface HoldButtonView : UIView

@property (nonatomic, weak) NSObject<HoldButtonViewDelegate> *delegate;
@property (nonatomic) BOOL selected;



@end
