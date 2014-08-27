//
//  SwitchCell.h
//  Luxi
//
//  Created by Alina Kholcheva on 2013-10-29.
//  Copyright (c) 2013 Alina Kholcheva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;

@end
