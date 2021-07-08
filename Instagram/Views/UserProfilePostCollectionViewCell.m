//
//  UserProfilePostCollectionViewCell.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/7/21.
//

#import "UserProfilePostCollectionViewCell.h"
#import "APIManager.h"

@implementation UserProfilePostCollectionViewCell

- (void)setCellWithPost:(Post *)post {
    //setting post image
    [post[@"image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        if (!error) {
            NSLog(@"%@", data);
            self.postImageView.image = [[APIManager shared] resizeImage:[UIImage imageWithData:data] withSize:CGSizeMake(500, 500)];
        } else {
            NSLog(@"Error loading image");
        }
    }];
}

@end
