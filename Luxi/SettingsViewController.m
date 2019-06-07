//
//  SettingsViewController.m
//  Luxi
//
//  Created by Alina Kholcheva on 2013-10-09.
//  Copyright (c) 2013 Alina Kholcheva. All rights reserved.
//

#import "SettingsViewController.h"
#import "Settings.h"
#import "SwitchCell.h"

@interface SettingsViewController ()

@property (strong, nonatomic) UITextView *footer;

@property (strong, nonatomic) UISwitch *spotMeteringSwitch;
@property (strong, nonatomic) UISwitch *instructionsSwitch;

@end


static NSString *SwitchCellReuseId = @"SwitchCellReuseId";
static NSString *SwitchCellNibName = @"SwitchCell";



@implementation SettingsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:SwitchCellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SwitchCellReuseId];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doneButtonClicked:(id)sender {
    if (self.settingsViewDelegate){
        
        Settings *settings = [Settings userSettings];
        
        // detect luxi
        BOOL newDetectLuxiValue = !self.spotMeteringSwitch.isOn;
        BOOL detectLuxiValueChanged = (settings.luxiModeOn != newDetectLuxiValue);
        if (detectLuxiValueChanged){
            settings.luxiModeOn = newDetectLuxiValue;
        }
        [self.settingsViewDelegate luxiModeDidChange:detectLuxiValueChanged];
        
        // instructions
        BOOL newShowInstructionsValue = self.instructionsSwitch.isOn;
        BOOL onboardingValueChanged = (settings.showOnboarding != newShowInstructionsValue);
        if (onboardingValueChanged){
            settings.showOnboarding = newShowInstructionsValue;
        }
        [self.settingsViewDelegate onboardingModeDidChange:onboardingValueChanged];
        
        // dismiss view
        [self.settingsViewDelegate dismissSettingsView];
    }
    
}


-(void)dealloc
{
    self.footer = nil;
    self.spotMeteringSwitch = nil;
    self.instructionsSwitch = nil;
}






#pragma mark - UITableViewDelegate/DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section <= 1 ? 1 : 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return @"SPOT METERING";
    } else if (section == 1){
        return @"INSTRUCTIONS";
    }
    return @"";
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 1 ? 60 : 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1){
        if (!self.footer){
            NSInteger margin = 20;
            CGRect frame = CGRectMake(0, 0, self.view.frame.size.width-2*margin, 60);
            
            self.footer = [[UITextView alloc] initWithFrame:frame];
            [_footer setEditable:NO];
            [_footer setTextAlignment:NSTextAlignmentCenter];
            [_footer setDataDetectorTypes:UIDataDetectorTypeLink];
            [_footer setBackgroundColor:[UIColor clearColor]];
            
            NSString *shortVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
//            NSString *buildVersionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
//            NSString *text = [NSString stringWithFormat:@"Version %@ (%@)", shortVersionString, buildVersionString];
            
            NSString *text = [NSString stringWithFormat:@"Version %@", shortVersionString];
            text = [text stringByAppendingFormat:@"\nhttps://www.luxiforall.com"];
            [_footer setText:text];
        }
        
        return self.footer;
    }
    return nil;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:SwitchCellReuseId];
    if (cell == nil) {
        cell = [[SwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SwitchCellReuseId];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0){
        // luxi detection
        cell.cellLabel.text = @"No Luxi";
        self.spotMeteringSwitch = cell.cellSwitch;
        [cell.cellSwitch setOn:![Settings userSettings].luxiModeOn animated:NO];
    } else if (indexPath.section == 1 && indexPath.row == 0){
        // show onboarding
        cell.cellLabel.text = @"Show instructions again";
        self.instructionsSwitch = cell.cellSwitch;
        [cell.cellSwitch setOn:[Settings userSettings].showOnboarding animated:NO];
    }
    return cell;
}


@end
