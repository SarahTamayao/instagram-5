//
//  PostDetailsViewController.h
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/7/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostDetailsViewController : UIViewController

@property (weak, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
