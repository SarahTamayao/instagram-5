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

@property (weak, nonatomic) PostCollectionViewCell *postCell;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@end

NS_ASSUME_NONNULL_END
