//
//  HorizontalModePicker.m
//  Custom View wrapping a UICollectionView for the Mode Selector
//


#import "HorizontalModePicker.h"
#import "HorizontalModeCell.h"
#import "HorizontalModeLayout.h"
#import "AppDelegate.h"


NSDictionary *horizontalModeTextAttributes = nil;
NSDictionary *horizontalModeSelectedTextAttributes = nil;


@interface HorizontalModePicker () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic) CGFloat lineHeight;

@end


@implementation HorizontalModePicker


- (void)initialize {

    // Prepare text attributes for cells
    UIFont *font = [UIFont systemFontOfSize:17.0];
    UIFont *selectedFont = [UIFont boldSystemFontOfSize:17.0];

    horizontalModeTextAttributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor]};
    horizontalModeSelectedTextAttributes =  @{NSFontAttributeName:selectedFont, NSForegroundColorAttributeName:self.tintColor};

    self.lineHeight = ceil(MAX(font.lineHeight, selectedFont.lineHeight));


    // Collection subview
    [self.collectionView removeFromSuperview];

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[HorizontalModeLayout new]];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.userInteractionEnabled = NO;
    [self.collectionView registerClass:[HorizontalModeCell class] forCellWithReuseIdentifier:@"HorizontalItemCell"];

    [self addSubview:self.collectionView];

    // Layer mask for fade out
    CAGradientLayer *maskLayer = [CAGradientLayer layer];

    maskLayer.frame = self.collectionView.bounds;
    maskLayer.colors = @[(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor]];
    maskLayer.locations = @[@0.0, @0.10, @0.90, @1.0];
    maskLayer.startPoint = CGPointMake(0.0, 0.0);
    maskLayer.endPoint = CGPointMake(1.0, 0.0);
    self.collectionView.layer.mask = maskLayer;

    // Gesture recognizers replace interaction handling of collectionview
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipe];

    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipe];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapRecognizer];

}


- (instancetype)initWithFrame:(CGRect)frame {

    if ((self = [super initWithFrame:frame])) {

        [self initialize];
    }

    return self;
}


- (instancetype)initWithCoder:(NSCoder *)decoder {

    if ((self = [super initWithCoder:decoder])) {

        [self initialize];
    }

    return self;
}


#pragma mark - Updates for 3D Transformation / Layermask


- (void)updateFisheyeTransform {

    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.001;
    self.collectionView.layer.sublayerTransform = transform;
}


- (void)updateLayerMask {

    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.collectionView.layer.mask.frame = self.collectionView.bounds;
    [CATransaction commit];
}


#pragma mark - Gesture Handling


- (void)handleSwipe:(UISwipeGestureRecognizer *)swipeRecognizer {

    if ([self.datasource numberOfItemsInPickerView:self]) {

        NSInteger currentSelectedItemIndex = [self selectedItemIndex];

        if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {

            if (currentSelectedItemIndex > 0) {

                [self selectItemAtIndex:currentSelectedItemIndex - 1 animated:YES];
            }
        }
        else if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {

            if (currentSelectedItemIndex < [self.datasource numberOfItemsInPickerView:self] - 1) {

                [self selectItemAtIndex:currentSelectedItemIndex  + 1 animated:YES];
            }
        }
    }
}


- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer {

    NSIndexPath *itemIndexPath = [self.collectionView indexPathForItemAtPoint:[tapRecognizer locationInView:self.collectionView]];

    if (itemIndexPath) {

        [self selectItemAtIndex:itemIndexPath.item animated:YES];
    }
}


#pragma mark - AutoLayout


- (void)layoutSubviews {

    [super layoutSubviews];

    [self updateFisheyeTransform];
    [self updateLayerMask];
    [self reloadData];
}


- (CGSize)intrinsicContentSize {

    return CGSizeMake(UIViewNoIntrinsicMetric, self.lineHeight);
}


#pragma mark - Content Size Computations


- (CGSize)sizeForString:(NSString *)string {

    CGSize size = [string sizeWithAttributes:horizontalModeTextAttributes];
    CGSize selectedSize = [string sizeWithAttributes:horizontalModeSelectedTextAttributes];

    return CGSizeMake(ceil(20.0 + MAX(size.width, selectedSize.width)), ceil(MAX(size.height, selectedSize.height)));
}


- (NSInteger)itemIndexForContentOffset:(CGFloat)contentOffset {

    if ([self collectionView:self.collectionView numberOfItemsInSection:0]) {

        CGFloat offset = 0.0;

        if (contentOffset < 0.0)
            return 0;

        for (NSInteger i = 0; i < [self collectionView:self.collectionView numberOfItemsInSection:0]; i++) {

            NSString *title = [self.datasource pickerView:self titleForItemAtIndex:i];
            CGSize size = [self sizeForString:title];

            if (i == 0)
                offset = -size.width / 2;

            if (offset <= contentOffset && contentOffset < offset + size.width)
                return i;

            offset += size.width;
        }

        return [self collectionView:self.collectionView numberOfItemsInSection:0] - 1;
    }

    ALog(@"Computation of itemIndexForContentOffset with no items");
    return 0;
}


- (CGFloat)contentOffsetForItemAtIndex:(NSInteger)index {

    if (index < [self collectionView:self.collectionView numberOfItemsInSection:0]) {

        CGFloat offset = 0.0;

        if (index > 0) {

            for (NSInteger i = 0; i <= index; i++) {

                CGFloat itemWidth = [self sizeForString:[self.datasource pickerView:self titleForItemAtIndex:i]].width;
                offset += (i == 0 || i == index) ? itemWidth / 2 : itemWidth;
            }
        }

        return rint(offset);
    }

    ALog(@"Invalid itemIndex in contentOffsetForItemAtIndex");
    return 0.0;
}


#pragma mark - Collection View Support


- (void)reloadData {

    [self invalidateIntrinsicContentSize];

    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
}


- (NSInteger)selectedItemIndex {

    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];

    if (indexPaths.count == 1) {

        NSIndexPath *indexPath = indexPaths[0];
        return indexPath.item;
    }

    return 0;
}


- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated {

    [self.delegate pickerView:self didSelectItemAtIndex:index];

    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                                      animated:NO
                                scrollPosition:UICollectionViewScrollPositionNone];

    [self.collectionView setContentOffset:CGPointMake([self contentOffsetForItemAtIndex:index], self.collectionView.contentOffset.y)
                                 animated:animated];
}


#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.datasource numberOfItemsInPickerView:self];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    HorizontalModeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HorizontalItemCell" forIndexPath:indexPath];

    NSString *text = [self.datasource pickerView:self titleForItemAtIndex:indexPath.item];
    NSDictionary *attributes = cell.selected ? horizontalModeSelectedTextAttributes : horizontalModeTextAttributes;
    [cell setText:text attributes:attributes];

    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSString *title = [self.datasource pickerView:self titleForItemAtIndex:indexPath.item];

    return [self sizeForString:title];
}


// Inset first and last element such that they can be centered in the view
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    NSInteger number = [self collectionView:collectionView numberOfItemsInSection:section];

    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    CGSize firstSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];

    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:number - 1 inSection:section];
    CGSize lastSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];

    CGSize viewSize = collectionView.bounds.size;

    return UIEdgeInsetsMake((viewSize.height - self.lineHeight) / 2,
                            (viewSize.width  - firstSize.width) / 2,
                            (viewSize.height - self.lineHeight) / 2,
                            (viewSize.width  - lastSize.width)  / 2);
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [self updateLayerMask];
}


#pragma mark Accessibility


- (NSString *)accessibilityValue {

    return [self.datasource pickerView:self titleForItemAtIndex:[self selectedItemIndex]];
}


- (UIAccessibilityTraits)accessibilityTraits; {

    return [super accessibilityTraits] | UIAccessibilityTraitAdjustable;
}


- (void)accessibilityIncrement {

    NSInteger currentSelectedItemIndex = [self selectedItemIndex];

    if (currentSelectedItemIndex > 0) {

        [self selectItemAtIndex:currentSelectedItemIndex - 1 animated:YES];
    }
}


- (void)accessibilityDecrement {

    NSInteger currentSelectedItemIndex = [self selectedItemIndex];

    if (currentSelectedItemIndex < [self.datasource numberOfItemsInPickerView:self] - 1) {

        [self selectItemAtIndex:currentSelectedItemIndex  + 1 animated:YES];
    }
}

@end
