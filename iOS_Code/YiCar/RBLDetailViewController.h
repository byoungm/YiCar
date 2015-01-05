//
//  RBLDetailViewController.h
//  BLE Select
//
//  Created by Chi-Hung Ma on 4/24/13.
//  Copyright (c) 2013 RedBearlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@protocol BLEFindViewControllerDelegate <NSObject>
// recipe == nil on cancel
- (void) bleFindVC:(UIViewController *)vc finishedSearchWithPeripheral:(CBPeripheral *)selectedPeripheral;
@end



@interface RBLDetailViewController : UIViewController

@property (nonatomic) BLE *ble;
@property (nonatomic, weak) id <BLEFindViewControllerDelegate> delegate;

@end


