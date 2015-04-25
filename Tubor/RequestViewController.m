//
//  RequestViewController.m
//  Tubor
//
//  Created by Jake Irvin on 3/25/15.
//  Copyright (c) 2015 Marcelo Sedano. All rights reserved.
//

#import "RequestViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface RequestViewController () 
- (IBAction)requestTutor:(id)sender;

@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set the property for the current user
    self.user = [PFUser currentUser];
    self.courses = self.user[@"coursesTaking"];
    
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x000000);
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tuborNavTitle.png"]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // Hide navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.courses count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [self.courses objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    if ([self.user[@"isAvailable"]  isEqual: @NO]) {
        
        NSInteger index = [self.chooseClass selectedRowInComponent:0];
        self.chosenCourse = [self.courses objectAtIndex:index];
        
        // get the tutors from the query
        // if they tutor the course and are available for tutoring
        PFQuery *query = [PFUser query];
        [query whereKey:@"coursesTutoring" equalTo:self.chosenCourse];
        [query whereKey:@"isAvailable" equalTo:@YES];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            
            self.tutors = [NSMutableArray new];
            [self.tutors addObjectsFromArray:results];
            [self.availableTutors reloadData];
        }];
        
        return;
    }
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:[NSString stringWithFormat: @"\nYou can't tutor and be tutored at the same time."]
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showTutorSegue"])
    {
        //if you need to pass data to the next controller do it here
        ProfileViewController * userProfileViewController = segue.destinationViewController;
        NSInteger indexForTutor = [self.availableTutors indexPathForSelectedRow].row;
        PFUser * selectedTutor = [self.tutors objectAtIndex:indexForTutor];
        
        userProfileViewController.user = selectedTutor;
        userProfileViewController.editButton = nil; // No edit button
    }
}

#pragma mark - Table View Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showTutorSegue" sender:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tutors.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    if (self.tutors.count > 0) {
        
        // get the first name of the tutors
        PFUser * aTutor = [PFUser user];
        self.nameArray = [NSMutableArray new];
        self.locationArray = [NSMutableArray new];
        self.timeArray= [NSMutableArray new];
        //self.ratingArray = [NSMutableArray new];
        for (int i = 0; i < self.tutors.count; i++) {
            
            aTutor = self.tutors[i];
            self.nameArray[i] = aTutor[@"firstName"];
            self.locationArray[i] = aTutor[@"location"];
            self.timeArray[i] = aTutor[@"timeAvailable"];
            //self.ratingArray[i] = aTutor[@"rating"];
        }
        
        NSString * tutorName = self.nameArray[indexPath.row];
        NSString * location = self.locationArray[indexPath.row];
        NSString * time = self.timeArray[indexPath.row];
        //NSString * rating = [self.ratingArray[indexPath.row];
        
        NSString * tutorInfo = [tutorName stringByAppendingString: [@" is at: " stringByAppendingString:location]];
        tutorInfo = [tutorInfo stringByAppendingString:[@" until: " stringByAppendingString:time]];

        cell.textLabel.text = tutorInfo;

    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)requestTutor:(id)sender {
    
    NSInteger indexForTutor = [self.availableTutors indexPathForSelectedRow].row;
    PFUser * selectedTutor = [self.tutors objectAtIndex:indexForTutor];
    
    self.user[@"tutorRequested"] = selectedTutor.username;
    self.user[@"courseRequested"] = self.chosenCourse;
        
    [self.user saveInBackground];
    
    // PFUser * someUser = [selectedTutor[@"tutorRequests"] objectAtIndex:0];
    // NSLog([NSString stringWithFormat:@"%@", someUser[@"firstName"]]);
    // NSLog(someUser[@"firstName"]);
}
@end












