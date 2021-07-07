//
//  PostDetailsViewController.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/7/21.
//

#import "PostDetailsViewController.h"
#import "PostCollectionViewCell.h"

@interface PostDetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) PostCollectionViewCell *postCell;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
}

- (void)setupCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PostCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PostCollectionViewCell"];
    
    UICollectionViewFlowLayout *layout = self.collectionView.collectionViewLayout;
    layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView setContentOffset:CGPointMake(0, 1) animated:NO];
}

- (nonnull UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
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
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat safeAreaWidth = self.view.safeAreaLayoutGuide.layoutFrame.size.width;
    return CGSizeMake(safeAreaWidth, 1000);
}

@end
