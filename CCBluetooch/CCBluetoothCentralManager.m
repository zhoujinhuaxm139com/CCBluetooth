//
//  CCBluetoothCentralManager.m
//  CCBluetooch
//
//  Created by zjh on 2021/7/8.
//

#import "CCBluetoothCentralManager.h"

@interface CCBluetoothCentralManager()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (nonatomic, strong) NSHashTable *delegates;
@property (nonatomic, strong) CBCentralManager *centralManager;
@end
static CCBluetoothCentralManager *central;
static dispatch_once_t onetoken;
static dispatch_queue_t dispatch_queue;
@implementation CCBluetoothCentralManager
+(instancetype)share{
    dispatch_once(&onetoken, ^{
        central = [[CCBluetoothCentralManager alloc] init];
    });
    return central;
}
+(instancetype)alloc{
    NSCAssert(!central, @"CCBleManager类只能初始化一次");
    return [super alloc];
}
+(void)registerQueue:(dispatch_queue_t)queue{
    dispatch_queue = queue;
}
-(id)init{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}
-(void)setUp{
    self.delegates = [NSHashTable weakObjectsHashTable];
#if  __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_6_0
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 //蓝牙power没打开时alert提示框
                                 [NSNumber numberWithBool:YES],CBCentralManagerOptionShowPowerAlertKey,
                                 //重设centralManager恢复的IdentifierKey
                                 @"babyBluetoothRestore",CBCentralManagerOptionRestoreIdentifierKey,
                                 nil];
        
#else
        NSDictionary *options = nil;
#endif
    
    NSArray *backgroundModes = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"UIBackgroundModes"];
    if ([backgroundModes containsObject:@"bluetooth-central"]) {
        //后台模式
        self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_queue options:options];
    }
    else {
        //非后台模式
        self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_queue];
    }
}
-(void)startScanAndStopAfterDelay:(NSTimeInterval)delay{
    if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopScan) object:nil];
        [self stopScan];
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        [self performSelector:@selector(stopScan) withObject:self afterDelay:delay];
    }
}
-(void)stopScan{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopScan) object:nil];
    if (self.centralManager.isScanning) {
        [self.centralManager stopScan];
    }
}
-(void)connect:(CBPeripheral *)peripheral{
    [self.centralManager connectPeripheral:peripheral options:nil];
}
-(void)disconnect:(CBPeripheral *)peripheral{
    [self.centralManager cancelPeripheralConnection:peripheral];
}
-(void)addDelegate:(id<CCBluetoothCentralManagerDelegate>)delegate{
    if (![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
    }
}
#pragma mark CBCentralManagerDelegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSArray *delegates = [self.delegates allObjects];
    for (id<CCBluetoothCentralManagerDelegate> obj in delegates.objectEnumerator) {
        if ([obj respondsToSelector:@selector(bluetoothCentralManagerDidUpdateState:)]) {
            [obj bluetoothCentralManagerDidUpdateState:central];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict {
    NSArray *delegates = [self.delegates allObjects];
    for (id<CCBluetoothCentralManagerDelegate> obj in delegates.objectEnumerator) {
        if ([obj respondsToSelector:@selector(bluetoothCentralManager:willRestoreState:)]) {
            [obj bluetoothCentralManager:central willRestoreState:dict];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSArray *delegates = [self.delegates allObjects];
    for (id<CCBluetoothCentralManagerDelegate> obj in delegates.objectEnumerator) {
        if ([obj respondsToSelector:@selector(bluetoothCentralManager:didDiscoverPeripheral:advertisementData:RSSI:)]) {
            [obj bluetoothCentralManager:central didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {

}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {

}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {

}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {

}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {

}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {

}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {

}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {

}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {

}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error {

}

# if  __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
}
#else
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error {
    
}
#endif

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral{
    
}
- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices {
    
}
@end
