//
//  PostDetailsViewController.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/7/21.
//

#import "PostDetailsViewController.h"
#import "PostCollectionViewCell.h"
#import "CommentCollectionViewCell.h"
#import "ComposeCommentViewController.h"
#import "ProfileViewController.h"

@interface PostDetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) PostCollectionViewCell *postCell;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *comments;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView setAlpha:0.0];
    [self setupCollectionView];
    [self fetchComments];
}

- (void)setupCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PostCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PostCollectionViewCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CommentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CommentCollectionViewCell"];
    
    UICollectionViewFlowLayout *layout = self.collectionView.collectionViewLayout;
//    layout.estimatedItemSize = CGSizeZero;
    layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    
}

- (void)fetchComments {
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"postId" equalTo:self.post.objectId];
    [query includeKey:@"userId"];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *_Nullable comments, NSError *_Nullable error){
        if (!error) {
            self.comments = comments;
        }
        [self.collectionView reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView setContentOffset:CGPointMake(0, 1) animated:NO];
    [self.collectionView setAlpha:1.0];
}

- (nonnull UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCell" forIndexPath:indexPath];
        
        CGFloat safeAreaWidth = self.view.safeAreaLayoutGuide.layoutFrame.size.width;
        [cell setCellWithPost:self.post screenWidth:safeAreaWidth commentCode:^(PostCollectionViewCell *postCell){
            [self performSegueWithIdentifier:@"detailsToComposeComment" sender:postCell];
        } didTapPostImage:^(PostCollectionViewCell *postCell){

        } didTapProfileImage:^(PostCollectionViewCell *postCell){
            //do nothing because we already came from a user profile
        }];
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        cell.viewCommentsLabel.alpha = 0;
        
        return cell;
    } else {
        CommentCollectionViewCell *commentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommentCollectionViewCell" forIndexPath:indexPath];
        
        commentCell.profileImageView.image = nil;
        
        PFObject *comment = self.comments[indexPath.item - 1];
        CGFloat safeAreaWidth = self.view.safeAreaLayoutGuide.layoutFrame.size.width;
        [commentCell setCellWithComment:comment safeAreaWidth:safeAreaWidth post:self.post didTapProfileImageBlock:^(PFUser *user){
            [self performSegueWithIdentifier:@"detailsToProfile" sender:user];
        }];
        
        return commentCell;
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.comments.count + 1;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"detailsToComposeComment"]) {
        
        PostCollectionViewCell *postCell = (PostCollectionViewCell *) sender;
        ComposeCommentViewController *destinationController = [segue destinationViewController];
        destinationController.postCell = postCell;
        
    } else if ([segue.identifier isEqualToString:@"detailsToProfile"]) {
        PFUser *targetUser = (PFUser *) sender;
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.targetUser = targetUser;
    }
}

@end
