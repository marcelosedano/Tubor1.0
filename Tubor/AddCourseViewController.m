//
//  AddCourseViewController.m
//  Tubor
//
//  Created by Marcelo Sedano on 4/1/15.
//  Copyright (c) 2015 Marcelo Sedano. All rights reserved.
//

#import "AddCourseViewController.h"

@interface AddCourseViewController ()
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *courseTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *addTypeControl;
- (IBAction)addCourse:(id)sender;

@end

@implementation AddCourseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)cancel:(id)sender {
    // Dismiss view controller
    [self.presentingViewController dismissViewControllerAnimated:true completion:nil];

}
- (IBAction)addCourse:(id)sender {
    NSString * courseToAdd = self.courseTextField.text;
    
    PFUser * user = [PFUser currentUser];
    // "Taking" is selected in the control
    if (self.addTypeControl.selectedSegmentIndex == 0)
    {
        [user[@"coursesTaking"] addObject:courseToAdd];
    }
    else
    {
        [user[@"coursesTutoring"] addObject:courseToAdd];
    }
    [user saveInBackground];
    
    // Dismiss view controller
    [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
}
@end
