//
//  ProfileViewController.h
//  Tubor
//
//  Created by Marcelo Sedano on 3/24/15.
//  Copyright (c) 2015 Marcelo Sedano. All rights reserved.
///Users/jakeirvin/Documents/Development/CSE 394/Tubor/Tubor/Tubor.xcodeproj

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ProfileTableViewCell.h"

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic) PFUser * user;
@property (nonatomic) NSString * previousVC;
- (IBAction)cancelSession:(id)sender;
@property BOOL rateBool;
@end
