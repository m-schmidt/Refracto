//
//  RefractometerDisplayController.h
//  (Sub-)Controller for Display Section in Refractometer Tab
//


#import "HorizontalModePicker.h"


@interface RefractometerDisplayController : UIViewController  <HorizontalModePickerDataSource, HorizontalModePickerDelegate>

// Trigger update of display for given refraction values. Returns whether a computation was feasible.
- (BOOL)tryUpdateForRefractionBefore:(NSDecimalNumber *)beforeRefraction current:(NSDecimalNumber *)currentRefraction;

@end
