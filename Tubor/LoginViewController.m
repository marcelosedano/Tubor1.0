//
//  LoginViewController.m
//  Tubor
//
//  Created by Marcelo Sedano on 3/24/15.
//  Copyright (c) 2015 Marcelo Sedano. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet TuborBlueButton *loginButton;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet TuborBlueButton *registerButton;
- (IBAction)register:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Initialize text for buttons
    self.loginButton.buttonText = @"Log in";
    self.registerButton.buttonText = @"Register";
    
    // Initialize placeholder text for each text field
    self.usernameText.placeholder = @"Username";
    self.passwordText.placeholder = @"Password";
    
    // Supposed to hide "Back" button in navigation bar >:(
    [self.navigationItem setHidesBackButton:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // Hide navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// Delegate methods for the textfield placeholders

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField setValue:[UIColor clearColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField setValue:[UIColor colorWithWhite: 0.70 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// Hides keyboard when user taps somewhere other than the keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"loginToProfileSegue"])
    {
        UITabBarController * tabBarVC = [[segue.destinationViewController viewControllers] firstObject];
        ProfileViewController * userProfileViewController = [[tabBarVC viewControllers] firstObject];

        //if you need to pass data to the next controller do it here
        userProfileViewController.user = [PFUser currentUser];
        userProfileViewController.previousVC = @"Login";
    }
}

- (IBAction)login:(id)sender {
    
    
    // get the username and password from the text fields
    NSString * username = [NSString stringWithString:self.usernameText.text];
    NSString * password = [NSString stringWithString:self.passwordText.text];
    
    // try to login
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (user)
        {
            [self performSegueWithIdentifier:@"loginToProfileSegue" sender:self];
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            currentInstallation[@"username"] = [PFUser currentUser].username;
            [[PFUser currentUser] saveInBackground];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Invalid username or password"
                                  message:[NSString stringWithFormat: @"\nThe username and password you entered did not match our records.  Please double-check and try again."]
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}
- (IBAction)register:(id)sender {
    
    [self performSegueWithIdentifier:@"loginToRegistrationSegue" sender:self];
}
@end