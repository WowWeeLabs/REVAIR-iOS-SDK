//
//  FreeFlightViewController.h
//  Sample Project
//
//  Created by David Chan on 17/3/2017.
//  Copyright © 2015 WowWee Group Limited. All rights reserved.
//

#import <WowWeeREVAirSDK/WowWeeREVAirSDK.h>
#import "JoystickView.h"

@interface FreeFlightViewController : UIViewController <REVAirDelegate, JoystickViewDelegate> {
    CGFloat             joystickBGWidth;
    kREVAirStatus         currentStatus;
    kREVAirLEDColor       lastTakeOffColor;
    NSTimer             *timer;
    int                 lastZ;
    int                 REVAirYAW;
    CFAbsoluteTime      lastGetStatusTimestamp;
}

@property(weak, nonatomic) IBOutlet JoystickView    *rightJoystick;
@property(weak, nonatomic) IBOutlet UIView          *joyStickRef;
@property(weak, nonatomic) IBOutlet UIImageView     *joystickBG;
@property(weak, nonatomic) IBOutlet UIImageView     *joystickBGAnimation;
@property(weak, nonatomic) IBOutlet UIButton        *takeOffLandBtn;
@property(weak, nonatomic) IBOutlet UIButton        *gunBtn;

@end
