//
//  RefractometerController.m
//  Controller for Refractomater Tab
//


#import "RefractometerController.h"
#import "AppDelegate.h"


@interface RefractometerController ()

@property (weak, nonatomic) RefractometerInputController *inputController;
@property (weak, nonatomic) RefractometerDisplayController *displayController;

@end


@implementation RefractometerController

// Settings on iPad show a popover or a fullscreen view in compact size width
- (IBAction)showSettings:(id)sender {

    UIViewController *settingsController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsNavigation"];
    settingsController.modalPresentationStyle = UIModalPresentationPopover;

    UIPopoverPresentationController *popOverController = settingsController.popoverPresentationController;
    popOverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popOverController.sourceView = sender;
    popOverController.delegate = self;

    [self presentViewController:settingsController animated:YES completion:nil];
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {

    return UIModalPresentationFullScreen;
}


// Catch segues to embedded controllers, init delegate
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UIViewController *destinationViewController = [segue destinationViewController];

    if ([[segue destinationViewController] isKindOfClass:[RefractometerInputController class]]) {

        self.inputController = (RefractometerInputController *)destinationViewController;
        self.inputController.delegate = self;
    }
    else if ([[segue destinationViewController] isKindOfClass:[RefractometerDisplayController class]]) {

        self.displayController = (RefractometerDisplayController *)destinationViewController;
    }
}


#pragma mark RefractometerInputDelegate


// Forward refraction values from input to display subcontroller
- (void)refractionInputDidChangeToBefore:(NSDecimalNumber *)beforeRefraction current:(NSDecimalNumber *)currentRefraction {

    if ([self.displayController tryUpdateForRefractionBefore:beforeRefraction current:currentRefraction]) {

        // Store plausible refraction values in preferences
        AppDelegate *sharedAppDelegate = [AppDelegate appDelegate];

        sharedAppDelegate.recentBeforeRefraction  = beforeRefraction;
        sharedAppDelegate.recentCurrentRefraction = currentRefraction;
    }
}

@end
