//
//  RequestViewController.h
//  Tubor
//
//  Created by Jake Irvin on 3/25/15.
//  Copyright (c) 2015 Marcelo Sedano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ProfileViewController.h"

@interface RequestViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>


@property (strong, atomic) PFUser *user;
@property (weak, nonatomic) PFUser *selectedTutor;
@property (strong, atomic) NSMutableArray *tutorsOnMap;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationManager *locationManager;

// Table variables (drop down menu)
@property (weak, nonatomic) IBOutlet UITableView *courseSelectionTable;
@property (retain, nonatomic) NSMutableArray *coursesArray;
@property (nonatomic) int selectedValueIndex;
@property (nonatomic) bool isShowingList;

@end
