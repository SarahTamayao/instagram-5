//
//  ProfileViewController.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/5/21.
//

#import "ProfileViewController.h"
#import "SceneDelegate.h"
#import "UserAuthenticationViewController.h"
#import "Utility.h"
#import "UserProfilePostCollectionViewCell.h"
#import "PostDetailsViewController.h"
#import "Post.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *_Nonnull collectionView;
@property (strong, nonatomic) NSMutableArray *_Nullable posts;
@property (strong, nonatomic) IBOutlet UIImageView *_Nonnull profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *_Nonnull usernameLabel;
@property (strong, nonatomic) IBOutlet UIButton *_Nonnull changePictureButton;
@property (assign, nonatomic) int collectionViewItemDimensions;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"View did load");
    
    if (self.targetUser == nil) {
        self.targetUser = [PFUser currentUser];
    } else {
        //looking at another user's profile
        self.changePictureButton.alpha = 0;

    }
    
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
    [query whereKey:@"author" equalTo:self.targetUser];
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
    
    //fetch user profile image    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
    NSString *userId = self.targetUser.objectId;
    [userQuery getObjectInBackgroundWithId:userId
                                 block:^(PFObject *user, NSError *error) {
        
        self.usernameLabel.text = user[@"username"];
        [user[@"profileImage"] getDataInBackgroundWithBlock:^(NSData *_Nullable data, NSError *_Nullable error) {
            if (!error) {
                self.profileImageView.image = [UIImage imageWithData:data];
            }
        }];
    }];
}

- (IBAction)didTapLogout:(UIBarButtonItem *)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.allObjects[0].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserAuthenticationViewController *userAuthenticationViewController = [storyboard instantiateViewControllerWithIdentifier:@"UserAuthenticationViewController"];
    sceneDelegate.window.rootViewController = userAuthenticationViewController;
    
    [Utility logout:^(NSError *error){
        if (error){
            NSLog(@"Error logging out");
        } else {
            NSLog(@"Logged out successfully");
        }
    }];
}

- (IBAction)didTapChangeProfilePicture:(UIButton *)sender {
    if (self.targetUser != [PFUser currentUser]) {
        return; //only allow users to change image on their own profile
    }
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:^(){
        
    }];
    
    //save the new image
    UIImage *resizedImage = [Utility resizeImage:editedImage withSize:CGSizeMake(500, 500)];
    self.profileImageView.image = resizedImage;
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    NSString *userId = [PFUser currentUser].objectId;
    [query getObjectInBackgroundWithId:userId
                                 block:^(PFObject *user, NSError *error) {
        PFFileObject *pfImage = [Post getPFFileFromImage:resizedImage];

        user[@"profileImage"] = pfImage;
        [user saveInBackground];
    }];
}



#pragma mark - Collection View

- (nonnull UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                          cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UserProfilePostCollectionViewCell *postCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"userProfilePostCell" forIndexPath:indexPath];
    
    [postCell setCellWithPost:self.posts[indexPath.item] didTapPostBlock:^(Post *_Nonnull post){
        [self performSegueWithIdentifier:@"userProfileToPostDetails" sender:post];
    } itemDimensions:self.collectionViewItemDimensions];
    
 
    return postCell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

// MARK: UICollectionViewDelegateFlowLayout methods
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int totalwidth = self.collectionView.bounds.size.width;
    int numberOfCellsPerRow = 3;
    int dimensions = (CGFloat)(totalwidth / numberOfCellsPerRow);

    self.collectionViewItemDimensions = dimensions;
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
