//
//  PostDetailsViewController.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/7/21.
//

#import "PostDetailsViewController.h"

@interface PostDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.postView addSubview:self.postContentsView];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.contentView = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
