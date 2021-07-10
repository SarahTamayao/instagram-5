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
@property (strong, nonatomic) IBOutlet UIImageView *_Nonnull profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *_Nonnull usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *_Nonnull commentTextLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *_Nonnull commentTextWidthConstraint;
@property (strong, nonatomic) void (^didTapProfileImage)(PFUser *targetUser);
@property (strong, nonatomic) Post *_Nonnull post;

- (void)setCellWithComment:(PFObject *)comment
             safeAreaWidth:(CGFloat)safeAreaWidth
                      post:(Post *)post
   didTapProfileImageBlock:(void(^)(PFUser *target))didTapProfileImage;

@end

NS_ASSUME_NONNULL_END
