//
//  PostDetailsViewController.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/7/21.
//

#import "PostDetailsViewController.h"
#import "PostCollectionViewCell.h"
#import "CommentCollectionViewCell.h"

@interface PostDetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) PostCollectionViewCell *postCell;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView setAlpha:0.0];
    [self setupCollectionView];
}

- (void)setupCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PostCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PostCollectionViewCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CommentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CommentCollectionViewCell"];
    
    UICollectionViewFlowLayout *layout = self.collectionView.collectionViewLayout;
//    layout.estimatedItemSize = CGSizeZero;
    layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView setContentOffset:CGPointMake(0, 1) animated:NO];
    [self.collectionView setAlpha:1.0];
}

- (nonnull UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCell" forIndexPath:indexPath];
        
        CGFloat safeAreaWidth = self.view.safeAreaLayoutGuide.layoutFrame.size.width;
        [cell setCellWithPost:self.post screenWidth:safeAreaWidth commentCode:^(PostCollectionViewCell *postCell){
            //TODO: PERFORM SEGUE
        } didTapPostImage:^(PostCollectionViewCell *postCell){
            //TODO: PERFORM SEGUE
        }];
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        return cell;
    } else {
        CommentCollectionViewCell *commentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommentCollectionViewCell" forIndexPath:indexPath];
        
        return commentCell;
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

@end
