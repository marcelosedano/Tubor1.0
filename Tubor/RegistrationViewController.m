//
//  RegistrationViewController.m
//  Tubor
//
//  Created by Marcelo Sedano on 3/24/15.
//  Copyright (c) 2015 Marcelo Sedano. All rights reserved.
//

#import "RegistrationViewController.h"

#define trimString(object) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
#define USERNAME_MIN 4
#define USERNAME_MAX 10
#define PASSWORD_MIN 4
#define PASSWORD_MAX 10


@interface RegistrationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *firstNameText;
@property (weak, nonatomic) IBOutlet UITextField *lastNameText;
- (IBAction)register:(id)sender;
@property (weak, nonatomic) IBOutlet TuborBlueButton *registerButton;
- (IBAction)cancelButton:(id)sender;
@property PFUser * aUser;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialize text for button
    self.registerButton.buttonText = @"Register";
    
    // Initialize placeholder text for each text field
    self.usernameText.placeholder = @"Enter username";
    self.passwordText.placeholder = @"Enter password";
    self.confirmPasswordText.placeholder = @"Confirm password";
    self.emailText.placeholder = @"Enter email";
    self.firstNameText.placeholder = @"Enter first name";
    self.lastNameText.placeholder = @"Enter last name";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// Hide keyboard when user taps outside of keyboard area
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// a conditional segue if the user correctly fills out registration form
-(void)loadDestinationVC: (BOOL) succeeded {
    if(succeeded == YES){
        
        [self performSegueWithIdentifier:@"registerSegue" sender:self];
    }
}

// Delegate methods for the textfield placeholders

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField setValue:[UIColor clearColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField setValue:[UIColor colorWithWhite: 0.70 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)highlightErrorField:(UITextField *)textfield {
    
    UIColor * errorColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.3];
    
    UITextField *errorField = (UITextField *) textfield;
    [UIView animateWithDuration:4.0 animations:^{
        errorField.backgroundColor = errorColor;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:2.0 animations:^{
            errorField.backgroundColor = [UIColor whiteColor];
        } completion:NULL];
    }];
}

/*
// send the same user over to the ProfileViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ProfileViewController * dest = segue.destinationViewController;
     dest.user = self.aUser;
    
} */

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"loginToProfileSegue"])
    {
        UITabBarController * tabBarVC = [[segue.destinationViewController viewControllers] firstObject];
        ProfileViewController * userProfileViewController = [[tabBarVC viewControllers] firstObject];
        
        //if you need to pass data to the next controller do it here
        userProfileViewController.user = self.user;
        userProfileViewController.editButton = [userProfileViewController editButtonItem];
    }
}*/

- (IBAction)register:(id)sender {
    
    //[self performSegueWithIdentifier:@"registrationToProfileSegue" sender:self];
    
    
    // Dictionary of all text entries from registration fields
    NSDictionary * registrationInfo = @{
                                        @"username" : trimString([NSString stringWithString:self.usernameText.text]),
                                        @"password" : trimString([NSString stringWithString:self.passwordText.text]),
                                        @"confirm"  : trimString([NSString stringWithString:self.confirmPasswordText.text]),
                                        @"email"    : trimString([NSString stringWithString:self.emailText.text]),
                                        @"firstName": trimString([NSString stringWithString:self.firstNameText.text]),
                                        @"lastName" : trimString([NSString stringWithString:self.lastNameText.text])
                                        };
    
    
#pragma mark - Username Check
    
    // Check if username field is empty
    if ([registrationInfo[@"username"] length] == 0)
    {
        // Highlight text field with error
        [self highlightErrorField:self.usernameText];
        
        // Alert user to enter a username
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Invalid Username"
                              message:[NSString stringWithFormat: @"\nPlease enter a username"]
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    // Username field is not empty
    else
    {
        // Check if username is between 4-10 characters long
        if (([registrationInfo[@"username"] length] < USERNAME_MIN)
            || ([registrationInfo[@"username"] length] > USERNAME_MAX))
        {
            // Highlight text field with error
            [self highlightErrorField:self.usernameText];
            
            // Alert user to enter a username with correct with length
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Invalid Username"
                                  message:[NSString stringWithFormat: @"\nUsername must be 4-10 characters long"]
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            
            return;
        }
    }
    
#pragma mark - Password Check
    
    // Check if password field is empty
    if ([registrationInfo[@"password"] length] == 0)
    {
        // Highlight text field with error
        [self highlightErrorField:self.passwordText];
        
        // Alert user to enter a password
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Invalid Password"
                              message:[NSString stringWithFormat: @"\nPlease enter a password"]
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    // Password field is not empty
    else
    {
        // Check if password is between 4-10 characters long
        if (([registrationInfo[@"password"] length] < PASSWORD_MIN)
            || ([registrationInfo[@"password"] length] > PASSWORD_MAX))
        {
            // Highlight text field with error
            [self highlightErrorField:self.passwordText];
            
            // Alert user to enter a username with correct with length
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Invalid Password"
                                  message:[NSString stringWithFormat: @"\nPassword must be 4-10 characters long"]
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            
            return;
        }
    }
    
#pragma mark - Confirm Password Check
    
    // Check if confirm field matches password field
    if (![registrationInfo[@"confirm"] isEqualToString: registrationInfo[@"password"]])
    {
        // Highlight text field with error
        [self highlightErrorField:self.confirmPasswordText];
        
        // Alert user to enter matching password in confirm field
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Invalid Password"
                              message:[NSString stringWithFormat: @"\nPasswords do not match"]
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
#pragma mark - Email Check
    
    // Check if email field is empty
    if ([registrationInfo[@"email"] length] == 0)
    {
        // Highlight text field with error
        [self highlightErrorField:self.emailText];
        
        // Alert user to enter an email
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Invalid Email"
                              message:[NSString stringWithFormat: @"\nPlease enter an email"]
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    // Email field is not empty
    else
    {
    }
    
#pragma mark - First Name Check
    
    // Check if first name field is empty
    if ([registrationInfo[@"firstName"] length] == 0)
    {
        // Highlight text field with error
        [self highlightErrorField:self.firstNameText];
        
        // Alert user to enter a first name
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Invalid First Name"
                              message:[NSString stringWithFormat: @"\nPlease enter a first name"]
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    // First name field is not empty
    else
    {
    }
    
#pragma mark - Last Name Check
    
    // Check if last name field is empty
    if ([registrationInfo[@"lastName"] length] == 0)
    {
        // Highlight text field with error
        [self highlightErrorField:self.lastNameText];
        
        // Alert user to enter a last name
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Invalid Last Name"
                              message:[NSString stringWithFormat: @"\nPlease enter a last name"]
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    // Last name field is not empty
    else
    {
    }
    
#pragma mark - Create New User
    
    // Create a new user object from registration info
    PFUser * user = [PFUser user];
    user.username = registrationInfo[@"username"];
    user.password = registrationInfo[@"password"];
    user.email = registrationInfo[@"email"];
    user[@"firstName"] = registrationInfo[@"firstName"];
    user[@"lastName"] = registrationInfo[@"lastName"];
    user[@"coursesTaking"] = [[NSMutableArray alloc] init];
    user[@"coursesTutoring"] = [[NSMutableArray alloc] init];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Segue to the profile view controller
            
            //[self performSegueWithIdentifier:@"registrationToProfileSegue" sender:self];
            [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
            
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Try Again"
                                  message:[NSString stringWithFormat: @"\nSorry, %@", errorString]
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }];
    
}

- (IBAction)cancelButton:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
}
@end
