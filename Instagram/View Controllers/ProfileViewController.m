//
//  ProfileViewController.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/5/21.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)fetchData {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
        } else {
            NSLog(@"%@", error.localizedDescription);
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
