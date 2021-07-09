//
//  CCBluetoothCentralManager.h
//  CCBluetooch
//
//  Created by zjh on 2021/7/8.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CCPeripheral.h"
NS_ASSUME_NONNULL_BEGIN
@protocol CCBluetoothCentralManagerDelegate <NSObject>

@optional
-(void)bluetoothCentralManagerDidUpdateState:(CBCentralManager *)central;
-(void)bluetoothCentralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict;
-(void)bluetoothCentralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
- (void)bluetoothCentralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;
- (void)bluetoothCentralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
- (void)bluetoothCentralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
- (void)bluetoothPeripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error;


@end
@interface CCBluetoothCentralManager : NSObject
@property (nonatomic,strong) NSMutableArray <CCPeripheral *> *devices;
@property (nonatomic,strong) NSMutableArray <CCPeripheral *> *connectedDevices;

+(void)registerQueue:(nullable dispatch_queue_t)queue;
+(instancetype)share;
-(void)addDelegate:(id<CCBluetoothCentralManagerDelegate>)delegate;
-(void)startScanAndStopAfterDelay:(NSTimeInterval)delay;
-(void)stopScan;
-(void)connect:(CBPeripheral *)peripheral;
-(void)disconnect:(CBPeripheral *)peripheral;
@end

NS_ASSUME_NONNULL_END
