//
//  UserProfilePostCollectionViewCell.h
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/7/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserProfilePostCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) Post *_Nonnull post;
@property (strong, nonatomic) IBOutlet UIImageView *_Nonnull postImageView;
@property (nonatomic, copy) void (^didTapPostImage)(Post *postCell);

- (void)setCellWithPost:(Post *)post
        didTapPostBlock:(void(^)(Post *post))didTapPost
         itemDimensions:(int)itemDimensions;

@end

NS_ASSUME_NONNULL_END
