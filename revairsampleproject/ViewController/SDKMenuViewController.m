//
//  SDKMenuViewController.m
//  Sample Project
//
//  Created by David Chan on 17/3/2017.
//  Copyright © 2017 WowWee Group Limited. All rights reserved.
//

#import "SDKMenuViewController.h"
#import "FreeFlightViewController.h"

@implementation SDKMenuViewController

static SDKMenuViewController *_sdkMenuViewController = nil;

#pragma mark - Override Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sdkMenuViewController = self;
    
    [self.labelFirmware setText:[NSString stringWithFormat:@"Version: %@", @""]];
    
    self.arrLEDColor = [NSArray arrayWithObjects:@"Turn Off", @"Red", @"Green", @"Blue", @"Yellow", @"White", @"Purple", @"Orange", @"Cyan", @"Magenta", nil];
    
    
    self.arrSetting = @[@"Get Firmware", @"Get Battery Level", @"Set Wall Detection On/Off", @"Calibrate", @"Reset Calibration"];
    
    self.arrStunt = @[@"Take Off", @"kREVAirStuntYawBackAndForth", @"kREVAirStuntShortYawLeft", @"kREVAirStuntShortYawRight", @"kREVAirStuntShortThrustPulse", @"kREVAirStuntShortNegThrustPulse", @"kREVAirStuntWobbleRoll", @"kREVAirStuntWobblePitch", @"kREVAirStuntRollPitchL", @"kREVAirStuntRollPitchR", @"kREVAirStuntPitch", @"kREVAirStuntRoll", @"kREVAirStuntMoonWalk", @"kREVAirStuntSpiralUp", @"kREVAirStuntLeftFlip",@"kREVAirStuntSwayFrontBack", @"kREVAirStuntSwayLeftRight", @"kREVAirStuntZigZagUp", @"kREVAirStuntZigZagDown", @"kREVAirStuntSpiralDown", @"kREVAirStuntRightFlip", @"kREVAirStuntBackFlip", @"kREVAirStuntFrontFlip"];
    
    self.selectionMenuArray = @[@"Change LED color", @"Setting Features", @"Free Flight", @"Stunt (Beacon Mode)"];
    
    [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirGetFirmwareVersion];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.menuTable reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [[[REVAirFinder sharedInstance] firstConnectedREVAir] setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (timer == nil)
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(cycleProcessAction) userInfo:nil repeats:YES];
    
    stuntController = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!keepGetStatusRunning) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)cycleProcessAction {
    [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirGetStatus];
}

#pragma mark - ItemsSelectionTableViewCallback
- (void)viewController:(ItemsSelectionTableViewController *)controller didSelectRow:(int)selection Mode:(int)_mode {
    if ([[REVAirFinder sharedInstance] firstConnectedREVAir] != nil) {
        REVAir *robot = [[REVAirFinder sharedInstance] firstConnectedREVAir];
        robot.delegate = self;
        switch (_mode) {
            case ItemsSelectionTableViewControllerMode_LED:
                switch (selection) {
                    case kREVAirOff:
                        [robot REVAirSetLEDColor:kREVAirOff];
                        break;
                    case kREVAirRed:
                        [robot REVAirSetLEDColor:kREVAirRed];
                        break;
                    case kREVAirGreen:
                        [robot REVAirSetLEDColor:kREVAirGreen];
                        break;
                    case kREVAirBlue:
                        [robot REVAirSetLEDColor:kREVAirBlue];
                        break;
                    case kREVAirYellow:
                        [robot REVAirSetLEDColor:kREVAirYellow];
                        break;
                    case kREVAirWhite:
                        [robot REVAirSetLEDColor:kREVAirWhite];
                        break;
                    case kREVAirPurple:
                        [robot REVAirSetLEDColor:kREVAirPurple];
                        break;
                    case kREVAirOrange:
                        [robot REVAirSetLEDColor:kREVAirOrange];
                        break;
                    case kREVAirCyan:
                        [robot REVAirSetLEDColor:kREVAirCyan];
                        break;
                    case kREVAirMagenta:
                        [robot REVAirSetLEDColor:kREVAirMagenta];
                        break;
                    default:
                        break;
                }
                break;
            case ItemsSelectionTableViewControllerMode_Setting:
                switch (selection) {
                    case 0:
                        [robot REVAirGetFirmwareVersion];
                        break;
                    case 1:
                        [robot REVAirGetBattery];
                        break;
                    case 2:{
                        NSString *titleString = @"";
                        if (selection == 2)
                            titleString = @"Wall Detection";
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleString message:@"" preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"Disable" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            if (selection == 1) {
                                [robot REVAirSetWallDetectionModeOn:NO];
                                [robot REVAirGetWallDetectionMode];
                            }
                        }]];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"Enable" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            if (selection == 1) {
                                [robot REVAirSetWallDetectionModeOn:YES];
                                [robot REVAirGetWallDetectionMode];
                            }
                        }]];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                        break;
                    case 3:
                        [robot REVAirCalibrate];
                        break;
                    case 4:
                        [robot REVAirResetIRCalibration];
                        break;
                    default:
                        break;
                }
                break;
            case ItemsSelectionTableViewControllerMode_StuntSelection:
                switch (selection) {
                    case 0:
                        if (currentStatus == kREVAirStatusLanded) {
                            [robot REVAirLandOrTakeOff:kREVAirActionTakeOff height:120];
                            robot.REVAirtakeOffAndRejectCommand = YES;
                        }
                        else
                            [robot REVAirLandOrTakeOff:kREVAirActionLand height:0];
                        break;
                    default:
                        switch (selection-1) {
                            case kREVAirStuntYawBackAndForth:
                            case kREVAirStuntShortYawLeft:
                            case kREVAirStuntShortYawRight:
                                [robot REVAirPerformStunt:(kREVAirStuntByte)(selection-1) data1:0 data2:0];
                                break;
                            case kREVAirStuntShortThrustPulse: {
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"kREVAirStuntShortThrustPulse" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                                
                                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                    textField.placeholder = @"Intensity: (0-255)";
                                    textField.keyboardType = UIKeyboardTypeNumberPad;
                                }];
                                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                    textField.placeholder = @"Duration: 10ms (0-255)";
                                    textField.keyboardType = UIKeyboardTypeNumberPad;
                                }];
                                
                                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                }]];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"Fill Default Value" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    [robot REVAirPerformStunt:selection-1 data1:50 data2:50];
                                }]];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    NSString *intensityString = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
                                    NSString *durationString = ((UITextField *)[alertController.textFields objectAtIndex:1]).text;
                                    if (![intensityString isEqualToString:@""] && ![durationString isEqualToString:@""]) {
                                        if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[intensityString characterAtIndex:0]] &&
                                            [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[durationString characterAtIndex:0]]) {
                                            [robot REVAirPerformStunt:selection-1 data1:[intensityString intValue] data2:[durationString intValue]];
                                        }
                                    }
                                    
                                }]];
                                [self presentViewController:alertController animated:YES completion:nil];
                            }
                                break;
                            case kREVAirStuntShortNegThrustPulse: {
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"kREVAirStuntShortThrustPulse" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                                
                                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                    textField.placeholder = @"Duration: 10ms (0-255)";
                                    textField.keyboardType = UIKeyboardTypeNumberPad;
                                }];
                                
                                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                }]];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"Fill Default Value" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    [robot REVAirPerformStunt:selection-1 data1:0 data2:50];
                                }]];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    NSString *durationString = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
                                    if (![durationString isEqualToString:@""] && ![durationString isEqualToString:@""]) {
                                        if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[durationString characterAtIndex:0]]) {
                                            [robot REVAirPerformStunt:selection-1 data1:0 data2:[durationString intValue]];
                                        }
                                    }
                                    
                                }]];
                                [self presentViewController:alertController animated:YES completion:nil];
                            }
                                break;
                            case kREVAirStuntRollPitchL:
                            case kREVAirStuntRollPitchR:
                            case kREVAirStuntPitch:
                            case kREVAirStuntRoll: {
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"kREVAirStuntShortThrustPulse" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                                
                                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                    textField.placeholder = @"Degree: (-180-180)";
                                    textField.keyboardType = UIKeyboardTypeNumberPad;
                                }];
                                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                    textField.placeholder = @"Duration: 10ms (0-255)";
                                    textField.keyboardType = UIKeyboardTypeNumberPad;
                                }];
                                
                                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                }]];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"Fill Default Value" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    [robot REVAirPerformStunt:selection-1 data1:50 data2:50];
                                }]];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    NSString *intensityString = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
                                    NSString *durationString = ((UITextField *)[alertController.textFields objectAtIndex:1]).text;
                                    if (![intensityString isEqualToString:@""] && ![durationString isEqualToString:@""]) {
                                        if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[intensityString characterAtIndex:0]] &&
                                            [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[durationString characterAtIndex:0]]) {
                                            [robot REVAirPerformStunt:selection-1 data1:[intensityString intValue] data2:[durationString intValue]];
                                        }
                                    }
                                    
                                }]];
                                [self presentViewController:alertController animated:YES completion:nil];
                            }
                                break;
                            case kREVAirStuntWobbleRoll:
                            case kREVAirStuntWobblePitch:
                            case kREVAirStuntMoonWalk:
                            case kREVAirStuntSpiralUp:
                            case kREVAirStuntLeftFlip:
                            case kREVAirStuntSwayFrontBack:
                            case kREVAirStuntSwayLeftRight:
                            case kREVAirStuntZigZagUp:
                            case kREVAirStuntZigZagDown:
                            case kREVAirStuntSpiralDown:
                            case kREVAirStuntRightFlip:
                            case kREVAirStuntBackFlip:
                            case kREVAirStuntFrontFlip:
                                [robot REVAirPerformStunt:(kREVAirStuntByte)(selection-1) data1:0 data2:0];
                                break;
                            default:
                                break;
                        }
                        break;
                }
                break;
            default:
                break;
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.selectionMenuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* identifierString = @"TableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
    }
    
    [cell.textLabel setText:[self.selectionMenuArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    keepGetStatusRunning = NO;
    if (indexPath.row == SDKMenuMode_LED) {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ItemsSelectionTableViewController* controller = [sb instantiateViewControllerWithIdentifier:@"ItemsSelectionTableViewController"];
        controller.arrItems = self.arrLEDColor;
        controller.delegate = self;
        controller.mode = ItemsSelectionTableViewControllerMode_LED;
        [self.navigationController pushViewController:controller animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    else if (indexPath.row == SDKMenuMode_RemoteControl) {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FreeFlightViewController *controller = [sb instantiateViewControllerWithIdentifier:@"FreeFlightViewController"];
        [self.navigationController pushViewController:controller animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    else if (indexPath.row == SDKMenuMode_Setting) {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ItemsSelectionTableViewController* controller = [sb instantiateViewControllerWithIdentifier:@"ItemsSelectionTableViewController"];
        controller.arrItems = self.arrSetting;
        controller.delegate = self;
        controller.mode = ItemsSelectionTableViewControllerMode_Setting;
        [self.navigationController pushViewController:controller animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    else if (indexPath.row == SDKMenuMode_Stunt) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Stunt (Beacon Mode)" message:@"Please turn on REVAir Pod to play this mode." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            keepGetStatusRunning = YES;
            [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirSetLEDColor:kREVAirBlue];
            [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirSetCurrentBeaconMode:kREVAirBeaconModeOn];
            [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirSetFollowMeActivated:NO];
            [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirSetCurrentAltitudeMode:kREVAirAltitudeModeOn];
            UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            stuntController = [sb instantiateViewControllerWithIdentifier:@"ItemsSelectionTableViewController"];
            stuntController.arrItems = self.arrStunt;
            stuntController.delegate = self;
            stuntController.mode = ItemsSelectionTableViewControllerMode_StuntSelection;
            [self.navigationController pushViewController:stuntController animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark - REVAirDelegate
- (void)REVAir:(id)REVAir didReceiveFirmwareVersionHigh:(int)versionHigh low:(int)versionLow {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Firmware" message:[NSString stringWithFormat:@"%d.%d", versionHigh, versionLow] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    [self.labelFirmware setText:[NSString stringWithFormat:@"Version: %@", [NSString stringWithFormat:@"%d.%d", versionHigh, versionLow]]];
}

- (void)REVAir:(id)REVAir didReceiveWallDetectiobMode:(BOOL)isWallDetectionOn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wall Detection" message:[NSString stringWithFormat:@"%@", isWallDetectionOn?@"YES":@"NO"] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)REVAir:(id)REVAir didReceiveCrashDetectiobMode:(BOOL)isCrashDetectionOn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Crash Detection" message:[NSString stringWithFormat:@"%@", isCrashDetectionOn?@"YES":@"NO"] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)REVAir:(id)REVAir didReceiveStallDetectiobMode:(BOOL)isStallDetectionOn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Stall Detection" message:[NSString stringWithFormat:@"%@", isStallDetectionOn?@"YES":@"NO"] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)REVAirDidCalibrated:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Calibration" message:@"Success" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)REVAir:(id)REVAir didResetIRCalibration:(BOOL)isSuccessReset {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reset Calibration" message:isSuccessReset?@"Success":@"Fail" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)REVAir:(id)REVAir didReceiveBatteryLevel:(int)batteryLevel {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Battery Level" message:[NSString stringWithFormat:@"%d", batteryLevel] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - REVAirDelegate
-(void)REVAir:(id)REVAir didReceiveStatus:(kREVAirStatus)REVAirStatus
{
    currentStatus = REVAirStatus;
    if (currentStatus == kREVAirStatusLanded)
    {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.arrStunt];
        [arr replaceObjectAtIndex:0 withObject:@"Take Off"];
        stuntController.arrItems = arr;
        [stuntController.tableView reloadData];
    }else
    {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.arrStunt];
        [arr replaceObjectAtIndex:0 withObject:@"Stop"];
        stuntController.arrItems = arr;
        [stuntController.tableView reloadData];
    }
}

-(void)REVAirDidNotifyFirstSonar:(id)REVAir
{
    [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirGoToPosition:0 y:0 z:[[REVAirFinder sharedInstance] firstConnectedREVAir].stuntZ];
    [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirSetLEDColor:kREVAirGreen];
    [[REVAirFinder sharedInstance] firstConnectedREVAir].REVAirtakeOffAndRejectCommand = NO;
}

@end
