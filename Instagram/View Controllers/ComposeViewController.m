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

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;
@property (weak, nonatomic) IBOutlet UIView *imagePlaceHolderView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self launchImagePicker];
    
    [self performSegueWithIdentifier:@"cameraSegue" sender:self];
    [self setupGestures];
    [self styleCaptionTextView];
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
    [self launchImagePicker];
}

- (void)launchImagePicker {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    self.imagePlaceHolderView.hidden = true;
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.imagePreview.image = editedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:^(){
        [self.captionTextView becomeFirstResponder];
    }];
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

@end
