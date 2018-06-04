//
//  REVAir.h
//  WowWeeREVAirPODSDK
//
//  Created by David Chan on 28/3/2017.
//  Copyright © 2017 WowWee. All rights reserved.
//

#import "BluetoothRobot.h"
#import "REVAirCommandValues.h"

@class REVAir;
#pragma mark - REVAirDelegate
@protocol REVAirDelegate <NSObject>

@optional
- (void)REVAirDeviceConnected:(REVAir *)REVAir;
- (void)REVAirDeviceReady:(REVAir *)REVAir;
- (void)REVAirDeviceDisconnected:(REVAir *)REVAir cleanly:(bool)cleanly;
- (void)REVAirDeviceFailedToConnect:(REVAir *)REVAir error:(NSError *)error;
- (void)REVAirDeviceDidReceivedRawData:(REVAir *)REVAir data:(NSData*)data;

/**REVAir device call back **/
- (void)REVAir:(id)REVAir didReceiveBatteryLevel:(int)batteryLevel;
- (void)REVAir:(id)REVAir didReceiveStatus:(kREVAirStatus)REVAirStatus;
- (void)REVAirDidCalibrated:(id)sender;
- (void)REVAir:(id)REVAir didReceiveCurrentBeaconMode:(kREVAirBeaconMode)beaconMode;
- (void)REVAir:(id)REVAir didReceiveCurrentAltitudeMode:(kREVAirAltitudeMode)altitudeMode;
- (void)REVAir:(id)REVAir didReceiveIRSignalStrength:(int)strength;
- (void)REVAir:(id)REVAir didReceivePositionX:(int)posX Y:(int)posY Z:(int)posZ;
- (void)REVAir:(id)REVAir didReceiveCurrentEstimatedPositionX:(int)posX Y:(int)posY Z:(int)posZ;
- (void)REVAir:(id)REVAir didReceiveIRCommand:(uint8_t)command RX:(kRevAirRXDirection)rxDirection;
- (void)REVAir:(id)REVAir didReceiveFirmwareVersionHigh:(int)versionHigh low:(int)versionLow;
- (void)REVAir:(id)REVAir didReceiveWallDetectiobMode:(BOOL)isWallDetectionOn;
- (void)REVAir:(id)REVAir didReceiveCrashDetectiobMode:(BOOL)isCrashDetectionOn;
- (void)REVAir:(id)REVAir didReceiveStallDetectiobMode:(BOOL)isStallDetectionOn;
- (void)REVAir:(id)REVAir didResetIRCalibration:(BOOL)isSuccessReset;
- (void)REVAir:(id)REVAir didDetectedWall:(kREVAirWallDirection)wallDirection;
- (void)REVAir:(id)REVAir didErrorNotify:(kREVAirNotifyError)errorType;
- (void)REVAir:(id)REVAir didNotifyModifiedZ:(int)ModifiedZ;
- (void)REVAirDidNotifyFirstSonar:(id)REVAir;

@end

FOUNDATION_EXPORT NSString *const REVAir_CONNECTED_NOTIFICATION_NAME;
FOUNDATION_EXPORT NSString *const REVAir_DISCONNECTED_NOTIFICATION_NAME;

typedef enum : NSUInteger {
    REVAirLogLevelNone = 1,
    REVAirLogLevelDebug,
    REVAirLogLevelErrors,
} REVAirLogLevel;


@interface REVAir : BluetoothRobot

@property (nonatomic, weak) id<REVAirDelegate> delegate;
@property (nonatomic, assign) int stuntX;
@property (nonatomic, assign) int stuntY;
@property (nonatomic, assign) int stuntZ;

@property (nonatomic, assign) int currentEstimatedX;
@property (nonatomic, assign) int currentEstimatedY;
@property (nonatomic, assign) int currentEstimatedZ;
@property (nonatomic, assign) double estimatedPositionTimestamp;

@property (nonatomic, strong) NSMutableArray *flightErrorList;      // List of REVAirNotifyErrorItem

@property (nonatomic, assign) BOOL REVAirtakeOffAndRejectCommand;


#pragma mark - REV AIR Commands
- (void)REVAirFreeFlightWithThrust:(uint16_t)thrust yaw:(int16_t)yaw pitch:(int16_t)pitch roll:(int16_t)roll;
- (void)REVAirSpinByTime:(kREVAirSpeed)speed time:(int)milliseconds direction:(kREVAirDirection)direction height:(uint8_t)height;
- (void)REVAirSpinBySpeed:(uint8_t)speed direction:(kREVAirDirection)direction; // speed = 0x00 - 0x0a
- (void)REVAirStop;
- (void)REVAirLandOrTakeOff:(kREVAirLandOrTakeOffAction)action height:(uint8_t)height;
- (void)REVAirPerformStunt:(kREVAirStuntByte)stunt data1:(uint8_t)data1 data2:(uint8_t)data2;
- (void)REVAirGoToPosition:(int)xInCM y:(int)yInCM z:(uint8_t)zInCM;
- (void)REVAirGoToPosition:(int)xInCM y:(int)yInCM z:(uint8_t)zInCM duration:(float)duration;
- (void)REVAirSetFollowMeActivated:(BOOL)followMe;
- (void)REVAirCalibrate;
- (void)REVAirGetBattery;
- (void)REVAirSetLEDColor:(kREVAirLEDColor)color;
- (void)REVAirGetStatus;
- (void)REVAirGetCurrentBeaconMode;
- (void)REVAirSetCurrentBeaconMode:(kREVAirBeaconMode)beaconMode;
- (void)REVAirGetCurrentAltitudeMode;
- (void)REVAirSetCurrentAltitudeMode:(kREVAirAltitudeMode)altitudeMode;
- (void)REVAirGetIRSignalStrength;
- (void)REVAirGetPosition;
- (void)REVAirGetCurrentEstimatedPosition;
- (void)REVAirGetFirmwareVersion;
- (void)REVAirSetWallDetectionModeOn:(BOOL)wallDetectionOn;
- (void)REVAirGetWallDetectionMode;
- (void)REVAirResetIRCalibration;
- (void)REVAirSendIRCommand:(uint8_t)commandByte direction:(kREVAirIRDirection)direction;

@end
