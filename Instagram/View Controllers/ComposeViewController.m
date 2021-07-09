//
//  ComposeViewController.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/5/21.
//

#import "ComposeViewController.h"
#import "SceneDelegate.h"
#import "Post.h"
#import "Utility.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "CustomCameraViewController.h"

@interface ComposeViewController () <UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;
@property (weak, nonatomic) IBOutlet UIView *imagePlaceHolderView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGestures];
    [self styleCaptionTextView];
    [self performSegueWithIdentifier:@"cameraSegue" sender:self];
}

- (void)styleCaptionTextView {
    self.captionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.captionTextView.layer.borderWidth = 1;
    self.captionTextView.layer.cornerRadius = 10.0f;
}

- (void)setupGestures {
    UITapGestureRecognizer *imageTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImage:)];
    [self.imagePlaceHolderView addGestureRecognizer:imageTapGestureRecognizer];
    [self.imagePlaceHolderView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *selectedImageTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImage:)];
    [self.imagePreview addGestureRecognizer:selectedImageTapGestureRecognizer];
    [self.imagePreview setUserInteractionEnabled:YES];
}

- (void)didTapImage: (UITapGestureRecognizer *)sender {
    NSLog(@"tapped on image");
    [self performSegueWithIdentifier:@"cameraSegue" sender:self];
}

- (void)didFinishPickingMediaWithImage:(UIImage *)image {
    self.imagePreview.image = image;
    [self.captionTextView becomeFirstResponder];
}

- (IBAction)didTapCancel:(UIBarButtonItem *)sender {
    [self returnToFeed];
}

- (IBAction)didTapShare:(UIBarButtonItem *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIImage *resizedImage = [Utility resizeImage:self.imagePreview.image withSize:CGSizeMake(500, 500)];
    [Post postUserImage:resizedImage withCaption:self.captionTextView.text withCompletion:^(BOOL succeeded, NSError *_Nullable error){
        if(succeeded) {
            NSLog(@"Successfully uploaded post");
            [self returnToFeed];
        }
        else {
            NSLog(@"Error uploading post: %@", error.localizedDescription);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)returnToFeed {
    SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.allObjects[0].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *feedNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    sceneDelegate.window.rootViewController = feedNavigationController;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"cameraSegue"]) {
        
        CustomCameraViewController *customCameraViewController = [segue destinationViewController];
        customCameraViewController.didFinishPickingMediaWithImage = ^(UIImage *image) {
            [self didFinishPickingMediaWithImage:image];
        };
        
    }
}

@end
