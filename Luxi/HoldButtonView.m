//
//  HoldButtonUIView.m
//  Luxi
//
//  Created by Alina on 2014-12-09.
//  Copyright (c) 2014 Owen Davis. All rights reserved.
//

#import "HoldButtonView.h"

@interface HoldButtonView() {
    UIColor *_selectedBgrColor;
    UIColor *_normalBgrColor;
    UIColor *_selectedFontColor;
    UIColor *_normalFontColor;
}

@property (weak, nonatomic) IBOutlet UILabel *label;

@end


@implementation HoldButtonView


-(void)awakeFromNib
{
    [super awakeFromNib];
    self.selected = NO;
    _selectedBgrColor = [[UIColor alloc]initWithRed:208 green:208 blue:208 alpha:1.0];
    _selectedFontColor = [UIColor whiteColor];
    _normalBgrColor = [UIColor whiteColor];
    _normalFontColor = [UIColor darkTextColor];
    
}


-(void)setSelected:(BOOL)selected
{
    if (_selected != selected){
        _selected = selected;
        [self updateButtonState];
    }
}


-(void)updateButtonState
{
    if (self.selected){
        //self.image.image = [self imageForState:UIControlStateSelected];
        self.backgroundColor = _selectedBgrColor;
        self.label.textColor = _selectedFontColor;
    } else { // consider state normal
        //self.image.image = [self imageForState:UIControlStateNormal];
        self.backgroundColor = _normalBgrColor;
        self.label.textColor = _normalFontColor;
    }
}




- (IBAction)didTapHoldButton:(id)sender {
    self.selected = !self.selected;
    if (self.delegate){
        [self.delegate didTapHoldButtonView:self];
    }
}




@end
