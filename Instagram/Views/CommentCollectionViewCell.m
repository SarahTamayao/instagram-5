//
//  CommentCollectionViewCell.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/7/21.
//

#import "CommentCollectionViewCell.h"
#import <Parse/Parse.h>

@implementation CommentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //making profile image round
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    
    [self setupGestures];
}

- (void)setupGestures {
    UITapGestureRecognizer *profileImageTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProfileImage:)];
    [self.profileImageView addGestureRecognizer:profileImageTapGestureRecognizer];
    [self.profileImageView setUserInteractionEnabled:YES];
}

- (void)didTapProfileImage:(UITapGestureRecognizer *)sender {
    if (self.didTapProfileImage != nil) {
        self.didTapProfileImage(self.post.author);
    } else {
        NSLog(@"NIL block for didTapProfileImage");
    }
}

- (void)setCellWithComment:(nonnull PFObject *)comment safeAreaWidth:(CGFloat)safeAreaWidth post:(nonnull Post *)post didTapProfileImageBlock:(void(^)(PFUser *target))didTapProfileImage {
    self.usernameLabel.text = comment[@"userId"][@"username"];
    self.commentTextLabel.text = comment[@"commentText"];
    self.commentTextWidthConstraint.constant = safeAreaWidth - 80;
    
    [comment[@"userId"][@"profileImage"] getDataInBackgroundWithBlock:^(NSData *_Nullable data, NSError *_Nullable error) {
        if (!error) {
            self.profileImageView.image = [UIImage imageWithData:data];
        }
    }];
    
    self.post = post;
    
    self.didTapProfileImage = didTapProfileImage;
    
    [self fetchProfileImage];
}

- (void)fetchProfileImage {
    //fetch user profile image
    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
    NSString *userId = self.post.userID;
    [userQuery getObjectInBackgroundWithId:userId
                                 block:^(PFObject *user, NSError *error) {
        [user[@"profileImage"] getDataInBackgroundWithBlock:^(NSData *_Nullable data, NSError *_Nullable error) {
            if (!error) {
                self.profileImageView.image = [UIImage imageWithData:data];
            }
        }];
    }];
}

@end
