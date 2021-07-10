//
//  PostCollectionViewCell.h
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/5/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCollectionViewCell : UICollectionViewCell

//properties
@property (strong, nonatomic) IBOutlet UIImageView *_Nonnull profileImage;
@property (strong, nonatomic) IBOutlet UILabel *_Nonnull usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *_Nonnull timeStampLabel;
@property (strong, nonatomic) IBOutlet UIImageView *_Nonnull postImage;
@property (strong, nonatomic) IBOutlet UILabel *_Nonnull captionLabel;
@property (strong, nonatomic) IBOutlet UILabel *_Nonnull likeCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *_Nonnull commentCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *_Nonnull viewCommentsLabel;
@property (strong, nonatomic) IBOutlet UIButton *_Nonnull likeButton;
@property (strong, nonatomic) Post *_Nonnull post;
@property (nonatomic, copy) void (^commentMethod)(PostCollectionViewCell *postCell);
@property (nonatomic, copy) void (^didTapPostImage)(PostCollectionViewCell *postCell);
@property (nonatomic, copy) void (^didTapProfileImage)(PostCollectionViewCell *postCell);

//methods
- (void)setCellWithPost:(Post *)post screenWidth:(CGFloat)screenWidth commentCode:(void(^)(PostCollectionViewCell *post))commentCode didTapPostImage:(void(^)(PostCollectionViewCell *postCell))didTapPostImage didTapProfileImage:(void(^)(PostCollectionViewCell *postCell))didTapProfileImage;
- (void)refreshUI;

@end

NS_ASSUME_NONNULL_END
