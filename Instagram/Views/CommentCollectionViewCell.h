//
//  CommentCollectionViewCell.h
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/7/21.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTextWidthConstraint;
@property (copy, nonatomic) void (^didTapProfileImage)(PFUser *targetUser);
@property (weak, nonatomic) Post *post;

- (void)setCellWithComment:(PFObject *)comment safeAreaWidth:(CGFloat)safeAreaWidth post:(Post *)post didTapProfileImageBlock:(void(^)(PFUser *target))didTapProfileImage;

@end

NS_ASSUME_NONNULL_END
