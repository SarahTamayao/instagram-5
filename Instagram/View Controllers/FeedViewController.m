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
#import  "PostCollectionViewCell.h"

@interface FeedViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PostCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PostCollectionViewCell"];
    
    UICollectionViewFlowLayout *layout = self.collectionView.collectionViewLayout;
    layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    
    [self fetchData];
}

- (void)fetchData {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            
            //resetting isLikedByCurrentUser
            for (Post *post in posts) {
                post.isLikedByCurrentUser = NO;
            }
            
            //set isLikedByCurrentUser for each post received
            PFQuery *likesQuery = [PFQuery queryWithClassName:@"Like"];
            [likesQuery whereKey:@"userId" equalTo:[PFUser currentUser]];

            [likesQuery findObjectsInBackgroundWithBlock:^(NSArray *likes, NSError *error){
                if (error) {
                    NSLog(@"Error fetching likes");
                } else {
                    for (Post *post in self.posts) {
                        for(PFObject *like in likes) {
                            if([post.objectId isEqualToString: like[@"postId"]]){
                                post.isLikedByCurrentUser = YES;
                            }
                        }
                    }
                }
                [self.collectionView reloadData];
            }];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        
        [self.collectionView reloadData];
        NSLog(@"done loading posts");
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

- (IBAction)didTapCompose:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"feedToCompose" sender:self];
}

#pragma mark - CollectionView methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCell" forIndexPath:indexPath];
    
    CGFloat safeAreaWidth = self.view.safeAreaLayoutGuide.layoutFrame.size.width;
    [cell setCellWithPost:self.posts[indexPath.item] screenWidth:safeAreaWidth];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    return cell;
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
