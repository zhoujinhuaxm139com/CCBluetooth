//
//  CCBluetoothDevice.h
//  CCBluetooch
//
//  Created by zjh on 2021/7/8.
//

#import <Foundation/Foundation.h>
@class CBPeripheral;
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, CCBluetoothDeviceState){
    CCBluetoothDeviceStateNone =0,//无
    CCBluetoothDeviceStateConnectting = 1,//连接中
    CCBluetoothDeviceStateConnected = 2//已连接
};

@interface CCPeripheral : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *uuid;
@property (nonatomic,strong) CBPeripheral *peripheral;
@property (nonatomic,assign) CCBluetoothDeviceState status;
@end

NS_ASSUME_NONNULL_END
