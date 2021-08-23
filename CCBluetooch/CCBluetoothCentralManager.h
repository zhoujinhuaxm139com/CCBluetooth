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
-(void)cccentralManagerDidUpdateState:(CBCentralManager *)central;
- (void)cccentralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict;
- (void)cccentralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
- (void)cccentralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;
- (void)cccentralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
- (void)cccentralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
- (void)ccperipheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error;
- (void)ccperipheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
- (void)ccperipheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
- (void)ccperipheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
- (void)ccperipheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error;
- (void)ccperipheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
- (void)ccperipheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error;
- (void)ccperipheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
- (void)ccperipheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error;
- (void)ccperipheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error;
- (void)ccperipheralDidUpdateName:(CBPeripheral *)peripheral;
- (void)ccperipheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices;
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
