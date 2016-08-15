//
//  VerticalRefractionLayout.m
//  Custom Layout for UICollectionView used as Refraction Selectors
//


#import "VerticalRefractionLayout.h"


NSInteger const kVerticalPickerCellWidth   = 100;
NSInteger const kVerticalPickerCellHeight  =  11;
NSInteger const kVerticalPickerCellSpacing =   0;

NSInteger const kVerticalPickerSupplementaryViewWidth  = 22;
NSInteger const kVerticalPickerSupplementaryViewHeight = 16;

NSInteger const kVerticalPickerLongTickWidth   = 52;
NSInteger const kVerticalPickerMediumTickWidth = 32;
NSInteger const kVerticalPickerSmallTickWidth  = 20;
NSInteger const kVerticalPickerTickInset       =  2;


@interface VerticalRefractionLayout ()

@property (strong, nonatomic) NSMutableArray *headerYPositions;

@end


@implementation VerticalRefractionLayout

- (void)awakeFromNib {

    if ([super respondsToSelector:@selector(awakeFromNib)])
        [super awakeFromNib];

    _alignment = RefractionPickerAlignmentLeft;

    self.itemSize = CGSizeMake(kVerticalPickerCellWidth, kVerticalPickerCellHeight);
    self.minimumLineSpacing = kVerticalPickerCellSpacing;
    self.headerReferenceSize = CGSizeMake(0.0, 0.0);
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {

    CGRect oldBounds = self.collectionView.bounds;

    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {

        return YES;
    }

    return NO;
}


#pragma mark Layout Computation


- (void)prepareLayout {

    // Enforce a single cell per line
    self.minimumInteritemSpacing = ceil(CGRectGetWidth(self.collectionView.bounds) - kVerticalPickerCellWidth);

    // Number of sections or fallback to 1
    NSInteger numberOfSections = 1;

    if ([self.collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)])
        numberOfSections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];

    // Precompute y-position of header cells
    self.headerYPositions = [[NSMutableArray alloc] initWithCapacity:numberOfSections];

    CGFloat yPosition = 0;

    for (NSInteger section = 0; section < numberOfSections; section++) {

        // Compute position and advance to next section
        [self.headerYPositions addObject:@(rint(yPosition + kVerticalPickerCellHeight / 2))];

        yPosition += kVerticalPickerCellHeight * [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
    }
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSArray *superLayoutAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *layoutAttributes = [[NSMutableArray alloc] initWithCapacity:superLayoutAttributes.count + 10];

    // Match normal views and align them
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);

    for (UICollectionViewLayoutAttributes *attributes in superLayoutAttributes) {

        CGRect frame = attributes.frame;
        frame.origin.x = (self.alignment == RefractionPickerAlignmentLeft) ? 2 : width - CGRectGetWidth(frame) - 2;

        UICollectionViewLayoutAttributes *alignedAttributes = [attributes copy];
        alignedAttributes.frame = frame;
        alignedAttributes.zIndex = 0;

        [layoutAttributes addObject:alignedAttributes];
    }

    // Match supplementary views against given rectangle
    for (NSInteger section = 0; section < (self.headerYPositions).count; section++) {

        CGRect headerRect = CGRectMake(0, [self.headerYPositions[section] floatValue], width, kVerticalPickerSupplementaryViewHeight);

        if (CGRectIntersectsRect(rect, headerRect))
            [layoutAttributes addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                             atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]]];
    }

    return layoutAttributes;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewLayoutAttributes *attributes =
        [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];

    // Add supplementary view for section at precomputed position
    NSInteger section = [indexPath indexAtPosition:0];
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    CGFloat yPosition = [self.headerYPositions [section] floatValue];
    CGFloat xPosition = rint ((self.alignment == RefractionPickerAlignmentLeft) ? 55.0 : (width - 55.0 - kVerticalPickerSupplementaryViewWidth));

    attributes.zIndex = 1;
    attributes.frame = CGRectMake(xPosition, yPosition, kVerticalPickerSupplementaryViewWidth, kVerticalPickerSupplementaryViewHeight);

    return attributes;
}


#pragma mark Scrolling Support


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {

    id<VerticalRefractionLayoutDelegate> delegate = (id<VerticalRefractionLayoutDelegate>)self.collectionView.delegate;

    return [delegate contentOffsetForItemAtIndexPath:[delegate indexPathForContentOffset:proposedContentOffset]];
}

@end
