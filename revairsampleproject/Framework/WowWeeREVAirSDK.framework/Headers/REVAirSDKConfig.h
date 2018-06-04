//
//  REVAirSDKConfig.h
//  BluetoothRobotControlLibrary
//
//  Created by David Chan on 28/3/2017.
//  Copyright (c) 2017 WowWee Group Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MPFREVAirScanOptionMask_ShowAllDevices       = 0,
    MPFREVAirScanOptionMask_FilterByProductId    = 1 << 0,
    MPFREVAirScanOptionMask_FilterByServices     = 1 << 1,
    MPFREVAirScanOptionMask_FilterByDeviceName   = 1 << 2,
} REVAirFinderScanOptions;

#ifndef REVAir_SCAN_OPTIONS
#define REVAir_SCAN_OPTIONS MPFREVAirScanOptionMask_ShowAllDevices | MPFREVAirScanOptionMask_FilterByProductId
#endif

@interface REVAirSDKConfig : NSObject

@end
