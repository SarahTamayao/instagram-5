//
//  UserAuthenticationViewController.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/3/21.
//

#import "UserAuthenticationViewController.h"
#import <Parse/Parse.h>
#import "APIManager.h"

@interface UserAuthenticationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) UIAlertController *alert;

@end

@implementation UserAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAlert];
}

- (void)setupAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Empty fields"
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
    // handle response here.
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    self.alert = alert;
}

- (void)presentAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    self.alert.title = title;
    self.alert.message = message;
    [self presentViewController:self.alert animated:YES completion:^{}];
}

- (IBAction)didTapSignUp:(UIButton *)sender {
    if(self.usernameField.text.length > 0 && self.passwordField.text.length > 0){
        [[APIManager shared] registerUser:self.usernameField.text password:self.passwordField.text completion:^(BOOL succeeded, NSError *error){
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self presentAlertWithTitle:@"Error" andMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
            } else {
                NSLog(@"User registered successfully");
                
                // manually segue to logged in view
                [self performSegueWithIdentifier:@"login" sender:self];
            }
        }];
    }
    else {
        [self presentAlertWithTitle:@"Error" andMessage:@"Empty fields"];
    }
}

- (IBAction)didTapLogin:(UIButton *)sender {
    if(self.usernameField.text.length > 0 && self.passwordField.text.length > 0){
        [[APIManager shared] loginUser:self.usernameField.text password:self.passwordField.text completion:^(PFUser *user, NSError *error){
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self presentAlertWithTitle:@"Error" andMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
            } else {
                NSLog(@"User logged in successfully");
                
                // manually segue to logged in view
                [self performSegueWithIdentifier:@"login" sender:self];
            }
        }];
    } else {
        [self presentAlertWithTitle:@"Error" andMessage:@"Empty fields"];
    }
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
