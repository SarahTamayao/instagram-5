//
//  ComposeViewController.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/5/21.
//

#import "ComposeViewController.h"
#import "SceneDelegate.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapCancel:(UIBarButtonItem *)sender {
    [self returnToFeed];
}

- (IBAction)didTapShare:(UIBarButtonItem *)sender {
    [self returnToFeed];
}

- (void)returnToFeed {
    SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.allObjects[0].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *feedNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"FeedNavigationController"];
    sceneDelegate.window.rootViewController = feedNavigationController;
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
