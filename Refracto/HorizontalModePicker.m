//
//  HorizontalModePicker.m
//  Custom View wrapping a UICollectionView for the Mode Selector
//


#import "HorizontalModePicker.h"
#import "HorizontalModeCell.h"
#import "AppDelegate.h"
#import "Theme.h"


NSDictionary *horizontalModeTextAttributes = nil;
NSDictionary *horizontalModeSelectedTextAttributes = nil;


@interface HorizontalModePicker () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) CGFloat lineHeight;

@end


@implementation HorizontalModePicker

- (void)awakeFromNib {

    if ([super respondsToSelector:@selector(awakeFromNib)])
        [super awakeFromNib];

    // Derive line height from front data
    self.lineHeight = [self setupTextAttributes];

    // Collection subview
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;

    // Layer mask for fade out
    CAGradientLayer *maskLayer = [CAGradientLayer layer];

    maskLayer.frame = self.collectionView.bounds;
    maskLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor];
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


- (CGFloat)setupTextAttributes {

    UIFont *font = [UIFont systemFontOfSize:17.0];
    UIFont *selectedFont = [UIFont boldSystemFontOfSize:17.0];

    Theme *sharedTheme = [Theme sharedTheme];
    horizontalModeTextAttributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:[sharedTheme labelColorLevel0]};
    horizontalModeSelectedTextAttributes =  @{NSFontAttributeName:selectedFont, NSForegroundColorAttributeName:[sharedTheme tintColor]};

    return ceil(MAX(font.lineHeight, selectedFont.lineHeight));
}


#pragma mark - Updates for 3D Transformation / Layermask


- (void)updateFisheyeTransform {

    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.001;
    self.collectionView.layer.sublayerTransform = transform;
}


- (void)updateLayerMask {

    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};

    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.collectionView.layer.mask.frame = visibleRect;
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

                [self selectItemAtIndex:currentSelectedItemIndex + 1 animated:YES];
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


#pragma mark - Collection View Support


- (NSInteger)selectedItemIndex {

    NSArray *indexPaths = (self.collectionView).indexPathsForSelectedItems;

    if (indexPaths.count == 1) {

        NSIndexPath *indexPath = indexPaths[0];
        return indexPath.item;
    }

    return 0;
}


- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated {

    [self.delegate pickerView:self didSelectItemAtIndex:index];

    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                                      animated:animated
                                scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
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

    CGFloat width = collectionView.bounds.size.width;
    CGFloat height = collectionView.bounds.size.height;

    return UIEdgeInsetsMake((height - self.lineHeight) / 2,
                            (width  - firstSize.width) / 2,
                            (height - self.lineHeight) / 2,
                            (width  - lastSize.width)  / 2);
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

    return super.accessibilityTraits | UIAccessibilityTraitAdjustable;
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

        [self selectItemAtIndex:currentSelectedItemIndex + 1 animated:YES];
    }
}

@end
