//
//  ConnectionViewController.m
//  Sample Project
//
//  Created by David Chan on 3/4/2017.
//  Copyright © 2017 WowWee Group Limited. All rights reserved.
//

#import "ConnectionViewController.h"
#import "SDKMenuViewController.h"

@interface ConnectionViewController ()

@end

@implementation ConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    peripheralList = [NSMutableArray new];
    
    [self prepareCBCentralManager];
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"LoadingView"
                                                      owner:self
                                                    options:nil];
    viewLoading = [nibViews objectAtIndex:0];
    [viewLoading setFrame:[self.view frame]];
    [self.view addSubview:viewLoading];
    [viewLoading hide];
    
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)refreshAction:(id)sender {
    [self.tableView reloadData];
    
    [self cleanRobots];
    
    [self startScanning];
}

#pragma mark - Public Methods
- (void)cleanRobots {
#if !defined(TARGET_IPHONE_SIMULATOR) || TARGET_IPHONE_SIMULATOR == 0
    [self stopScanning];
    [[REVAirFinder sharedInstance] clearFoundRobotList];
    [peripheralList removeAllObjects];
#endif
}

- (void)prepareCBCentralManager {
    //#if !defined(TARGET_IPHONE_SIMULATOR) || TARGET_IPHONE_SIMULATOR == 0
    //#else
    self.cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    //#endif
}
- (void)startScanning {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onREVAirFinderNotification:) name:REVAirFinderNotificationID object:nil];
    [[REVAirFinder sharedInstance] scanForRobots];
}

- (void)stopScanning {
    [[REVAirFinder sharedInstance] stopScanForRobots];
    [[NSNotificationCenter defaultCenter] removeObserver:self name: REVAirFinderNotificationID object:nil];
}

- (void)changePage {
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SDKMenuViewController *controller = [sb instantiateViewControllerWithIdentifier:@"SDKMenuViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [peripheralList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* strIdentifier = @"RobotConnectionTableViewCellIdentifier";
    UITableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
    }
    if ([peripheralList count] > indexPath.row){
        BluetoothRobot *robot = [peripheralList objectAtIndex:indexPath.row];
        [cell.textLabel setText:robot.name];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    REVAir *robot = nil;
    robot = [[[REVAirFinder sharedInstance] robotsFound] objectAtIndex:indexPath.row];
    robot.delegate = self;
    [robot connect];
    [viewLoading show];
}

#pragma mark - CBCentralManagerDelegate
- (void) centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"checking state");
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
            [self startScanning];
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CoreBluetooth BLE hardware is resetting");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CoreBluetooth BLE state is unauthorized");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"CoreBluetooth BLE state is unknown");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
            break;
        default:
            break;
    }
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"Did discover peripheral %@", peripheral.name);
    
    [peripheralList addObject:peripheral];
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Did connect peripheral %@", peripheral.name);
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    
    //    if([self.navigationController.topViewController isKindOfClass:[RemoteViewController class]]) {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
}

- (void)onREVAirFinderNotification: (NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    if(info){
        NSNumber *code = [info objectForKey: @"code"];
        //id data = [info objectForKey: @"data"];
        if (code.intValue == REVAirFinderNote_REVAirFound){
            [peripheralList removeAllObjects];
            
            NSMutableArray* arr = [[REVAirFinder sharedInstance] robotsFound];
            for (int i=0; i<[arr count]; i++) {
                BluetoothRobot *robot = [arr objectAtIndex:i];
                [peripheralList addObject:robot];
            }
            [self.tableView reloadData];
        } else if (code.intValue == REVAirFinderNote_REVAirListCleared) {
            [self.tableView reloadData];
            [peripheralList removeAllObjects];
        } else if (code.intValue == REVAirFinderNote_BluetoothError) {
        } else if (code.intValue == REVAirFinderNote_BluetoothIsOff) {
        } else if (code.intValue == REVAirFinderNote_BluetoothIsAvailable) {
        }
    }
}

#pragma mark - REVAirDelegate
- (void)REVAirDeviceReady:(REVAir *)robot {
    [viewLoading hide];
    [NSThread sleepForTimeInterval:2];
    robot.autoReconnect = YES;
    [self stopScanning];
    isConnected = NO;
    [self changePage];
}

- (void)REVAirDeviceDisconnected:(REVAir *)robot error:(NSError *)error {
    [robot disconnect];
}

- (void)REVAirDeviceFailedToConnect:(REVAir *)robot error:(NSError *)error {
    [viewLoading hide];
}

- (void)REVAir:(REVAir *)robot didReceiveConnectionStatus:(BOOL)status {
    if (!isConnected) {
        [viewLoading hide];
        [NSThread detachNewThreadSelector:@selector(changePage) toTarget:self withObject:nil];
        isConnected = YES;
    }
}

@end
