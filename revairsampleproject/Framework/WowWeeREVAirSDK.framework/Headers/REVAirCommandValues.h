//
//  REVAirCommandValues.h
//  WowWeeREVAirPODSDK
//
//  Created by David Chan on 28/3/2017.
//  Copyright © 2017 WowWee. All rights reserved.
//

#import <Foundation/Foundation.h>

// Battery Level Calculations
#define BATTERY_VALUE_TO_VOLTAGE(x)    (x/256.0f*1.2f*3*4.2f) // (x/256.0f*1.2f*3*3.8f)//
#define BATTERY_MAX 3.7f//4.2f
#define BATTERY_MIN 2.5f//3.4f
#define BATTERY_ROUNDTOZERO(voltage)    fabs((fmin(BATTERY_MAX, voltage) - BATTERY_MIN))

typedef enum :int
{
    kREVAirOff = 0,
    kREVAirRed,
    kREVAirGreen,
    kREVAirBlue,
    kREVAirYellow,
    kREVAirWhite,
    kREVAirPurple,
    kREVAirOrange,
    kREVAirCyan,
    kREVAirMagenta
}
kREVAirLEDColor;

typedef enum : uint8_t {
    kREVAirDirectionLeft = 0x00,
    kREVAirDirectionRight = 0x01,
} kREVAirDirection;

typedef enum : uint8_t {
    kREVAirSpeedLevel1 = 0x00,
    kREVAirSpeedLevel2,
    kREVAirSpeedLevel3,
    kREVAirSpeedLevel4
} kREVAirSpeed;

typedef enum : uint8_t {
    kREVAirActionLand = 0x00,
    kREVAirActionTakeOff = 0x01,
} kREVAirLandOrTakeOffAction;

typedef enum : uint8_t {
    kREVAirStuntYawBackAndForth = 0x00,
    kREVAirStuntShortYawLeft = 0x01,
    kREVAirStuntShortYawRight = 0x02,
    kREVAirStuntShortThrustPulse = 0x03, //intensity,	Length in intervals of 10ms
    kREVAirStuntShortNegThrustPulse = 0x04, //NULL	Length in intervals of 10ms
    kREVAirStuntWobbleRoll = 0x05,
    kREVAirStuntWobblePitch = 0x06,
    kREVAirStuntRollPitchL = 0x07, //angle in degrees (signed),	Length in intervals of 10ms
    kREVAirStuntRollPitchR = 0x08, //angle in degrees (signed),	Length in intervals of 10ms
    kREVAirStuntPitch = 0x09, //angle in degrees (signed),	Length in intervals of 10ms
    kREVAirStuntRoll = 0x0a, //angle in degrees (signed),	Length in intervals of 10ms
    kREVAirStuntMoonWalk = 0x0b,
    kREVAirStuntSpiralUp= 0x0c,
    kREVAirStuntLeftFlip = 0x0d,
    kREVAirStuntSwayFrontBack = 0x0e,
    kREVAirStuntSwayLeftRight = 0x0f,
    kREVAirStuntZigZagUp = 0x10,
    kREVAirStuntZigZagDown = 0x11,
    kREVAirStuntSpiralDown = 0x12,
    kREVAirStuntRightFlip = 0x13,
    kREVAirStuntBackFlip = 0x14,
    kREVAirStuntFrontFlip = 0x15,
} kREVAirStuntByte;

typedef enum : uint8_t {
    kREVAirStatusLanded = 0x00,
    kREVAirStatusFlying = 0x01,
    kREVAirStatusCrashed = 0x02,
} kREVAirStatus;

typedef enum : uint8_t {
    kREVAirBeaconModeOff = 0x00,
    kREVAirBeaconModeOn = 0x01,
} kREVAirBeaconMode;

typedef enum : uint8_t {
    kREVAirAltitudeModeOff = 0x00,
    kREVAirAltitudeModeOn = 0x01,
} kREVAirAltitudeMode;

typedef enum : uint8_t {
    kREVAirBackWall = 0x00,
    kREVAirLeftWall = 0x01,
    kREVAirFrontWall = 0x02,
    kREVAirRightWall = 0x03,
} kREVAirWallDirection;

typedef enum : uint8_t {
    kREVAirCrash = 0x00,
    kREVAirStall = 0x01,
    kREVAirBeaconTimeout = 0x02,
    kREVAirBLETimeout = 0x03,
    kREVAirSonarTimeout = 0x04,
    kREVAirSonarStep = 0x05,
    kREVAirTakeoffOnBadFloor = 0x06,
} kREVAirNotifyError;

typedef enum : uint8_t {
    kREVAirIRAll = 0x00,
    kREVAirIRLeft = 0x01,
    kREVAirIRRight = 0x02,
    kREVAirIRFront = 0x03,
    kREVAirIRBack = 0x04,
} kREVAirIRDirection;

typedef enum : uint8_t {
    kRevAirRXFrontLeft = 0x00,
    kRevAirRXFrontRight = 0x01,
    kRevAirRXBackRight = 0x02,
    kRevAirRXBackLeft = 0x03,
    kRevAirRXBOT = 0x04,
} kRevAirRXDirection;

@interface REVAirCommandValues : NSObject

@end

