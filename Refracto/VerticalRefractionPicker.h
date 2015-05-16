//
//  VerticalRecfractionPicker.h
//  Custom View wrapping a UICollectionView as Refraction Selectors
//


#import "VerticalRefractionLayout.h"
#import "VerticalRefractionNeedle.h"


@class VerticalRefractionPicker;

@protocol VerticalRecfractionPickerDelegate <NSObject>

@required
- (void)refractionPickerView:(VerticalRefractionPicker *)pickerView didSelectRefraction:(NSDecimalNumber *)refraction;

@end


@interface VerticalRefractionPicker : UIView <VerticalRefractionLayoutDelegate>

@property (weak, nonatomic) IBOutlet id <VerticalRecfractionPickerDelegate> delegate;
@property (weak, nonatomic) IBOutlet VerticalRefractionNeedle *needleView;

// Currently selected refraction value
@property (strong, nonatomic) NSDecimalNumber *refraction;

// Horizontal alignment of the tick markers in the view
@property (nonatomic) RefractionPickerAlignment alignment;

@end
