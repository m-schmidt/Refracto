//
//  RefractometerInputController.m
//  (Sub-)Controller for Input Section in Refractometer Tab
//


#import "RefractometerInputController.h"
#import "AppDelegate.h"
#import "NSDecimalNumber+Refracto.h"
#import "UIFont+Monospaced.h"
#import "Theme.h"


#define kShowSettingsPopoverSegue  (@"showSettingsPopoverSegue")


@interface RefractometerInputController () <VerticalRecfractionPickerDelegate>

@property (weak, nonatomic) IBOutlet VerticalRefractionPicker *beforePicker;
@property (weak, nonatomic) IBOutlet VerticalRefractionPicker *currentPicker;

@property (weak, nonatomic) IBOutlet UILabel *beforeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@end


@implementation RefractometerInputController

- (void)viewDidLoad {

    [super viewDidLoad];

    AppDelegate *sharedAppDelegate = [AppDelegate appDelegate];

    self.beforePicker.alignment = RefractionPickerAlignmentRight;
    self.beforePicker.refraction = sharedAppDelegate.recentBeforeRefraction;

    self.currentPicker.alignment = RefractionPickerAlignmentLeft;
    self.currentPicker.refraction = sharedAppDelegate.recentCurrentRefraction;

    [self.settingsButton setImage:[Theme sharedTheme].settingsButtonImage forState:UIControlStateNormal];

    [self setupMonospacedFontAttributes];
}


- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {

        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(handleComputationDefaultsChanged:)
                   name:kRefractoComputationDefaultsChangedNotification
                 object:nil];
    }

    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.beforePicker);

    [self tryAnimatedPickerHint];
}


- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setupMonospacedFontAttributes {

    for (UILabel *label in @[ self.beforeLabel, self.currentLabel]) {
        label.font = [UIFont monospacedDigitFontVariant:label.font];
    }
}


- (void)handleComputationDefaultsChanged:(NSNotification *)notification {

    [self.delegate refractionInputDidChangeToBefore:self.beforePicker.refraction current:self.currentPicker.refraction];
}


- (void)tryAnimatedPickerHint {

    AppDelegate *appDelegate = [AppDelegate appDelegate];

    if (appDelegate.onceOnFirstAppLaunch) {

        NSDecimalNumber *before  = self.beforePicker.refraction;
        NSDecimalNumber *current = self.currentPicker.refraction;
        NSDecimalNumber *offset  = [NSDecimalNumber decimalNumberWithMantissa:2 exponent:-1 isNegative:NO];

        self.view.userInteractionEnabled = NO;

        [UIView animateKeyframesWithDuration:0.6 delay:0.3 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{

                [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{

                    [self.beforePicker scrollToRefraction:[appDelegate constrainRefractionValue:[before decimalNumberByAdding:offset]]];
                    [self.currentPicker scrollToRefraction:[appDelegate constrainRefractionValue:[current decimalNumberBySubtracting:offset]]];
                    [self.view layoutIfNeeded];
                }];

                [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{

                    [self.beforePicker scrollToRefraction:before];
                    [self.currentPicker scrollToRefraction:current];
                    [self.view layoutIfNeeded];
                }];
            }
            completion:^(BOOL finished) {

                self.view.userInteractionEnabled = YES;
            }];
    }
}


#pragma mark - Adaptive UIPopoverPresentation for Settings on iPad


- (IBAction)dismissSettings:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)updateNavigationItemForPresentedViewController:(UIViewController *)presentedViewController traitCollection:(UITraitCollection *)traits {

    if ([presentedViewController isKindOfClass:[UINavigationController class]]) {

        UINavigationController *navController = (UINavigationController *)presentedViewController;
        UIBarButtonItem *doneButton = nil;

        if (traits.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {

            doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                       target:self
                                                                       action:@selector(dismissSettings:)];
        }

        navController.topViewController.navigationItem.rightBarButtonItem = doneButton;
    }
    else if (presentedViewController != nil) {

        ALog(@"Presented viewcontroller (%@) must be of class UINavigationController", presentedViewController);
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:kShowSettingsPopoverSegue]) {

        UIViewController *destinationController = segue.destinationViewController;
        destinationController.preferredContentSize = CGSizeMake(340, 584);
        destinationController.popoverPresentationController.delegate = self;

        [self updateNavigationItemForPresentedViewController:destinationController traitCollection:self.traitCollection];

        UIPopoverPresentationController *popoverController = (UIPopoverPresentationController *)destinationController.presentationController;
        popoverController.sourceRect = CGRectInset(popoverController.sourceView.bounds, -5, -5);
        popoverController.backgroundColor = [[Theme sharedTheme] settingsPopoverBackgroundColor];
    }
}


- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];

    [self updateNavigationItemForPresentedViewController:self.presentedViewController traitCollection:newCollection];
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
