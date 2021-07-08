//
//  CommentCollectionViewCell.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/7/21.
//

#import "CommentCollectionViewCell.h"

@implementation CommentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //making profile image round
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
}

@end
