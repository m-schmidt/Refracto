//
//  RefractometerController.m
//  Controller for Refractometer Tab
//


#import "RefractometerController.h"
#import "AppDelegate.h"
#import "Theme.h"


@interface RefractometerController ()

@property (weak, nonatomic) RefractometerInputController *inputController;
@property (weak, nonatomic) RefractometerDisplayController *displayController;

@end


@implementation RefractometerController

// Always show status bar
- (BOOL)prefersStatusBarHidden {

    return NO;
}


- (UIStatusBarStyle)preferredStatusBarStyle {

    return [Theme statusBarStyle:[AppDelegate appDelegate].darkInterface];
}


// Catch segues to embedded controllers, init delegate
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UIViewController *destinationViewController = segue.destinationViewController;

    if ([segue.destinationViewController isKindOfClass:[RefractometerInputController class]]) {

        self.inputController = (RefractometerInputController *)destinationViewController;
        self.inputController.delegate = self;
    }
    else if ([segue.destinationViewController isKindOfClass:[RefractometerDisplayController class]]) {

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
