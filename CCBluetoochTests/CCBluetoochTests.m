//
//  CCBluetoochTests.m
//  CCBluetoochTests
//
//  Created by zjh on 2021/7/7.
//

#import <XCTest/XCTest.h>
#import "CCPeripheral.h"
@interface CCBluetoochTests : XCTestCase
@property (nonatomic,strong) NSThread *thread1;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) dispatch_semaphore_t t;
@end

@implementation CCBluetoochTests

- (void)setUp {
    self.thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(start) object:nil];
    self.t = dispatch_semaphore_create(1);
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    [self.thread1 start];
//    for (int i = 0; i < 3; i++) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSLog(@"线程执行前%d",i);
//            dispatch_semaphore_wait(self.t, DISPATCH_TIME_FOREVER);
//            NSLog(@"线程执行中%d",i);
//            [NSThread sleepForTimeInterval:5];
//            dispatch_semaphore_signal(self.t);
//            NSLog(@"线程执行后%d",i);
//        });
//    }
    [self performSelector:@selector(printAction) onThread:self.thread1 withObject:nil waitUntilDone:YES];
    [self performSelector:@selector(printAction1) onThread:self.thread1 withObject:nil waitUntilDone:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"当前线程1111：%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:5];
        NSLog(@"线程状态：%@",self.thread1.isFinished ? @"结束" : @"进行中");
        [NSThread sleepForTimeInterval:10];
        NSLog(@"线程状态：%@",self.thread1.isFinished ? @"结束" : @"进行中");
    });
    [NSThread sleepForTimeInterval:60];
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}
-(void)start{
    NSLog(@"当前线程：%@",[NSThread currentThread]);
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    NSLog(@"代码执行结束");
}
-(void)printAction{
    NSLog(@"当前线程2：%@",[NSThread currentThread]);
    [NSThread sleepForTimeInterval:5];
}

-(void)printAction1{
    NSLog(@"当前线程1：%@",[NSThread currentThread]);
    [NSThread sleepForTimeInterval:5];

}
-(void)timeAction:(NSTimer *)timer{
    if (++self.count > 2) {
        dispatch_sync(dispatch_queue_create("aa", DISPATCH_QUEUE_CONCURRENT), ^{
            [NSThread sleepForTimeInterval:1];
            NSLog(@"当前线程2222：%@",[NSThread currentThread]);
            [timer invalidate];;
        });
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_queue_create("aa", DISPATCH_QUEUE_CONCURRENT), ^{
////            NSLog(@"当前线程2222：%@",[NSThread currentThread]);
//            [timer invalidate];;
////    //        self.timer = nil;
//        });
    }
    NSLog(@"timer打印");
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
