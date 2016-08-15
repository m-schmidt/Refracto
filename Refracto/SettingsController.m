//
//  SettingsController.m
//  Controller for Settings Tab
//


#import <MessageUI/MessageUI.h>
#import <SafariServices/SafariServices.h>
#import "SettingsController.h"
#import "SliderCell.h"
#import "AppDelegate.h"


// Section indexes
static NSInteger const kSettingsSection = 0;
static NSInteger const kSupportSection  = 1;
static NSInteger const kStoreSection    = 2;

// Row indexes for settings section
static NSInteger const kSettingsDarkInterfaceRow  = 0;
static NSInteger const kSettingsUnitRow           = 1;
static NSInteger const kSettingsWortCorrectionRow = 2;

// Row indexes for support section
static NSInteger const kSupportWebsiteRow = 0;
static NSInteger const kSupportMailRow    = 1;

// Strings for support stuff
static NSString *kWebsiteURL         = @"https://mschmidt.me/ios.html#Refracto";
static NSString *kSupportMailAddress = @"refracto@mschmidt.me";
static NSString *kStoreURL           = @"https://itunes.apple.com/app/id954981822";


// Mail contents and alerts
#define kSupportMailSubjectKey         (@"mailSubject")
#define kSupportMailBodyKey            (@"mailBody")

#define kMailFailedTitleKey            (@"mailFailedTitle")
#define kMailFailedMessageKey          (@"mailFailedMessage")

#define kMailNoAccountTitleKey         (@"mailNoAccountTitle")
#define kMailNoAccountMessageKey       (@"mailNoAccountMessage")

// Setting tableview contents
#define kSettingsTitleKey              (@"settingsTitle")

#define kDetailUnitPlatoKey            (@"detailUnitPlato")
#define kDetailUnitSGKey               (@"detailUnitSG")
#define kDetailUnitSGShortKey          (@"detailUnitSGShort")

#define kSectionSupportHeaderKey       (@"headerSupport")
#define kSectionStoreHeaderKey         (@"headerStore")

#define kSectionSettingsFooterKey      (@"footerSettings")
#define kSectionStoreFooterKey         (@"footerStore")

#define kSettingsItemDarkInterfaceKey  (@"itemDarkInterfaceTitle")
#define kSettingsItemGravityUnitKey    (@"itemUnitTitle")
#define kSettingsItemWortCorrectionKey (@"itemCorrectionTitle")
#define kSettingsItemVisitWebsiteKey   (@"itemWebsiteTitle")
#define kSettingsItemContactSupportKey (@"itemContactTitle")
#define kSettingsItemRateOnAppStoreKey (@"itemRateTitle")


@interface SettingsController ()

- (IBAction)unwindToSettings:(UIStoryboardSegue *)unwindSegue;

@end


@implementation SettingsController


// Always show status bar
- (BOOL)prefersStatusBarHidden {

    return NO;
}


- (void)viewDidLoad {

    [super viewDidLoad];

    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.title = NSLocalizedString(kSettingsTitleKey, nil);
}


#pragma mark - User Actions - Show Website


- (void)visitWebsite {

    NSURL *websiteURL = [NSURL URLWithString:kWebsiteURL];

    if (NSClassFromString(@"SFSafariViewController") != nil) {

        SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL:websiteURL
                                                                       entersReaderIfAvailable:NO];

        safariController.delegate = self;

        [self presentViewController:safariController animated:YES completion:nil];
    }
    else {

        [[UIApplication sharedApplication] openURL:websiteURL];
    }
}


- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {

    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - User Actions - Mail to Support


- (void)mailComposeController:(MFMailComposeViewController *)mailComposer didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    [self dismissViewControllerAnimated:YES completion:^{

            if (result == MFMailComposeResultFailed) {

                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(kMailFailedTitleKey, nil)
                                            message:NSLocalizedString(kMailFailedMessageKey, nil)
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
    }];
}


- (void)mailToSupport {

    if ([MFMailComposeViewController canSendMail]) {

        MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];

        mailComposer.mailComposeDelegate = self;
        [mailComposer setToRecipients:@[kSupportMailAddress]];
        [mailComposer setSubject:NSLocalizedString(kSupportMailSubjectKey, nil)];
        [mailComposer setMessageBody:NSLocalizedString(kSupportMailBodyKey, nil) isHTML:NO];

        [self presentViewController:mailComposer animated:YES completion:nil];
    }
    else {

        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(kMailNoAccountTitleKey, nil)
                                    message:[NSString stringWithFormat:NSLocalizedString(kMailNoAccountMessageKey, nil),
                                                                       kSupportMailAddress]
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}


#pragma mark - User Actions - Rate on AppStore


- (void)rateOnAppStore {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kStoreURL]];
}


#pragma mark - Configured Actions


- (IBAction)unwindToSettings:(UIStoryboardSegue *)unwindSegue {

    if ([unwindSegue.identifier hasPrefix:@"gravityUnitSelectedSegue_"]) {

        UITableViewController *gravityUnitController = (UITableViewController *)unwindSegue.sourceViewController;
        NSIndexPath *indexPath = (gravityUnitController.tableView).indexPathForSelectedRow;

        if (indexPath) {

            [AppDelegate appDelegate].preferredGravityUnit = (RFGravityUnit)indexPath.row;

            [self updateDisplayUnitCell];
        }
    }
    else {

        ALog(@"Unwind to Settings segue with unexpected identifier: %@", unwindSegue.identifier);
    }
}


- (IBAction)sliderAction:(id)sender {

    // Round slider value to full 1/100ths
    NSDecimal newDivisor = (@(rint(((UISlider *)sender).value * 200.0) / 200.0)).decimalValue;
    [AppDelegate appDelegate].preferredWortCorrectionDivisor = [NSDecimalNumber decimalNumberWithDecimal:newDivisor];

    [self updateWortCorrectionCell];
}


- (void)switchInterfaceMode:(id)sender {

    if ([sender respondsToSelector:@selector(isOn)]) {

        [AppDelegate appDelegate].darkInterface = [sender isOn];
    }
}


#pragma mark - Update Content of Cells


- (void)updateDisplayUnitCell {

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kSettingsUnitRow inSection:kSettingsSection]];
    BOOL shortSGDetail = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || CGRectGetWidth ([UIScreen mainScreen].bounds) <= 320);

    switch ([AppDelegate appDelegate].preferredGravityUnit) {

        case RFGravityUnitPlato:
            cell.detailTextLabel.text = NSLocalizedString(kDetailUnitPlatoKey, nil);
            break;

        case RFGravityUnitSG:
            cell.detailTextLabel.text = NSLocalizedString(shortSGDetail ? kDetailUnitSGShortKey : kDetailUnitSGKey, nil);
            break;
    }
}


- (void)updateWortCorrectionCell {

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kSettingsWortCorrectionRow inSection:kSettingsSection]];

    if ([cell isKindOfClass:[SliderCell class]]) {

        SliderCell *wortCorrectionCell = (SliderCell *)cell;

        NSDecimalNumber *divisor = [AppDelegate appDelegate].preferredWortCorrectionDivisor;

        (wortCorrectionCell.detailLabel).text = [[AppDelegate numberFormatterWortCorrectionDivisor] stringFromNumber:divisor];
        [wortCorrectionCell.slider setValue:divisor.floatValue animated:YES];
    }
    else {

        ALog(@"Settings section contains cell of unexpected type: %@", [cell class]);
    }
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == kSettingsSection && indexPath.row == kSettingsUnitRow) {

        [self performSegueWithIdentifier:@"showGravityUnitSegue" sender:self];
    }
    else if (indexPath.section == kSupportSection && indexPath.row == kSupportWebsiteRow) {

        [self visitWebsite];
    }
    else if (indexPath.section == kSupportSection && indexPath.row == kSupportMailRow) {

        [self mailToSupport];
    }
    else if (indexPath.section == kStoreSection) {

        [self rateOnAppStore];
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDataSource


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    switch (section) {

        case kSupportSection: return NSLocalizedString(kSectionSupportHeaderKey, nil);
        case kStoreSection: return NSLocalizedString(kSectionStoreHeaderKey, nil);
    }

    return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {

    switch (section) {

        case kSettingsSection: return NSLocalizedString(kSectionSettingsFooterKey, nil);
        case kStoreSection: return NSLocalizedString(kSectionStoreFooterKey, nil);
    }

    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {

        case kSettingsSection:
            return 3;

        case kSupportSection:
            return 2;

        case kStoreSection:
            return 1;
    }

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == kSettingsSection) {

        if (indexPath.row == kSettingsDarkInterfaceRow) {

            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];

            cell.textLabel.text = NSLocalizedString(kSettingsItemDarkInterfaceKey, nil);

            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            [switchView setOn:[AppDelegate appDelegate].darkInterface animated:NO];
            [switchView addTarget:self action:@selector(switchInterfaceMode:) forControlEvents:UIControlEventValueChanged];

            cell.accessoryView = switchView;
            return cell;
        }
        else if (indexPath.row == kSettingsUnitRow) {

            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnitCell" forIndexPath:indexPath];

            cell.textLabel.text = NSLocalizedString(kSettingsItemGravityUnitKey, nil);
            cell.detailTextLabel.text = @"\u2014";

            dispatch_async (dispatch_get_main_queue(), ^{ [self updateDisplayUnitCell]; });

            return cell;
        }
        else if (indexPath.row == kSettingsWortCorrectionRow) {

            SliderCell *sliderCell = (SliderCell *)[tableView dequeueReusableCellWithIdentifier:@"SliderCell" forIndexPath:indexPath];

            sliderCell.descriptionLabel.text = NSLocalizedString(kSettingsItemWortCorrectionKey, nil);
            sliderCell.detailLabel.text = @"\u2014";

            dispatch_async (dispatch_get_main_queue(), ^{ [self updateWortCorrectionCell]; });

            return sliderCell;
        }
    }
    else {

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LinkCell" forIndexPath:indexPath];

        cell.textLabel.textColor = self.view.tintColor;
        cell.accessibilityTraits = UIAccessibilityTraitNone;

        if (indexPath.section == kSupportSection) {

            switch (indexPath.row) {

                case kSupportWebsiteRow:
                    cell.textLabel.text = NSLocalizedString(kSettingsItemVisitWebsiteKey, nil);
                    cell.accessibilityTraits = cell.accessibilityTraits | UIAccessibilityTraitLink;

                    break;

                case kSupportMailRow:
                    cell.textLabel.text = NSLocalizedString(kSettingsItemContactSupportKey, nil);
                    cell.accessibilityTraits = cell.accessibilityTraits | UIAccessibilityTraitButton;
                    break;
            }
        }
        else if (indexPath.section == kStoreSection) {

            cell.textLabel.text = NSLocalizedString(kSettingsItemRateOnAppStoreKey, nil);
            cell.accessibilityTraits = cell.accessibilityTraits | UIAccessibilityTraitLink;
        }

        return cell;
    }

    ALog(@"Unhandled case in tableView:cellForRowAtIndexPath:");
    return nil;
}

@end
