//
//  UserProfilePostCollectionViewCell.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/7/21.
//

#import "UserProfilePostCollectionViewCell.h"
#import "APIManager.h"

@implementation UserProfilePostCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupGestures];
}

- (void)setupGestures {
    UITapGestureRecognizer *postImageTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPostImage:)];
    [self.postImageView addGestureRecognizer:postImageTapGestureRecognizer];
    [self.postImageView setUserInteractionEnabled:YES];
}

- (void)didTapPostImage:(UIGestureRecognizer *)sender {
    //TODO: segue to post details
    NSLog(@"Tapped on image");
    if (self.didTapPostImage != nil) {
        self.didTapPostImage(self.post);
    }
}

- (void)setCellWithPost:(Post *)post didTapPostBlock:(void(^)(Post *post))didTapPost itemDimensions:(int)itemDimensions {
    self.post = post;
    self.didTapPostImage = didTapPost;
    //setting post image
    [post[@"image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        if (!error) {
            self.postImageView.alpha = 0;
            self.postImageView.image = [[APIManager shared] resizeImage:[UIImage imageWithData:data] withSize:CGSizeMake(itemDimensions - 5, itemDimensions - 5)];
            [UIView animateWithDuration:.5 animations:^{
                self.postImageView.alpha = 1;
            }];
            
        } else {
            NSLog(@"Error loading image");
        }
    }];
}

@end
