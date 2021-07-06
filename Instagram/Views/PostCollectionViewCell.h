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
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *captionWidth;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

//methods
- (void)setCellWithPost:(Post *)post screenWidth:(CGFloat)screenWidth;

@end

NS_ASSUME_NONNULL_END
