/*
 * Copyright 2010-2017 WowWee Group Ltd, All Rights Reserved.
 *
 * Licensed under the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

@import CoreBluetooth;

#import "REVAir.h"
#import "BluetoothRobotFinder.h"

FOUNDATION_EXPORT NSString *const REVAirFinderNotificationID;
FOUNDATION_EXPORT bool const REVAir_ROBOT_FINDER_DEBUG_MODE;

/**
 These are the values that can be sent from REVAirFinder
 */
typedef enum : NSUInteger {
    REVAirFinderNote_REVAirFound = 1,
    REVAirFinderNote_REVAirListCleared,
    REVAirFinderNote_BluetoothError,
    REVAirFinderNote_BluetoothIsOff,
    REVAirFinderNote_BluetoothIsAvailable,
} REVAirFinderNote;

@interface REVAirFinder : BluetoothRobotFinder <CBCentralManagerDelegate>

/**

 */
@property (nonatomic, strong, readonly) NSMutableArray *robotsFound;
@property (nonatomic, strong, readonly) NSMutableArray *robotsConnected;
@property (nonatomic, assign, readonly) CBCentralManagerState cbCentralManagerState;

// Log level
@property (nonatomic, assign) REVAirLogLevel logLevel;

/**
 Starts the BLE scanning
 */
-(void)scanForRobots;

/**
 Starts the BLE scanning for a specified number of seconds. Normally you should use this method because endlessly scanning is very battery intensive.
 */
-(void)scanForRobotsForDuration:(NSUInteger)seconds;
-(void)stopScanForRobots;
-(void)clearFoundRobotList;

/**
 Quick access to first connected REVAir in REVAirsConnected list
 @return REVAirsConnected[0] or nil if REVAirsConnected is empty
 */
-(REVAir *)firstConnectedREVAir;

@end
