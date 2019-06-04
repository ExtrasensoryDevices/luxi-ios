//
//  SettingsViewController.h
//  Luxi
//
//  Created by Alina Kholcheva on 2013-10-09.
//  Copyright (c) 2013 Alina Kholcheva. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol SettingsViewDelegate <NSObject>
- (void) luxiModeDidChange:(BOOL) changed;
- (void) onboardingModeDidChange:(BOOL) changed;
- (void) dismissSettingsView;
@end


@interface SettingsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) id<SettingsViewDelegate> settingsViewDelegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)doneButtonClicked:(id)sender;

@end
