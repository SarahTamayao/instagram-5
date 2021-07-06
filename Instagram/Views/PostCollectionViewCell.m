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

- (void)setCellWithPost:(Post *)post screenWidth:(CGFloat)screenWidth {
    //get username
    [[APIManager shared] getPostAuthor:post completion:^(PFUser *user, NSError *error) {
        self.usernameLabel.text = user[@"username"];
    }];
    
    //setting post image
    [post[@"image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        if(!error) {
            self.postImage.image = [self resizeImage:[UIImage imageWithData:data] withSize:CGSizeMake(screenWidth, screenWidth)];
        }
    }];
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

@end
