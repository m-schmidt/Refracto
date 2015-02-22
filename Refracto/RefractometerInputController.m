//
//  RefractometerInputController.m
//  (Sub-)Controller for Input Section in Refractometer Tab
//


#import "RefractometerInputController.h"
#import "AppDelegate.h"
#import "NSDecimalNumber+Refracto.h"


@interface RefractometerInputController () <VerticalRecfractionPickerDelegate>

@property (weak, nonatomic) IBOutlet VerticalRefractionPicker *beforePicker;
@property (weak, nonatomic) IBOutlet VerticalRefractionPicker *currentPicker;

@property (weak, nonatomic) IBOutlet UILabel *beforeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;

@end


@implementation RefractometerInputController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.beforePicker.alignment = RefractionPickerAlignmentRight;
    self.currentPicker.alignment = RefractionPickerAlignmentLeft;
}


- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    AppDelegate *sharedAppDelegate = [AppDelegate appDelegate];
    NSDecimalNumber *recentBeforeRefraction = sharedAppDelegate.recentBeforeRefraction;
    NSDecimalNumber *recentCurrentRefraction = sharedAppDelegate.recentCurrentRefraction;

    self.beforePicker.refraction = recentBeforeRefraction;
    self.currentPicker.refraction = recentCurrentRefraction;

    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(handleComputationDefaultsChanged:)
               name:kRefractoComputationDefaultsChangedNotification
             object:nil];

    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.beforePicker);
}


- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)handleComputationDefaultsChanged:(NSNotification *)notification {

    [self.delegate refractionInputDidChangeToBefore:self.beforePicker.refraction current:self.currentPicker.refraction];
}


#pragma mark - VerticalRecfractionPickerDelegate


- (void)refractionPickerView:(VerticalRefractionPicker *)pickerView didSelectRefraction:(NSDecimalNumber *)refraction {

    NSString *description = [[AppDelegate numberFormatterBrix] stringFromNumber:refraction];

    if (pickerView == self.beforePicker) {

        self.beforeLabel.text = description;
    }
    else if (pickerView == self.currentPicker) {

        self.currentLabel.text = description;
    }

    [self.delegate refractionInputDidChangeToBefore:self.beforePicker.refraction current:self.currentPicker.refraction];
}

@end
