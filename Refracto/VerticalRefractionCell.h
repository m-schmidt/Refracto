//
//  VerticalRefractionCell.h
//  Custom Cell for UICollectionView used as Tick Marker
//


#import "VerticalRefractionLayout.h"


@interface VerticalRefractionCellContent : UIView

@property (nonatomic) NSInteger barLength;
@property (nonatomic) RefractionPickerAlignment alignment;

@end


@interface VerticalRefractionCell : UICollectionViewCell

@property (nonatomic, strong) VerticalRefractionCellContent *content;

@end
