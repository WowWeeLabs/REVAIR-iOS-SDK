//
//  REVAirNotifyErrorItem.h
//  WowWeeREVAirPODSDK
//
//  Created by David Chan on 28/3/2017.
//  Copyright © 2017 WowWee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REVAirCommandValues.h"

@interface REVAirNotifyErrorItem : NSObject

@property (nonatomic, assign) double timestamp;
@property (nonatomic, assign) kREVAirNotifyError error;

@end
