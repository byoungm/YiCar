//
//  ViewController.m
//  YiCar
//
//  Created by Benjamin Young on 1/3/15.
//  Copyright (c) 2015 Benjamin Young. All rights reserved.
//

#import "ViewController.h"
#import "BLE.h"
#include "ETJoyStick.h"
#include "RBLDetailViewController.h"


#define SEND_MOTOR_CONTROLS_TIME_INTERVAL_IN_SEC .10 // Every 10 seconds


@interface ViewController () <BLEDelegate, BLEFindViewControllerDelegate>
@property (nonatomic) BLE *ble;
@property (nonatomic) NSTimer *sendMotorControlsTimer;
// Interface
@property (nonatomic, weak) IBOutlet ETJoyStick *joyStick;
@property (nonatomic, weak) IBOutlet UILabel *deviceIDLabel;

// Temp Sliders
@property (nonatomic, weak) IBOutlet UISlider *sliderUD;
@property (nonatomic, weak) IBOutlet UISlider *sliderLR;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // Init BLE Search
    self.ble = [[BLE alloc] init];
    [self.ble controlSetup];
    self.ble.delegate = self;
    
    
    // Rotate the second joystick to be vertical
    self.sliderUD.transform = CGAffineTransformMakeRotation(-M_PI_2);
    //self.joyStickHorizontal.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)bleFindVC:(UIViewController *)vc finishedSearchWithPeripheral:(CBPeripheral *)selectedPeripheral
{
    if (selectedPeripheral)
    {
        [self.ble connectPeripheral:selectedPeripheral];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"BLE_SEARCH"])
    {
        RBLDetailViewController *vc = segue.destinationViewController;
        vc.ble = self.ble;
        vc.delegate = self;
    }
}

- (void)sendMotorControls
{
    /*MotorValue_t m = self.joyStick.motorValues;
    UInt8 leftFB = ( m.leftForward ) ? 0xF0 : 0x00;
    UInt8 rightFB = ( m.rightForward ) ? 0x0F : 0x00;
    UInt8 leftMotorPWM = (char)(255 * m.leftPowerPercent );
    UInt8 rightMotorPWM = (char)(255 * m.rightPowerPercent );
     */
    DataTransfer_t dataTransfer;
    
    // Temp 2 Sliders
    dataTransfer.cmd = 'M';
    dataTransfer.motorDirections.bits.left = ( self.sliderLR.value > 0 ) ? 0xF0 : 0x00;
    dataTransfer.motorDirections.bits.right = ( self.sliderUD.value > 0 ) ? 0x0F : 0x00;
    dataTransfer.leftPower = (char) fabsf(self.sliderLR.value);
    dataTransfer.rightPower = (char) fabsf(self.sliderUD.value);
    
    // send serial data
    //UInt8 buffer[4] = {'M',(leftFB | rightFB),leftMotorPWM,rightMotorPWM};
    NSData *data = [[NSData alloc] initWithBytes:&dataTransfer length:4];
    [self.ble write:data];
}


#pragma mark - BLE Delegate

-(void) bleDidConnect
{
    NSLog(@"->Connected");
    self.deviceIDLabel.text = self.ble.activePeripheral.identifier.UUIDString;
    NSLog(@"%@",self.ble.activePeripheral.identifier);
    self.sendMotorControlsTimer  = [NSTimer scheduledTimerWithTimeInterval:SEND_MOTOR_CONTROLS_TIME_INTERVAL_IN_SEC
                                                                    target:self
                                                                  selector:@selector(sendMotorControls)
                                                                  userInfo:nil
                                                                   repeats:YES];
    
}

- (void)bleDidDisconnect
{
    NSLog(@"->Disconnected");
    self.deviceIDLabel.text = @"NO YiCar CONNECTED";
    [self.sendMotorControlsTimer invalidate];
    

}

// When RSSI is changed, this will be called



// When data is comming, this will be called
-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    
}


@end
