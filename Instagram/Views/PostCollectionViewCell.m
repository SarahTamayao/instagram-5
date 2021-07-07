//
//  PostCollectionViewCell.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/5/21.
//

#import "PostCollectionViewCell.h"
#import "APIManager.h"

@implementation PostCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //adding a tap recoginzer to post image
    UITapGestureRecognizer *postImageTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPostImage:)];
    [self.postImage addGestureRecognizer:postImageTapGestureRecognizer];
    [self.postImage setUserInteractionEnabled:YES];
}

- (void)didTapPostImage:(UITapGestureRecognizer *)sender {
    self.didTapPostImage(self);
}

- (void)setCellWithPost:(Post *)post screenWidth:(CGFloat)screenWidth commentCode:(void(^)(PostCollectionViewCell *post))commentCode didTapPostImage:(void(^)(PostCollectionViewCell *postCell))didTapPostImage{
    self.post = post;
    
    //get username
    PFUser *user= self.post[@"author"];
    self.usernameLabel.text = user[@"username"];

    //setting post image
    [post[@"image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        if (!error) {
            self.postImage.image = [[APIManager shared] resizeImage:[UIImage imageWithData:data] withSize:CGSizeMake(screenWidth, screenWidth)];
        }
    }];
    
    self.captionLabel.text = post[@"caption"];
    
    //setting buttons
    //set cell buttons
    [self.likeButton setBackgroundImage: [UIImage systemImageNamed:@"heart"] forState: UIControlStateNormal];
    [self.likeButton setBackgroundImage:[UIImage systemImageNamed:@"heart.fill"] forState: UIControlStateSelected];
    [self.likeButton setSelected:post.isLikedByCurrentUser];
    
    //making profile image round
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    
    self.commentMethod = commentCode;
    self.didTapPostImage = didTapPostImage;
    
    [self refreshUI];
}

- (IBAction)didTapLike:(UIButton *)sender {
    if(!self.post.isLikedByCurrentUser) {
        self.post.isLikedByCurrentUser = YES;
        
        //increasing like count in Post object
        NSExpression *ex = [NSExpression expressionWithFormat:@"(%@ + %@)", self.post.likeCount, @1];
        self.post.likeCount = [ex expressionValueWithObject:nil context:nil];
        [self.post saveInBackground];
        
        
        [[APIManager shared] createLike:self.post completion:^(BOOL succeeded, BOOL likeExisted, NSError *error) {
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
        
        [[APIManager shared] deleteLike:self.post completion:^(BOOL succeeded, NSError *error){
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
