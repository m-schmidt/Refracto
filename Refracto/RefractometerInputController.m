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
    NSDecimalNumber *recentBeforeRefraction = sharedAppDelegate.recentBeforeRefraction;
    NSDecimalNumber *recentCurrentRefraction = sharedAppDelegate.recentCurrentRefraction;

    [self.beforePicker updateForSizeTransitionWithTargetContentOffset:CGPointZero];
    self.beforePicker.refraction = recentBeforeRefraction;

    [self.currentPicker updateForSizeTransitionWithTargetContentOffset:CGPointZero];
    self.currentPicker.refraction = recentCurrentRefraction;

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


#pragma mark - iPad Customization


- (void)handleComputationDefaultsChanged:(NSNotification *)notification {

    [self.delegate refractionInputDidChangeToBefore:self.beforePicker.refraction current:self.currentPicker.refraction];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:kShowSettingsPopoverSegue]) {

        UIViewController *destinationController = segue.destinationViewController;
        destinationController.preferredContentSize = CGSizeMake(320, 520);
    }
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    self.propagateUpdatesOnScroll = NO;

    CGPoint beforeContentOffset = self.beforePicker.collectionView.contentOffset;
    CGPoint currentContentOffset = self.currentPicker.collectionView.contentOffset;

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {

            [self.beforePicker updateForSizeTransitionWithTargetContentOffset:beforeContentOffset];
            [self.currentPicker updateForSizeTransitionWithTargetContentOffset:currentContentOffset];
        }
        completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {

            self.propagateUpdatesOnScroll = YES;
        }];
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
