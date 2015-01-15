//
//  HorizontalModeLayout.m
//  Custom Layout for UICollectionView used as Mode Selector
//


#import "HorizontalModeLayout.h"


@interface HorizontalModeLayout ()

@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat center;

@end


@implementation HorizontalModeLayout

- (instancetype)init {

    if ((self = [super init])) {

        self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 0.0;
        self.minimumInteritemSpacing = 0.0;
    }

    return self;
}


// Relayout on all bounds changes to keep the 3D transform correct
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {

    return YES;
}


#pragma mark Layout Computation


- (void)prepareLayout {

    // Compute center and radius for 3D transform
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};

    self.center = CGRectGetMidX(visibleRect);
    self.radius = CGRectGetWidth(visibleRect) / 1.8;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {

    // Default attributes from flow layout
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];

    // Transparency according distance from center of view
    CGFloat distance = CGRectGetMidX(attributes.frame) - self.center;
    CGFloat angle = distance / self.radius;

    attributes.alpha = (ABS(angle) < M_PI_2);

    // 3D transformation according distance from center of view
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, -distance, 0, -self.radius);
    transform = CATransform3DRotate(transform, angle, 0, 1, 0);
    transform = CATransform3DTranslate(transform, 0, 0, self.radius);
    attributes.transform3D = transform;

    return attributes;
}

@end
