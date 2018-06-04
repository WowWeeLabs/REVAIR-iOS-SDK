//
//  FlightViewController.m
//  Sample Project
//
//  Created by David Chan on 17/3/2017.
//  Copyright © 2017 WowWee Group Limited. All rights reserved.
//

#import "FreeFlightViewController.h"

@implementation FreeFlightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentStatus = kREVAirStatusLanded;
    lastGetStatusTimestamp = CFAbsoluteTimeGetCurrent();
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(cycle) userInfo:nil repeats:YES];
    [self.rightJoystick setDelegate:self];
    [self.rightJoystick setJoystickCenterImage:@"joystick_right_centre.png" frameImage:@"joystick_bg.png"];
    [[REVAirFinder sharedInstance] firstConnectedREVAir].delegate = self;
    [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirSetWallDetectionModeOn:YES];
    [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirSetFollowMeActivated:NO];
    [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirSetCurrentBeaconMode:kREVAirBeaconModeOff];
    [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirSetCurrentAltitudeMode:kREVAirAltitudeModeOn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [timer invalidate];
}

#pragma mark - private
- (void)cycle {
    if (CFAbsoluteTimeGetCurrent()-lastGetStatusTimestamp > 0.5f) {
        [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirGetStatus];
        lastGetStatusTimestamp = CFAbsoluteTimeGetCurrent();
    }
    
    int pitch  = [[REVAirFinder sharedInstance] firstConnectedREVAir].stuntY;
    int roll  = [[REVAirFinder sharedInstance] firstConnectedREVAir].stuntX;
    [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirFreeFlightWithThrust:0 yaw:REVAirYAW pitch:pitch roll:roll];
    REVAirYAW = 0;
    
    [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirGoToPosition:0 y:0 z:[[REVAirFinder sharedInstance] firstConnectedREVAir].stuntZ];
}

#pragma mark - IBAction Methods
- (IBAction)upAction:(id)sender {
    int increment = 5;
    [[REVAirFinder sharedInstance] firstConnectedREVAir].stuntZ += increment;
    float maxHeight = 130;
    if ([[REVAirFinder sharedInstance] firstConnectedREVAir].stuntZ > maxHeight) {
        [[REVAirFinder sharedInstance] firstConnectedREVAir].stuntZ = maxHeight;
    }
}

- (IBAction)downAction:(id)sender {
    int increment = 5;
    [[REVAirFinder sharedInstance] firstConnectedREVAir].stuntZ -= increment;
    float minHeight = 60;
    if ([[REVAirFinder sharedInstance] firstConnectedREVAir].stuntZ < minHeight) {
        [[REVAirFinder sharedInstance] firstConnectedREVAir].stuntZ = minHeight;
    }
}

- (IBAction)leftAction:(id)sender {
    REVAirYAW = 2000;
}

- (IBAction)rightAction:(id)sender {
    REVAirYAW = -2000;
}

- (IBAction)forceLandAction:(id)sender {
    [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirStop];
}

#pragma mark - JoystickDelegate
- (void)joystickUpdate:(JoystickView *)joystick vector:(CGVector)vector {
    [[REVAirFinder sharedInstance] firstConnectedREVAir].stuntX = (int)(vector.dx * 450);
    [[REVAirFinder sharedInstance] firstConnectedREVAir].stuntY = (int)(vector.dy * 450);
    
}

- (void)joystickActive: (JoystickView *)joystick {

    [self.joystickBGAnimation setHidden:true];
    [self.joystickBG setHidden:false];
    
    //[joystick_animation invalidate];
    
    self.joystickBG.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.joystickBG.transform = CGAffineTransformScale(self.joystickBG.transform, joystick.frame.size.width /joystickBGWidth, joystick.frame.size.width /joystickBGWidth);
        
    }];
}

- (void)joystickInactive: (JoystickView *)joystick {
    // self.joystickBG.hidden = true;
    [UIView animateWithDuration:0.3 animations:^{
        self.joystickBG.transform =CGAffineTransformScale(self.joystickBG.transform, joystickBGWidth/joystick.frame.size.width, joystickBGWidth/joystick.frame.size.width);
        
    } completion:^(BOOL finished) {
        self.joystickBG.transform = CGAffineTransformIdentity;
        //[self startJoystickAnimation];
    }];
    
    
}

#pragma mark - IBAction
-(IBAction)takeOffLand:(id)sender {
    REVAirYAW = 0;
    if (currentStatus == kREVAirStatusLanded) {
        [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirSetLEDColor:kREVAirWhite];
        [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirLandOrTakeOff:kREVAirActionTakeOff height:60];
        [[REVAirFinder sharedInstance] firstConnectedREVAir].REVAirtakeOffAndRejectCommand = YES;
        
    }else {
        [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirLandOrTakeOff:kREVAirActionLand height:0];
    }
}

-(IBAction)sendGunCommand:(id)sender {
    [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirSendIRCommand:1 direction:kREVAirIRAll];
}

#pragma mark - REVAirDelegate
-(void)REVAir:(id)REVAir didReceiveStatus:(kREVAirStatus)REVAirStatus {
    currentStatus = REVAirStatus;
    if (currentStatus == kREVAirStatusLanded) {
        [_takeOffLandBtn setTitle:@"Take Off" forState:UIControlStateNormal];
    }else {
        [_takeOffLandBtn setTitle:@"Land" forState:UIControlStateNormal];
    }
}


-(void)REVAirDidNotifyFirstSonar:(id)REVAir {
    [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirSetLEDColor:kREVAirPurple];
    [[REVAirFinder sharedInstance] firstConnectedREVAir].REVAirtakeOffAndRejectCommand = NO;
    [[[REVAirFinder sharedInstance] firstConnectedREVAir] REVAirGoToPosition:0 y:0 z:[[REVAirFinder sharedInstance] firstConnectedREVAir].stuntZ];
}

-(void)REVAir:(id)REVAir didErrorNotify:(kREVAirNotifyError)errorType {
    
    NSString * errorString;
    switch (errorType) {
        case kREVAirCrash:
            errorString = @"kREVAirCrash";
            break;
        case kREVAirStall:
            errorString = @"kREVAirStall";
            break;
        case kREVAirBeaconTimeout:
            errorString = @"kREVAirBeaconTimeout";
            break;
        case kREVAirBLETimeout:
            errorString = @"kREVAirBLETimeout";
            break;
        case kREVAirSonarTimeout:
            errorString = @"kREVAirSonarTimeout";
            break;
        case kREVAirSonarStep:
            errorString = @"kREVAirSonarStep";
            break;
        case kREVAirTakeoffOnBadFloor:
            errorString = @"kREVAirTakeoffOnBadFloor";
            break;
            
        default:
            errorString = [NSString stringWithFormat:@"%d",errorType];
            break;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:errorString preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)REVAir:(id)REVAir didReceiveIRCommand:(uint8_t)gunShotID RX:(kRevAirRXDirection)rxDirection {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Receive Gun Shot From REV Car" message:[NSString stringWithFormat:@"%d, %d", gunShotID, rxDirection] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
