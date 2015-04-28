//
//  RequestViewController.m
//  Tubor
//
//  Created by Jake Irvin on 3/25/15.
//  Copyright (c) 2015 Marcelo Sedano. All rights reserved.
//

#import "RequestViewController.h"
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface RequestViewController () 

@end

@implementation RequestViewController

PFUser *selectedTutor;

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // Set the property for the current user
    self.user = [PFUser currentUser];
    
    // Navigation bar GUI
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x000000);
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tuborNavTitle.png"]];
    
    // Location manager and map authorization code
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation=YES;
    self.mapView.delegate = self;
    
    // Set mapview region (ASU campus)
    MKCoordinateRegion region;
    region.center.latitude = 33.419834;
    region.center.longitude = -111.932500;
    region.span.latitudeDelta = 0.005;
    region.span.longitudeDelta = 0.005;
    
    [self.mapView setRegion:region animated:YES];
    
    // Table view instantiation (drop down menu)
    
    self.courseSelectionTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Rounded corners for drop down menu
    self.courseSelectionTable.layer.cornerRadius = 5;
    
    // Initially, the isShowingList value will be set to NO.
    // We don't want the list to be dislplayed when the view loads.
    self.isShowingList = NO;
    
    // By default, when the view loads, the first value of the five we created
    // above will be set as selected.
    // We'll do that by pointing to the first index of the array.
    // Don't forget that for the five items of the array, the indexes are from
    // zero to four (0 - 4).
    self.selectedValueIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.coursesArray = [[NSMutableArray alloc] init];
    [self.coursesArray addObject:@"Select Course"];
    [self.coursesArray addObjectsFromArray:self.user[@"coursesTaking"]];
    
    // Hide navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Drop Down Table Methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // We are going to have only three sections in this example.
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // For the number of rows of the section with index 1 (our test section) there
    // are two cases.
    //
    // First case: If the isShowingList variable is set to NO, then no list
    // with values should be displayed (the values of the demoData array) and
    // it should exist only one row.
    //
    // Second case: If the isShowingList variable is set to YES, then the
    // demoData array values should be displayed as a list and the returned
    // number of rows should match the number of the items in the array.
    if (!self.isShowingList)
    {
        return 1;
    }
    else
    {
        return [self.coursesArray count];
    }
}

// Set the row height.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    if (!self.isShowingList)
    {
        // Not a list in this case.
        // We'll only display the item of the demoData array of which array
        // index matches the selectedValueList.
        [[cell textLabel] setText:[self.coursesArray objectAtIndex:self.selectedValueIndex]];
            
        // We'll also display the disclosure indicator to prompt user to
        // tap on that cell.
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        // Listing the array items.
        [[cell textLabel] setText:[self.coursesArray objectAtIndex:[indexPath row]]];
        
        // We'll display the checkmark next to the already selected value.
        // That means that we'll apply the checkmark only to the cell
        // where the [indexPath row] value is equal to selectedValueIndex value.
        if ([indexPath row] == self.selectedValueIndex)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The job we have to do here is pretty easy.
    // 1. If the isShowingList variable is set to YES, then we save the
    //     index of the row that the user tapped on (save it to the selectedValueIndex variable),
    // 2. Change the value of the isShowingList variable.
    // 3. Reload not the whole table but only the section we're working on.
    //
    // Note that only that last two steps are necessary when the isShowingList
    // variable is set to NO.
        
    // Step 1.
    if (self.isShowingList)
    {
        self.selectedValueIndex = (int) [indexPath row];
    }
    
    // Step 2.
    self.isShowingList = !self.isShowingList;
    
    // Step 3. Here I chose to use the fade animation, but you can freely
    // try all of the provided animation styles and select the one it suits
    // you the best.
    if (self.isShowingList)
    {
        self.courseSelectionTable.frame = CGRectMake(self.courseSelectionTable.frame.origin.x, self.courseSelectionTable.frame.origin.y, self.courseSelectionTable.frame.size.width, (self.courseSelectionTable.contentSize.height)*[self.coursesArray count]);
    }
    else
    {
        self.courseSelectionTable.frame = CGRectMake(self.courseSelectionTable.frame.origin.x, self.courseSelectionTable.frame.origin.y, self.courseSelectionTable.frame.size.width, 40.0);

        // Remove any annotations from map view
        [self removeAllPins];
        
        // Query user database for tutors for specific course
        PFQuery *query = [PFUser query];
        [query whereKey:@"isAvailable" equalTo:[NSNumber numberWithBool:YES]];
        [query whereKey:@"coursesTutoring" equalTo:[self.coursesArray objectAtIndex:self.selectedValueIndex]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error)
        {
            self.tutorsOnMap = (NSMutableArray *) results;
            
            // Add map annotations for all available tutors
            for (int i = 0; i < [results count]; i++)
            {
                [self addAnnotation:results[i]];
            }
        }];
    }
    [self.courseSelectionTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// Method to add an annotation
- (void)addAnnotation:(PFUser *)availableTutor {
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    PFGeoPoint *geoPoint = availableTutor[@"currentLocation"];
    point.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    point.title = [NSString stringWithFormat:@"%@ %@", availableTutor[@"firstName"], availableTutor[@"lastName"]];
    point.subtitle = [NSString stringWithFormat:@"%@",
                availableTutor[@"location"]];
    [self.mapView addAnnotation:point];
}

// View for annotations
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    else
    {
        
        // If an existing pin view was not available, create one.
        MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        // Annotation button initialization
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self
                        action:@selector(showTutorProfile:)
              forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
        
        return pinView;
    }
}

// Method to search tutors array for tutor belonging to annotation
- (PFUser *)findTutorWithName:(NSString *)fullName
{
    PFUser *tutor;
    for (int i = 0; i < [self.tutorsOnMap count]; i++)
    {
        tutor = self.tutorsOnMap[i];
        NSString *tutorName = [NSString stringWithFormat:@"%@ %@", tutor[@"firstName"], tutor[@"lastName"]];
        if ([tutorName isEqualToString:fullName])
        {
            return tutor;
        }
    }
    
    return NULL;
}

// Show tutor segue action
- (void)showTutorProfile:(id)sender
{
    id<MKAnnotation> annotation = [[self.mapView selectedAnnotations] objectAtIndex:0];
    self.selectedTutor = [self findTutorWithName:annotation.title];
    [self performSegueWithIdentifier:@"showTutorSegue" sender:self];
}

// Remove all pins from map view
- (void)removeAllPins
{
    id userLocation = [self.mapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
    if (userLocation != nil) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [self.mapView removeAnnotations:pins];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showTutorSegue"])
    {
        ProfileViewController * userProfileViewController = segue.destinationViewController;
        
        //if you need to pass data to the next controller do it here
        userProfileViewController.user = self.selectedTutor;
        userProfileViewController.previousVC = @"Request";
    }
}

@end












