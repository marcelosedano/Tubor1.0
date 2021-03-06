//
//  TutorViewController.h
//  Tubor
//
//  Created by Jake Irvin on 3/28/15.
//  Copyright (c) 2015 Marcelo Sedano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>


@interface TutorViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *locationText;
@property (weak, nonatomic) IBOutlet UITableView *requestTable;
@property PFUser * user;
@property IBOutlet UISwitch *availability;
@property PFUser * pupil;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property NSDate * time;
@property(nonatomic, getter=isOn) BOOL on;
@property NSString * dateString;
@property (nonatomic) NSTimer * tableTimer;
@property (nonatomic) CLLocationManager *locationManager;

- (IBAction)pickTime:(id)sender;

@end
