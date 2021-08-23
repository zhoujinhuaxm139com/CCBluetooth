//
//  CCBluetoothDevice.m
//  CCBluetooch
//
//  Created by zjh on 2021/7/8.
//

#import "CCPeripheral.h"
#define STANDARD_LENGTH 23
@implementation CCPeripheral
- (BOOL)checkDLE {
    if (@available(iOS 9, *)) {
        _maximumWriteLength = [_peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithResponse];
    }
    return _maximumWriteLength > STANDARD_LENGTH;
}
@end
