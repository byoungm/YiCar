//
//  RBLDetailViewController.m
//  BLE Select
//
//  Created by Chi-Hung Ma on 4/24/13.
//  Copyright (c) 2013 RedBearlab. All rights reserved.
//


#import "RBLDetailViewController.h"
#import "ViewController.h"

@interface RBLDetailViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) NSMutableArray *bleDevices;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation RBLDetailViewController

#pragma mark - Lazy Instantaion

- (NSMutableArray *)bleDevices
{
    if (!_bleDevices) _bleDevices = [[NSMutableArray alloc] init];
    return _bleDevices;
}

# pragma mark - View Life Cycle

/*
 - (void)awakeFromNib
 {
 [super awakeFromNib];
 }
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self searchForDevices];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishedSearchWithPeripheral:(CBPeripheral *)peripheral
{
    [self.spinner stopAnimating];
    [self.delegate bleFindVC:self finishedSearchWithPeripheral:peripheral];
}

# pragma mark - UI Actions

- (IBAction)cancelSearch:(id)sender
{
    [self finishedSearchWithPeripheral:nil];
}



# pragma mark - BLE Find Devices

- (void)searchForDevices{
    
    if (self.ble.activePeripheral)
    {
        if(self.ble.activePeripheral.isConnected)
        {
            [[self.ble CM] cancelPeripheralConnection:[self.ble activePeripheral]];
            return;
        }
    }
    
    if (self.ble.peripherals)
        self.ble.peripherals = nil;
    
    [self.ble findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    
    [self.spinner startAnimating];
    
}


// Called when scan period is over
-(void) connectionTimer:(NSTimer *)timer
{
    if(self.ble.peripherals.count > 0)
    {
        //Scan for all BLE in range and prepare a list
        [self.bleDevices removeAllObjects];
        
        int i;
        for (i = 0; i < self.ble.peripherals.count; i++)
        {
            CBPeripheral *p = [self.ble.peripherals objectAtIndex:i];
            
            if (p.UUID != NULL)
            {
                [self.bleDevices insertObject:[self getUUIDString:p.UUID] atIndex:i];
            }
            else
            {
                [self.bleDevices insertObject:@"NULL" atIndex:i];
            }
        }
        
        //Show the list for user selection
        [self.tableView reloadData];
    }
    else
    {
        [self.spinner stopAnimating];
        
    }
    
}


-(NSString*)getUUIDString:(CFUUIDRef)ref {
    NSString *str = [NSString stringWithFormat:@"%@",ref];
    return [[NSString stringWithFormat:@"%@",str] substringWithRange:NSMakeRange(str.length - 36, 36)];
}



#pragma mark - Table View

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bleDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
    */
    
    static NSString *tableIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier forIndexPath:indexPath];
    
    /*
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    */
    cell.textLabel.text = [self.bleDevices objectAtIndex:indexPath.row];
    return cell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self finishedSearchWithPeripheral:[self.ble.peripherals objectAtIndex:indexPath.row]];
    
}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDevice"]) {
        RBLMainViewController *vc =[segue sourceViewController] ;
        vc.selected = selected;    }
}
*/

/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
*/
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}
*/
@end
