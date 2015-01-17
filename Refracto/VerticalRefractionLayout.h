//
//  VerticalRefractionLayout.h
//  Custom Layout for UICollectionView used as Refraction Selectors
//


// Modes for horizontal alignment of refraction ticks in picker view
typedef NS_ENUM(NSInteger, RefractionPickerAlignment) {

    RefractionPickerAlignmentLeft,
    RefractionPickerAlignmentRight,
};


// Constants for dimensions of tick-cells
extern NSInteger const kVerticalPickerCellWidth;
extern NSInteger const kVerticalPickerCellHeight;
extern NSInteger const kVerticalPickerCellSpacing;

// Constants for dimensions of supplementary views
extern NSInteger const kVerticalPickerSupplementaryViewWidth;
extern NSInteger const kVerticalPickerSupplementaryViewHeight;

// Constants for tick and needle sizes
extern NSInteger const kVerticalPickerLongTickWidth;
extern NSInteger const kVerticalPickerMediumTickWidth;
extern NSInteger const kVerticalPickerSmallTickWidth;
extern NSInteger const kVerticalPickerTickInset;

extern NSInteger const kVerticalPickerNeedleWidth;
extern NSInteger const kVerticalPickerNeedleHeight;


// Delegate with methods to convert between index path of items and content offsets to support scrolling
@protocol VerticalRefractionLayoutDelegate <UICollectionViewDelegateFlowLayout>

@required
- (NSIndexPath *)indexPathForContentOffset:(CGPoint)contentOffset;
- (CGPoint)contentOffsetForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface VerticalRefractionLayout : UICollectionViewFlowLayout

@property (nonatomic) RefractionPickerAlignment alignment;

@end
