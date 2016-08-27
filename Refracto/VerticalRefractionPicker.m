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
NSInteger const kMinRefraction =  0;
NSInteger const kMaxRefraction = 30;


@interface VerticalRefractionPicker () <UICollectionViewDataSource>

@property (nonatomic) BOOL updateRefractionOnScrollEvents;

@end


@implementation VerticalRefractionPicker

- (void)awakeFromNib {

    if ([super respondsToSelector:@selector(awakeFromNib)])
        [super awakeFromNib];

    _alignment = RefractionPickerAlignmentLeft;
    _refraction = [NSDecimalNumber decimalNumberWithInteger:kMaxRefraction];

    self.updateRefractionOnScrollEvents = NO;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    UIView *hitView = [super hitTest:point withEvent:event];

    if (hitView == self) {

        // The collection-subview may not cover the whole area of the picker => forward any events
        return self.collectionView;
    }

    return hitView;
}


#pragma mark - View Rotation


- (void)layoutSubviews {

    self.updateRefractionOnScrollEvents = NO;
    {
        [super layoutSubviews];

        [self handleSizeTransitionWithTargetContentOffset:
            [self contentOffsetForItemAtIndexPath:
                [self indexPathForRefractionValue:self.refraction]]];
    }
    self.updateRefractionOnScrollEvents = YES;
}


// Computed content insets that fit current bounds of view
- (UIEdgeInsets)contentInsetsToFit {

    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets.top = self.needleView.center.y - (kVerticalPickerCellHeight / 2) - 0.5;
    insets.bottom = CGRectGetHeight(self.collectionView.bounds) - self.needleView.center.y - (kVerticalPickerCellHeight / 2) - 0.5;

    return insets;
}


- (CGPoint)contentOffsetSnappedToTickMarker {

    return [self contentOffsetForItemAtIndexPath:[self indexPathForContentOffset:self.collectionView.contentOffset]];
}


- (void)handleSizeTransitionWithTargetContentOffset:(CGPoint)contentOffset {

    UIEdgeInsets newInsets = [self contentInsetsToFit];

    CGPoint newOffset = contentOffset;
    newOffset.y += self.collectionView.contentInset.top - newInsets.top;

    self.collectionView.contentInset = newInsets;
    self.collectionView.contentOffset = newOffset;
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

    if (self.refraction != refraction) {

        _refraction = refraction;
        [self.delegate refractionPickerView:self didSelectRefraction:_refraction];

        CGPoint contentOffset = [self contentOffsetForItemAtIndexPath:[self indexPathForRefractionValue:refraction]];
        [self.collectionView setContentOffset:contentOffset animated:NO];
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
    NSInteger index = [refraction decimalNumberByMultiplyingBy:ten].integerValue;

    index = MIN(index, (kMaxRefraction * 10));
    index = MAX(index, (kMinRefraction * 10));
    index = kMaxRefraction * 10 - index;

    return [self indexPathForLinearIndex:index];
}


- (NSDecimalNumber *)snapRefractionValue:(NSDecimalNumber *)refraction {

    return [self refractionValueForItemAtIndexPath:[self indexPathForRefractionValue:refraction]];
}


#pragma mark - VerticalRefractionLayoutDelegate


- (NSIndexPath *)indexPathForContentOffset:(CGPoint)contentOffset {

    CGFloat inset = self.collectionView.contentInset.top;
    NSInteger linearIndex = rint((inset + contentOffset.y) / (kVerticalPickerCellHeight + kVerticalPickerCellSpacing));

    linearIndex = MAX(linearIndex, 0);
    linearIndex = MIN(linearIndex, (kMaxRefraction - kMinRefraction) * 10);

    return [NSIndexPath indexPathForItem:linearIndex % 10 inSection:linearIndex / 10];
}


- (CGPoint)contentOffsetForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat inset = self.collectionView.contentInset.top;

    return CGPointMake (0.0, [self linearIndexForIndexPath:indexPath] * (kVerticalPickerCellHeight + kVerticalPickerCellSpacing) - inset);
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

    cell.contentView.backgroundColor = [UIColor clearColor];
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


#pragma mark - UIScrollViewDelegate


// Update current refraction on scrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (self.updateRefractionOnScrollEvents) {

        NSDecimalNumber *newRefraction = [self refractionValueForItemAtIndexPath:[self indexPathForContentOffset:self.collectionView.contentOffset]];

        if ([_refraction compare:newRefraction] != NSOrderedSame) {

            _refraction = newRefraction;
            [self.delegate refractionPickerView:self didSelectRefraction:_refraction];
        }
    }
}


#pragma mark - Accessibility


- (NSString *)accessibilityValue {

    NSString *value = [[AppDelegate numberFormatterBrix] stringFromNumber:self.refraction];

    return [NSString stringWithFormat:@"%@ °Brix", value];
}


- (UIAccessibilityTraits)accessibilityTraits; {

    return super.accessibilityTraits | UIAccessibilityTraitAdjustable;
}


- (BOOL)accessibilityIncrementRefractionByTicks:(NSInteger)increment postAnnouncement:(BOOL)announce {

    BOOL negative = NO;

    if (increment < 0) {

        negative   = YES;
        increment *= -1;
    }

    NSDecimalNumber *step = [NSDecimalNumber decimalNumberWithMantissa:increment exponent:-1 isNegative:negative];
    NSDecimalNumber *newRefraction = [self snapRefractionValue:[self.refraction decimalNumberByAdding:step]];

    if ([_refraction compare:newRefraction] != NSOrderedSame) {

        self.refraction = newRefraction;
        [self.delegate refractionPickerView:self didSelectRefraction:newRefraction];

        if (announce) {

            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, self.accessibilityValue);
        }

        return YES;
    }

    return NO;
}


- (BOOL)accessibilityScroll:(UIAccessibilityScrollDirection)direction {

    switch (direction) {

        case UIAccessibilityScrollDirectionDown:
            return [self accessibilityIncrementRefractionByTicks:10 postAnnouncement:YES];

        case UIAccessibilityScrollDirectionUp:
            return [self accessibilityIncrementRefractionByTicks:-10 postAnnouncement:YES];

        default:
            return NO;
    }
}


- (void)accessibilityIncrement {

    [self accessibilityIncrementRefractionByTicks:1 postAnnouncement:NO];
}


- (void)accessibilityDecrement {

    [self accessibilityIncrementRefractionByTicks:-1 postAnnouncement:NO];
}

@end
