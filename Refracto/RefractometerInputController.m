//
//  RefractometerInputController.m
//  (Sub-)Controller for Input Section in Refractometer Tab
//


#import "RefractometerInputController.h"
#import "AppDelegate.h"
#import "NSDecimalNumber+Refracto.h"


#define kShowSettingsPopoverSegue  (@"showSettingsPopoverSegue")


@interface RefractometerInputController () <VerticalRecfractionPickerDelegate>

@property (weak, nonatomic) IBOutlet VerticalRefractionPicker *beforePicker;
@property (weak, nonatomic) IBOutlet VerticalRefractionPicker *currentPicker;

@property (weak, nonatomic) IBOutlet UILabel *beforeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;

@property (nonatomic) BOOL propagateUpdatesOnScroll;

@end


@implementation RefractometerInputController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.beforePicker.alignment = RefractionPickerAlignmentRight;
    self.currentPicker.alignment = RefractionPickerAlignmentLeft;
    self.propagateUpdatesOnScroll = YES;
}


- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    AppDelegate *sharedAppDelegate = [AppDelegate appDelegate];
    self.beforePicker.refraction = sharedAppDelegate.recentBeforeRefraction;
    self.currentPicker.refraction = sharedAppDelegate.recentCurrentRefraction;

    if (UI_USER_INTERFACE_IDIOM () == UIUserInterfaceIdiomPad) {

        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(handleComputationDefaultsChanged:)
                   name:kRefractoComputationDefaultsChangedNotification
                 object:nil];
    }

    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.beforePicker);
}


- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - iPad Rotation


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    self.propagateUpdatesOnScroll = NO;

    CGPoint beforeContentOffset = [self.beforePicker contentOffsetSnappedToTickMarker];
    CGPoint currentContentOffset = [self.currentPicker contentOffsetSnappedToTickMarker];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {

        [self.beforePicker handleSizeTransitionWithTargetContentOffset:beforeContentOffset];
        [self.currentPicker handleSizeTransitionWithTargetContentOffset:currentContentOffset];
    }
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {

                                     self.propagateUpdatesOnScroll = YES;
                                 }];
}


#pragma mark - Customized Settings for iPad


- (void)handleComputationDefaultsChanged:(NSNotification *)notification {

    [self.delegate refractionInputDidChangeToBefore:self.beforePicker.refraction current:self.currentPicker.refraction];
}


- (IBAction)dismissSettings:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:kShowSettingsPopoverSegue]) {

        UIViewController *destinationController = segue.destinationViewController;
        destinationController.preferredContentSize = CGSizeMake(320, 520);
        destinationController.popoverPresentationController.delegate = self;
    }
}


#pragma mark - UIAdaptivePresentationControllerDelegate


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {

    return UIModalPresentationFullScreen;
}


- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style  {

    UINavigationController *navController = (UINavigationController *)controller.presentedViewController;
    UIBarButtonItem *doneButton = nil;

    if (style == UIModalPresentationFullScreen) {

        doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                   target:self
                                                                   action:@selector(dismissSettings:)];
    }

    navController.topViewController.navigationItem.rightBarButtonItem = doneButton;
    return navController;
}


#pragma mark - VerticalRecfractionPickerDelegate


- (void)refractionPickerView:(VerticalRefractionPicker *)pickerView didSelectRefraction:(NSDecimalNumber *)refraction {

    if (self.propagateUpdatesOnScroll == NO)
        return;

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
