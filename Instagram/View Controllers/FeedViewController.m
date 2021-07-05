//
//  FeedViewController.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/4/21.
//

#import "FeedViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "UserAuthenticationViewController.h"

@interface FeedViewController ()

@property (strong, nonatomic) NSMutableArray *posts;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)fetchData {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapLogout:(UIBarButtonItem *)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.allObjects[0].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserAuthenticationViewController *userAuthenticationViewController = [storyboard instantiateViewControllerWithIdentifier:@"UserAuthenticationViewController"];
    sceneDelegate.window.rootViewController = userAuthenticationViewController;
    
    [[APIManager shared] logout:^(NSError *error){
        if(error){
            NSLog(@"Error logging out");
        }
        else {
            NSLog(@"Logged out successfully");
        }
    }];
}

- (IBAction)didTapCompose:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"feedToCompose" sender:self];
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
