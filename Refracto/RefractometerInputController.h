//
//  RefractometerInputController.h
//  (Sub-)Controller for Input Section in Refractometer Tab
//


#import "VerticalRefractionPicker.h"


@protocol RefractometerInputDelegate <NSObject>

@required
- (void)refractionInputDidChangeToBefore:(NSDecimalNumber *)beforeRefraction current:(NSDecimalNumber *)currentRefraction;

@end


@interface RefractometerInputController : UIViewController <VerticalRecfractionPickerDelegate, UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet id <RefractometerInputDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@end
