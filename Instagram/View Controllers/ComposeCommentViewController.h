//
//  ComposeCommentViewController.h
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/6/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "PostCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposeCommentViewController : UIViewController

@property (strong, nonatomic) PostCollectionViewCell *_Nonnull postCell;
@property (strong, nonatomic) IBOutlet UITextView *_Nonnull commentTextView;

@end

NS_ASSUME_NONNULL_END
