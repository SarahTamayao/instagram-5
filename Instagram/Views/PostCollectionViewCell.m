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
}

- (void)setCellWithPost:(Post *)post screenWidth:(CGFloat)screenWidth commentCode:(void(^)(Post *post))commentCode {
    self.post = post;
    
    //get username
    [[APIManager shared] getPostAuthor:post completion:^(PFUser *user, NSError *error) {
        self.usernameLabel.text = user[@"username"];
    }];
    
    //setting post image
    [post[@"image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        if (!error) {
            self.postImage.image = [self resizeImage:[UIImage imageWithData:data] withSize:CGSizeMake(screenWidth, screenWidth)];
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
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)didTapLike:(UIButton *)sender {
    if(!self.post.isLikedByCurrentUser) {
        self.post.isLikedByCurrentUser = YES;
        
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
    self.commentMethod(self.post);
}


- (void)refreshUI {
    [self.likeButton setSelected:self.post.isLikedByCurrentUser];
    //TODO: COMPLETE THIS METHOD
}


@end
