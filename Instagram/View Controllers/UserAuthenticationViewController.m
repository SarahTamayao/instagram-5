//
//  UserAuthenticationViewController.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/3/21.
//

#import "UserAuthenticationViewController.h"
#import <Parse/Parse.h>

@interface UserAuthenticationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation UserAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapSignUp:(UIButton *)sender {
    if(self.usernameField.text.length > 0 && self.passwordField.text.length > 0){
        [self registerUser];
    }
    else {
        // TODO: Display Empty Field Error Message
    }
}

- (IBAction)didTapLogin:(UIButton *)sender {
    if(self.usernameField.text.length > 0 && self.passwordField.text.length > 0){
        [self loginUser];
    }
    else {
        // TODO: Display Empty Field Error Message
    }
}

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
        
            // manually segue to logged in view
            [self performSegueWithIdentifier:@"login" sender:self];
        }
    }];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"login" sender:self];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
