//
//  VerticalRecfractionPicker.m
//  Custom View wrapping a UICollectionView as Refraction Selectors
//


#import "VerticalRefractionPicker.h"
#import "VerticalRefractionCell.h"
#import "VerticalRefractionSupplementaryView.h"
#import "NSDecimalNumber+Refracto.h"
#import "AppDelegate.h"


// Default value range in °Brix for picker
static NSInteger const kMinRefraction =  0;
static NSInteger const kMaxRefraction = 30;


@interface VerticalRefractionPicker () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end


@implementation VerticalRefractionPicker

- (void)awakeFromNib {

    _alignment = RefractionPickerAlignmentLeft;
    _refraction = [NSDecimalNumber decimalNumberWithInteger:kMaxRefraction];
}


- (void)layoutSubviews {

    [self.collectionView reloadData];
}


#pragma mark - Properties


- (void)setAlignment:(RefractionPickerAlignment)alignment {

    if (self.alignment != alignment) {

        VerticalRefractionLayout *collectionViewLayout = (VerticalRefractionLayout *)self.collectionView.collectionViewLayout;
        collectionViewLayout.alignment = alignment;
        [self.collectionView.collectionViewLayout invalidateLayout];

        self.needleView.alignment = alignment;
        [self.needleView setNeedsDisplay];

        _alignment = alignment;
        [self setNeedsLayout];
    }
}


- (void)setRefraction:(NSDecimalNumber *)refraction {

    [self setRefraction:refraction animated:YES];
}


- (void)setRefraction:(NSDecimalNumber *)refraction animated:(BOOL)animated {

    if (refraction != nil && [self.refraction compare:refraction] != NSOrderedSame) {

        _refraction = refraction;

        CGPoint contentOffset = [self contentOffsetForItemAtIndexPath:[self indexPathForRefractionValue:refraction]];
        [self.collectionView setContentOffset:contentOffset animated:animated];
    }
}


#pragma mark - Conversion between Linear Item Index and IndexPath


- (NSInteger)linearIndexForIndexPath:(NSIndexPath *)indexPath {

    return [indexPath indexAtPosition:0] * 10 + [indexPath indexAtPosition:1];
}


- (NSIndexPath *)indexPathForLinearIndex:(NSInteger)linearIndex {

    return [NSIndexPath indexPathForItem:linearIndex % 10 inSection:linearIndex / 10];
}


#pragma mark - Conversion between IndexPath and Refraction Values


- (NSDecimalNumber *)refractionValueForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSDecimalNumber *min = [NSDecimalNumber decimalNumberWithInteger:kMinRefraction];
    NSDecimalNumber *max = [NSDecimalNumber decimalNumberWithInteger:kMaxRefraction];
    NSDecimalNumber *index = [NSDecimalNumber decimalNumberWithInteger:[self linearIndexForIndexPath:indexPath]];
    NSDecimalNumber *onetenth = [NSDecimalNumber decimalNumberWithMantissa:1 exponent:-1 isNegative:NO];

    NSDecimalNumber *refraction = [max decimalNumberBySubtracting:[index decimalNumberByMultiplyingBy:onetenth]];

    return ([refraction isLessThan:min] ? min : refraction);
}


- (NSIndexPath *)indexPathForRefractionValue:(NSDecimalNumber *)refraction {

    NSDecimalNumber *ten = [NSDecimalNumber decimalNumberWithInteger:10];
    NSInteger index = [[refraction decimalNumberByMultiplyingBy:ten] integerValue];

    index = MIN(index, (kMaxRefraction * 10));
    index = MAX(index, (kMinRefraction * 10));
    index = kMaxRefraction * 10 - index;

    return [self indexPathForLinearIndex:index];
}


- (NSDecimalNumber *)constrainedRefractionValue:(NSDecimalNumber *)refraction {

    return [self refractionValueForItemAtIndexPath:[self indexPathForRefractionValue:refraction]];
}


#pragma mark - VerticalRefractionLayoutDelegate


- (NSIndexPath *)indexPathForContentOffset:(CGPoint)contentOffset {

    NSInteger linearIndex = rint(contentOffset.y / (kVerticalPickerCellHeight + kVerticalPickerCellSpacing));

    linearIndex = MAX(linearIndex, 0);
    linearIndex = MIN(linearIndex, (kMaxRefraction - kMinRefraction) * 10);

    return [NSIndexPath indexPathForItem:linearIndex % 10 inSection:linearIndex / 10];
}


- (CGPoint)contentOffsetForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGPointMake (0.0, [self linearIndexForIndexPath:indexPath] * (kVerticalPickerCellHeight + kVerticalPickerCellSpacing));
}


#pragma mark - UICollectionViewDataSource


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return kMaxRefraction - kMinRefraction + 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return (section < [self numberOfSectionsInCollectionView:collectionView] - 1) ? 10 : 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    VerticalRefractionCell *cell =
        (VerticalRefractionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"RefractionCell"
                                                                            forIndexPath:indexPath];

    switch ([indexPath indexAtPosition:1]) {

        case 0:  cell.barLength = kVerticalPickerLongTickWidth; break;
        case 5:  cell.barLength = kVerticalPickerMediumTickWidth; break;
        default: cell.barLength = kVerticalPickerSmallTickWidth; break;
    }

    cell.alignment = self.alignment;

    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {

    VerticalRefractionSupplementaryView *header =
        (VerticalRefractionSupplementaryView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                  withReuseIdentifier:@"RefractionHeader"
                                                                                         forIndexPath:indexPath];

    header.label.text = [NSString stringWithFormat:@"%2ld", (long)(kMaxRefraction - [indexPath indexAtPosition:0])];

    return header;
}


#pragma mark - UICollectionViewDelegateFlowLayout


// Inset first and last element such that they can be scrolled to the middle of the view
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    if (section == 0) {

        CGFloat insetTop = self.needleView.center.y - (kVerticalPickerCellHeight / 2) - 0.5;

        return UIEdgeInsetsMake(insetTop, 0.0, 0.0, 0.0);
    }
    else if (section == [self numberOfSectionsInCollectionView:collectionView] - 1) {

        CGFloat insetBot = collectionView.bounds.size.height - self.needleView.center.y - (kVerticalPickerCellHeight / 2) - 0.5;

        return UIEdgeInsetsMake(0.0, 0.0, insetBot, 0.0);
    }

    return UIEdgeInsetsZero;
}


#pragma mark - UIScrollViewDelegate


// Update current refraction on scrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    NSDecimalNumber *newRefraction = [self refractionValueForItemAtIndexPath:[self indexPathForContentOffset:self.collectionView.contentOffset]];

    if ([_refraction compare:newRefraction] != NSOrderedSame) {

        _refraction = newRefraction;
        [self.delegate refractionPickerView:self didSelectRefraction:_refraction];
    }
}


#pragma mark Accessibility


- (NSString *)accessibilityValue {

    NSString *value = [[AppDelegate numberFormatterBrix] stringFromNumber:self.refraction];

    return [NSString stringWithFormat:@"%@ °Brix", value];
}


- (UIAccessibilityTraits)accessibilityTraits; {

    return [super accessibilityTraits] | UIAccessibilityTraitAdjustable;
}


- (BOOL)accessibilityIncrementRefrectionByTicks:(NSInteger)increment postAnnouncement:(BOOL)announce {

    BOOL negative = NO;

    if (increment < 0) {

        negative   = YES;
        increment *= -1;
    }

    NSDecimalNumber *step = [NSDecimalNumber decimalNumberWithMantissa:increment exponent:-1 isNegative:negative];
    NSDecimalNumber *newRefraction = [self constrainedRefractionValue:[self.refraction decimalNumberByAdding:step]];

    if ([_refraction compare:newRefraction] != NSOrderedSame) {

        [self setRefraction:newRefraction animated:NO];
        [self.delegate refractionPickerView:self didSelectRefraction:newRefraction];

        if (announce) {

            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [self accessibilityValue]);
        }

        return YES;
    }

    return NO;
}


- (BOOL)accessibilityScroll:(UIAccessibilityScrollDirection)direction {

    switch (direction) {

        case UIAccessibilityScrollDirectionDown:
            return [self accessibilityIncrementRefrectionByTicks:10 postAnnouncement:YES];

        case UIAccessibilityScrollDirectionUp:
            return [self accessibilityIncrementRefrectionByTicks:-10 postAnnouncement:YES];

        default:
            return NO;
    }
}


- (void)accessibilityIncrement {

    [self accessibilityIncrementRefrectionByTicks:1 postAnnouncement:NO];
}


- (void)accessibilityDecrement {

    [self accessibilityIncrementRefrectionByTicks:-1 postAnnouncement:NO];
}

@end
