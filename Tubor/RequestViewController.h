//
//  RequestViewController.h
//  Tubor
//
//  Created by Jake Irvin on 3/25/15.
//  Copyright (c) 2015 Marcelo Sedano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ProfileViewController.h"


@interface RequestViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *chooseClass;
@property (weak, nonatomic) IBOutlet UITableView *availableTutors;
@property (strong, atomic) NSMutableArray * courses;
@property (strong, atomic) NSMutableArray * nameArray;
// array of users
@property (strong, atomic) NSMutableArray * tutors;
@property NSString * chosenCourse;
@property (strong, atomic) PFUser * user;
@property (strong, atomic) NSMutableArray * locationArray;
@property (strong, atomic) NSMutableArray * timeArray;
//@property (strong, atomic) NSMutableArray * ratingArray;
@end
