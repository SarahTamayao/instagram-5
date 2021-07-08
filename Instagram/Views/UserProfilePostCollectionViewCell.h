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
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

- (void)setCellWithPost:(Post *)post;
@end

NS_ASSUME_NONNULL_END
