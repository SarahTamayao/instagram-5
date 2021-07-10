//
//  UserAuthenticationViewController.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/3/21.
//

#import "UserAuthenticationViewController.h"
#import <Parse/Parse.h>
#import "Utility.h"

@interface UserAuthenticationViewController ()
@property (strong, nonatomic) IBOutlet UITextField *_Nonnull usernameField;
@property (strong, nonatomic) IBOutlet UITextField *_Nonnull passwordField;
@property (strong, nonatomic) UIAlertController *_Nonnull alert;
@property (strong, nonatomic) IBOutlet UIButton *_Nonnull loginButton;
@property (strong, nonatomic) IBOutlet UIButton *_Nonnull signUpButton;

@end

@implementation UserAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAlert];
    [self styleComponents];
    [self setupGestures];
}

- (void)setupGestures {
    UITapGestureRecognizer *screenTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapScreen:)];
    [self.view addGestureRecognizer:screenTapGestureRecognizer];
    [self.view setUserInteractionEnabled:YES];
}

- (void)didTapScreen:(UIGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)styleComponents {
    //styling buttons
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = true;
    
    self.signUpButton.layer.cornerRadius = 5;
    self.signUpButton.layer.masksToBounds = true;
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
        [Utility registerUser:self.usernameField.text password:self.passwordField.text completion:^(BOOL succeeded, NSError *error){
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
        [Utility loginUser:self.usernameField.text password:self.passwordField.text completion:^(PFUser *user, NSError *error){
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
