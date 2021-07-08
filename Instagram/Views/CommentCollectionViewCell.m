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
    [self fetchProfileImage];
}

- (void)fetchProfileImage {
    //fetch user profile image
    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
    NSString *userId = [PFUser currentUser].objectId;
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
