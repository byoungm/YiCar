//
//  ViewController.m
//  YiCar
//
//  Created by Benjamin Young on 1/3/15.
//  Copyright (c) 2015 Benjamin Young. All rights reserved.
//

#import "ViewController.h"
#import "BLE.h"

@interface ViewController () <BLEDelegate>
@property (strong, nonatomic) BLE *ble;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // Init BLE Search
    self.ble = [[BLE alloc] init];
    [self.ble controlSetup];
    self.ble.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//// BLE WRITE DATA to serial
// UInt8 buf[3] = {0x02, 0x00, 0x00};
// 
// NSData *data = [[NSData alloc] initWithBytes:buf length:3];
// [ble write:data];

#pragma mark - BLE Delegate

- (void)bleDidDisconnect
{
    NSLog(@"->Disconnected");
    

}

// When RSSI is changed, this will be called


// When disconnected, this will be called
-(void) bleDidConnect
{
    NSLog(@"->Connected");
    
}

// When data is comming, this will be called
-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    
}


@end
