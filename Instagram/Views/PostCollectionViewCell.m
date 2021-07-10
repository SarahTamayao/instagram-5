//
//  PostCollectionViewCell.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/5/21.
//

#import "PostCollectionViewCell.h"
#import "Utility.h"
#import "DateTools.h"

@implementation PostCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupGestures];
    
    //set button states
    [self.likeButton setBackgroundImage: [UIImage systemImageNamed:@"heart"] forState: UIControlStateNormal];
    [self.likeButton setBackgroundImage:[UIImage systemImageNamed:@"heart.fill"] forState: UIControlStateSelected];
    
    //making profile image round
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
}

- (void)fetchProfileImage {
    PFUser *user = self.post[@"author"];
    
    [user[@"profileImage"] getDataInBackgroundWithBlock:^(NSData *_Nullable data, NSError *_Nullable error) {
        if (!error) {
            self.profileImage.image = [UIImage imageWithData:data];
        }
    }];
}

- (void)setupGestures {
    //gesture for post image
    UITapGestureRecognizer *postImageTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPostImage:)];
    [self.postImage addGestureRecognizer:postImageTapGestureRecognizer];
    [self.postImage setUserInteractionEnabled:YES];
    
    //setup gesture for view comments label
    UITapGestureRecognizer *viewCommentsLabelGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPostImage:)]; //same action as tapping post image
    [self.viewCommentsLabel addGestureRecognizer:viewCommentsLabelGestureRecognizer];
    [self.viewCommentsLabel setUserInteractionEnabled:YES];
    
    //gesture for profile image
    UITapGestureRecognizer *profileImageTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProfileImage:)];
    [self.profileImage addGestureRecognizer:profileImageTapGestureRecognizer];
    [self.profileImage setUserInteractionEnabled:YES];
}

- (void)didTapProfileImage:(UITapGestureRecognizer *)sender {
    self.didTapProfileImage(self);
}

- (void)didTapPostImage:(UITapGestureRecognizer *)sender {
    self.didTapPostImage(self);
}

- (void)setCellWithPost:(Post *)post
            screenWidth:(CGFloat)screenWidth
            commentCode:(void(^)(PostCollectionViewCell *post))commentCode
        didTapPostImage:(void(^)(PostCollectionViewCell *postCell))didTapPostImage
     didTapProfileImage:(void(^)(PostCollectionViewCell *postCell))didTapProfileImage {
    
    _post = post;
    
    //get username
    PFUser *user= self.post[@"author"];
    self.usernameLabel.text = user[@"username"];
    
    //setting timestamp
    NSDate *createdAtDate = self.post.createdAt;
    NSString *timePassed = [createdAtDate shortTimeAgoSinceNow];
    self.timeStampLabel.text = [NSString stringWithFormat:@"%@ ago", timePassed];
    
    //setting post image
    [post[@"image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        if (!error) {
            self.postImage.image = [Utility resizeImage:[UIImage imageWithData:data] withSize:CGSizeMake(screenWidth, screenWidth)];
        } else {
            NSLog(@"Error loading image");
        }
    }];
    
    self.captionLabel.text = post[@"caption"];
    
    //set cell buttons
    [self.likeButton setSelected:post.isLikedByCurrentUser];
    
    self.commentMethod = commentCode;
    
    if (didTapPostImage) {
        self.didTapPostImage = didTapPostImage;
    } else {
        self.didTapPostImage = ^(PostCollectionViewCell *postCell){};
    }
    
    self.didTapProfileImage = didTapProfileImage;
    
    [self fetchProfileImage];
    
    [self refreshUI];
}

- (IBAction)didTapLike:(UIButton *)sender {
    if(!self.post.isLikedByCurrentUser) {
        self.post.isLikedByCurrentUser = YES;
        
        //increasing like count in Post object
        NSExpression *ex = [NSExpression expressionWithFormat:@"(%@ + %@)", self.post.likeCount, @1];
        self.post.likeCount = [ex expressionValueWithObject:nil context:nil];
        [self.post saveInBackground];
        
        
        [Utility createLike:self.post completion:^(BOOL succeeded, BOOL likeExisted, NSError *error) {
            if (error) {
                NSLog(@"Error saving like: %@", error.localizedDescription);
            } else if (likeExisted) {
                
            } else {
                NSLog(@"Successfully saved like");
            }
        }];
    }
    else {
        self.post.isLikedByCurrentUser = NO;
        
        //decreasing like count in Post object
        NSExpression *ex = [NSExpression expressionWithFormat:@"(%@ - %@)", self.post.likeCount, @1];
        self.post.likeCount = [ex expressionValueWithObject:nil context:nil];
        [self.post saveInBackground];
        
        [Utility deleteLike:self.post completion:^(BOOL succeeded, NSError *error){
            if (error){
                NSLog(@"Error deleting like: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully deleted like");
            }
        }];
    }
    
    [self refreshUI];
}

- (IBAction)didTapComment:(UIButton *)sender {
    self.commentMethod(self);
}


- (void)refreshUI {
    [self.likeButton setSelected:self.post.isLikedByCurrentUser];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@ Likes", self.post.likeCount];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@ Comments", self.post.commentCount];
}


@end
