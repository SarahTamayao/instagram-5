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

- (void)setCellWithPost:(Post *)post {
    //get username
    [[APIManager shared] getPostAuthor:post completion:^(PFUser *user, NSError *error) {
        self.usernameLabel.text = user[@"username"];
    }];
    
    //setting post image
    [post[@"image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        if(!error) {
            self.postImage.image = [UIImage imageWithData:data];
        }
    }];
}



@end
