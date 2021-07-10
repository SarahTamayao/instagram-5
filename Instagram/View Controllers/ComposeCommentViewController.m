//
//  ComposeCommentViewController.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/6/21.
//

#import "ComposeCommentViewController.h"
#import <Parse/Parse.h>

@interface ComposeCommentViewController ()

@end

@implementation ComposeCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.commentTextView becomeFirstResponder];
}

- (IBAction)didTapCancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapSend:(UIButton *)sender {
    PFObject *newComment = [PFObject objectWithClassName:@"Comment"];
    newComment[@"userId"] = [PFUser currentUser];
    newComment[@"postId"] = self.postCell.post.objectId;
    newComment[@"commentText"] = self.commentTextView.text;
    
    [newComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (error) {
            NSLog(@"Error saving comment: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully saved comment");
        }
    }];
    
    //increasing comment count in Post object
    NSExpression *ex = [NSExpression expressionWithFormat:@"(%@ + %@)", self.postCell.post.commentCount, @1];
    self.postCell.post.commentCount = [ex expressionValueWithObject:nil context:nil];
    [self.postCell.post saveInBackground];
    
    [self.postCell refreshUI];
    
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
