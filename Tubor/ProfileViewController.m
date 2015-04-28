//
//  ProfileViewController.m
//  Tubor
//
//  Created by Marcelo Sedano on 3/24/15.
//  Copyright (c) 2015 Marcelo Sedano. All rights reserved.
//

#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userPictureView;
@property (weak, nonatomic) IBOutlet UITextView *userBioTextView;
@property (weak, nonatomic) IBOutlet UITableView *coursesTakingTable;
@property (weak, nonatomic) IBOutlet UITextField *userFullName;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextView *biography;
- (IBAction)logOut:(id)sender;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Customize view controller depending on source view controller
    if ([self.previousVC isEqualToString:@"Login"])
    {
        UIBarButtonItem * editButton = [self editButtonItem];
        editButton.tintColor = [UIColor whiteColor]; // Color of "Edit" button
        self.navigationItem.leftBarButtonItem = editButton; // Change left bar button to "Edit" button
    }
    else if ([self.previousVC isEqualToString:@"Request"])
    {
        // Add "Request Tutor" button on navigation bar
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Request" style:UIBarButtonItemStylePlain target:self action:@selector(requestTutor)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor]; // Color of button
    }
    
    self.userFullName.text = [NSString stringWithFormat:@"%@ %@",self.user[@"firstName"], self.user[@"lastName"]];
    self.phoneNumber.text = self.user[@"phoneNumber"];
    self.biography.text = self.user[@"bio"];
    
    // Set navigation bar color
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x000000);
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tuborNavTitle.png"]];
    
    // Table section title font size
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont boldSystemFontOfSize:12]];
    // Table view rounded corners
    self.coursesTakingTable.layer.cornerRadius = 5; // Uses QuartzCore
    
    // Rounded text view for biography
    [self.biography.layer setBorderColor: [[UIColor clearColor] CGColor]];
    [self.biography.layer setBorderWidth: 1.0];
    [self.biography.layer setCornerRadius:8.0f];
    [self.biography.layer setMasksToBounds:YES];

}

-(void)segueToAddCourses
{
    [self performSegueWithIdentifier:@"addCoursesSegue" sender:self];
}

-(void)requestTutor
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:[NSString stringWithFormat: @"You have requested help from %@", self.user[@"firstName"]]
                          message:[NSString stringWithFormat: @"\nThey will be expecting you at %@.", self.user[@"location"]]
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    
    // When a user taps the "request" button, This will send a push notification to the requested tutor
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"userName" equalTo:self.user[@"username"]];
    
    NSString *firstName = self.user[@"firstName"];
    NSString *lastName = self.user[@"lastName"];
    NSString *courseString = self.user[@"courseRequested"];
    NSString *message = [firstName stringByAppendingString:[lastName stringByAppendingString: [@"will be arriving soon for help with" stringByAppendingString:courseString]]];
    
    // what other info do we want? ETA? Topic? 
    
    PFPush *push = [[PFPush alloc]init];
    [push setQuery:pushQuery];
    [push setMessage:message];
    [push sendPushInBackground];
    
}

// Edit mode
- (void)setEditing:(BOOL)flag animated:(BOOL)animated
{
    [super setEditing:flag animated:animated];
    if (flag == YES){
        // Change views to edit mode.
        [self.coursesTakingTable setEditing: YES animated: YES];
        
        // Add "+" button on navigation bar
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(segueToAddCourses)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor]; // Color of "+" button
        
        [self.userFullName setEnabled:YES];
        [self.userFullName setTextColor:[UIColor blackColor]];
        [self.userFullName setBorderStyle:UITextBorderStyleRoundedRect];
        [self.userFullName setBackgroundColor:[UIColor whiteColor]];
        [self.userFullName becomeFirstResponder];
        
        [self.phoneNumber setEnabled:YES];
        [self.phoneNumber setTextColor:[UIColor blackColor]];
        [self.phoneNumber setBorderStyle:UITextBorderStyleRoundedRect];
        [self.phoneNumber setBackgroundColor:[UIColor whiteColor]];
        
        [self.biography setEditable:YES];
        [self.biography setBackgroundColor:[UIColor whiteColor]];
        [self.biography setTextColor:[UIColor blackColor]];
    }
    else {
        // Save the changes if needed and change the views to noneditable.
        NSString * fullName = self.userFullName.text;
        NSArray *firstAndLast = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        firstAndLast = [firstAndLast filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
        
        self.user[@"firstName"] = firstAndLast[0];
        self.user[@"lastName"] = firstAndLast[1];
        self.user[@"phoneNumber"] = self.phoneNumber.text;
        self.user[@"bio"] = self.biography.text;
        
        [self.user saveInBackground];
        
        [self.coursesTakingTable setEditing: NO animated: YES];
        
        self.navigationItem.rightBarButtonItem = nil;
        
        [self.userFullName setEnabled:NO];
        [self.userFullName setBorderStyle:UITextBorderStyleNone];
        [self.userFullName setBackgroundColor:[UIColor clearColor]];
        [self.userFullName setTextColor:[UIColor whiteColor]];
        
        [self.phoneNumber setEnabled:NO];
        [self.phoneNumber setBorderStyle:UITextBorderStyleNone];
        [self.phoneNumber setBackgroundColor:[UIColor clearColor]];
        [self.phoneNumber setTextColor:[UIColor whiteColor]];
        
        [self.biography setEditable:NO];
        [self.biography setBackgroundColor:[UIColor clearColor]];
        [self.biography setTextColor:[UIColor whiteColor]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // Hide navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [self.coursesTakingTable reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table View Methods

// Delete courses from table when in edit mode
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
        [self.user[@"coursesTaking"] removeObjectAtIndex:indexPath.row];
    else
        [self.user[@"coursesTutoring"] removeObjectAtIndex:indexPath.row];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

// Number of rows in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [self.user[@"coursesTaking"] count];
    else
        return [self.user[@"coursesTutoring"] count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ProfileTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Make text field of table cell non-editable
    [cell.cellTextField setEnabled:NO];
}

// Cell for row at indexpath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"profileTableCell"];
    
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CustomProfileCell" bundle:nil] forCellReuseIdentifier:@"profileTableCell"];
        cell = [tableView dequeueReusableCellWithIdentifier: @"profileTableCell"];
    }
    
    // Cells for courses taking
    if (indexPath.section == 0)
    {
        cell.cellTextField.text = [self.user[@"coursesTaking"] objectAtIndex:indexPath.row];
    }
    // Cells for courses tutoring
    else
    {
        cell.cellTextField.text = [self.user[@"coursesTutoring"] objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Current Courses";
            break;
        case 1:
            sectionName = @"Courses Tutoring";
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)logOut:(id)sender {
    
    //[PFUser logOut];
    //PFUser * currentUser = [PFUser currentUser];
}
@end
