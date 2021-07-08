//
//  ProfileViewController.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/5/21.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "UserAuthenticationViewController.h"
#import "APIManager.h"
#import "UserProfilePostCollectionViewCell.h"
#import "PostDetailsViewController.h"
#import "Post.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self fetchData];
    
    //making profile image round
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
}


- (void)setupCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)fetchData {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.collectionView reloadData];
    }];
}

- (IBAction)didTapLogout:(UIBarButtonItem *)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.allObjects[0].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserAuthenticationViewController *userAuthenticationViewController = [storyboard instantiateViewControllerWithIdentifier:@"UserAuthenticationViewController"];
    sceneDelegate.window.rootViewController = userAuthenticationViewController;
    
    [[APIManager shared] logout:^(NSError *error){
        if (error){
            NSLog(@"Error logging out");
        } else {
            NSLog(@"Logged out successfully");
        }
    }];
}

- (IBAction)didTapChangeProfilePicture:(UIButton *)sender {
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
    
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.profileImageView.image = editedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:^(){
        
    }];
    
    //save the new image
    UIImage *resizedImage = [[APIManager shared] resizeImage:editedImage withSize:CGSizeMake(500, 500)];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    NSString *userId = [PFUser currentUser].objectId;
    [query getObjectInBackgroundWithId:userId
                                 block:^(PFObject *user, NSError *error) {
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        
        NSLog(@"%@", user);
        PFFileObject *pfImage = [Post getPFFileFromImage:resizedImage];

        user[@"profileImage"] = pfImage;
        [user saveInBackground];
    }];
}



#pragma mark - Collection View

- (nonnull UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UserProfilePostCollectionViewCell *postCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"userProfilePostCell" forIndexPath:indexPath];
    
    [postCell setCellWithPost:self.posts[indexPath.item] didTapPostBlock:^(Post *_Nonnull post){
        [self performSegueWithIdentifier:@"userProfileToPostDetails" sender:post];
    }];
    
 
    return postCell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
}

// MARK: UICollectionViewDelegateFlowLayout methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int totalwidth = self.collectionView.bounds.size.width;
    int numberOfCellsPerRow = 3;
    int dimensions = (CGFloat)(totalwidth / numberOfCellsPerRow);
    return CGSizeMake(dimensions, dimensions);
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"userProfileToPostDetails"]){
        
        Post *post = (Post *) sender;
        PostDetailsViewController *postDetailsViewController = [segue destinationViewController];
        postDetailsViewController.post = post;
        
    }
}

@end
