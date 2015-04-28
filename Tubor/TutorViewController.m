//
//  TutorViewController.m
//  Tubor
//
//  Created by Jake Irvin on 3/28/15.
//  Copyright (c) 2015 Marcelo Sedano. All rights reserved.
//

#import "TutorViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TutorViewController ()


@end

@implementation TutorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.user = [PFUser currentUser];
    
    // Set up location manager to get user location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    if ([self.user[@"isAvailable"]  isEqual: @NO]) {
        [self.availability setOn:NO];
    }
    if ([self.user[@"isAvailable"] isEqual:@YES]) {
        [self.availability setOn:YES];
        self.tableTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                           target:self selector:@selector(refreshTable)
                                                         userInfo:nil repeats:YES];
    }
    
    [self.user saveInBackground];
    
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x000000);
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tuborNavTitle.png"]];
}

// Hide keyboard when user taps outside of keyboard area
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)refreshTable
{
    [self.requestTable reloadData];

}

// Limit number of characters in location text field (so annotations aren't insanely long)
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range                          withString:string];
    return !([newString length] > 20);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)isAvailable:(id)sender {
    
    // if isAvailable = true, set the user's location and time there
    // if false, set the location and time there to null

    if (self.availability.isOn)
    {
        
        // Set user's current location on Parse
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
            if (!error) {
                self.user[@"currentLocation"] = geoPoint;
            }
        }];
        
        
        NSString * location = [NSString stringWithString:self.locationText.text];
        //NSString * timeAvailable = [NSString stringWithString:self.availabilityText.text];
        NSString * timeAvailable = self.dateString;
        
        if ([location length] == 0) {
            // alert to enter a location
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"No Location"
                                  message:[NSString stringWithFormat: @"\nPlease set your location"]
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            // set the switch back to NO
            [self.availability setOn:NO animated:YES];
            [alert show];
            return;
        }
        if ([timeAvailable length] == 0) {
            // alert to enter a time available
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"No Time Available"
                                  message:[NSString stringWithFormat: @"\nPlease set the time you need to stop tutoring."]
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            // set the switch back to NO
            [self.availability setOn:NO animated:YES];
            [alert show];
            return;
        }
        // cast the bool as an NSNumber to pass in as an object to the isAvailable parameter
        
        // turn off date picker
        [self.timePicker setUserInteractionEnabled:NO];
        self.user[@"isAvailable"] = @YES;
        self.user[@"timeAvailable"] = timeAvailable;
        self.user[@"location"] = location;
        self.locationText.text = self.user[@"location"];
        
        [self.user saveInBackground];
        self.locationText.text = self.user[@"location"];
        [self.locationText setUserInteractionEnabled:NO];
        [self.requestTable reloadData];
        
        self.tableTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                           target:self selector:@selector(refreshTable)
                                                         userInfo:nil repeats:YES];
        
        return;
                
    }
    
    // when switch is switched off
    NSNull *null = [NSNull null];
    self.user[@"isAvailable"] = @NO;
    self.user[@"timeAvailable"] = @"";
    self.user[@"location"] = @"";
    self.user[@"pupil"] = null;
    
         
    [self.user saveInBackground];
    
    self.locationText.text = @"";
    [self.locationText setUserInteractionEnabled:YES];
    
    [self.requestTable reloadData];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    separatorLineView.backgroundColor = [UIColor clearColor]; // set color as you want.
    [cell.contentView addSubview:separatorLineView];
    
    if ([self.user[@"isAvailable"] isEqual:@YES]) {
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"tutorRequested" equalTo:self.user.username];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            self.pupil = [results firstObject];
        }];

        
        NSString * request = [self.pupil[@"firstName"] stringByAppendingString:@"  Course Requested: "];
        request = [request stringByAppendingString:self.pupil[@"courseRequested"]];
        cell.textLabel.text = request;
    }
    else if ([self.user[@"isAvailable"] isEqual:@NO])
    {
        cell.textLabel.text = @"";
    }
    
    /*if (self.pupil != nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"You've Been Requested!"
                              message:[NSString stringWithFormat: @"\n%@ %@ is on their way to you at %@ for help with %@.", self.pupil[@"firstName"], self.pupil[@"lastName"], self.user[@"location"], self.pupil[@"courseRequested"]]
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
     
        
        self.user[@"isAvailable"] = @NO;
        [self.availability setOn:NO];
        [self.tableTimer invalidate];
        
        [self.user saveInBackground];
    }
    */
    
    return cell;
 
}



- (IBAction)pickTime:(id)sender {
    
    self.time = self.timePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm aa"];
    NSString *prettyVersion = [dateFormat stringFromDate:self.time];
    self.dateString = prettyVersion;
   
}
@end



















