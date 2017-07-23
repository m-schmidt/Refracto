//
//  SettingsController.m
//  Controller for Settings Tab
//


#import <MessageUI/MessageUI.h>
#import <SafariServices/SafariServices.h>
#import "SettingsController.h"
#import "SliderCell.h"
#import "AppDelegate.h"
#import "Theme.h"


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
static NSString *kWebsiteURL         = @"https://mschmidt.me/refracto.html";
static NSString *kSupportMailAddress = @"refracto@mschmidt.me";
static NSString *kStoreURL           = @"itms-apps://itunes.apple.com/app/id954981822?action=write-review";


// Mail contents and alerts
#define kSupportMailSubjectKey         (@"mailSubject")
#define kSupportMailBodyKey            (@"mailBody")

#define kMailFailedTitleKey            (@"mailFailedTitle")
#define kMailFailedMessageKey          (@"mailFailedMessage")

#define kMailNoAccountTitleKey         (@"mailNoAccountTitle")
#define kMailNoAccountMessageKey       (@"mailNoAccountMessage")

#define kAlertOKTitleKey               (@"alertOKTitleKey")

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

// Data to restore content offset on theme switch
static CGFloat previousContentYOffset = 0.0;


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

    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
    }

    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.title = NSLocalizedString(kSettingsTitleKey, nil);
}


- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    if (previousContentYOffset != 0.0) {

        self.tableView.contentOffset = CGPointMake(0.0, previousContentYOffset);
        previousContentYOffset = 0.0;
    }
}


#pragma mark - User Actions - Show Website


- (void)visitWebsite {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kWebsiteURL]
                                       options:@{}
                             completionHandler:nil];
}


#pragma mark - User Actions - Mail to Support


- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(kAlertOKTitleKey, nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];

    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)mailComposeController:(MFMailComposeViewController *)mailComposer didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    [self dismissViewControllerAnimated:YES completion:^{

            if (result == MFMailComposeResultFailed) {

                [self showAlertWithTitle:NSLocalizedString(kMailFailedTitleKey, nil)
                                 message:NSLocalizedString(kMailFailedMessageKey, nil)];
            }
    }];
}


- (void)mailToSupport {

    if ([MFMailComposeViewController canSendMail]) {

        MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];

        mailComposer.mailComposeDelegate = self;
        mailComposer.view.tintColor = [Theme sharedTheme].systemTintColor;
        [mailComposer setToRecipients:@[kSupportMailAddress]];
        [mailComposer setSubject:NSLocalizedString(kSupportMailSubjectKey, nil)];
        [mailComposer setMessageBody:NSLocalizedString(kSupportMailBodyKey, nil) isHTML:NO];

        [self presentViewController:mailComposer animated:YES completion:nil];
    }
    else {

        [self showAlertWithTitle:NSLocalizedString(kMailNoAccountTitleKey, nil)
                         message:[NSString stringWithFormat:NSLocalizedString(kMailNoAccountMessageKey, nil),
                                                            kSupportMailAddress]];
    }
}


#pragma mark - User Actions - Rate on AppStore


- (void)rateOnAppStore {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kStoreURL]
                                       options:@{}
                             completionHandler:nil];
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

        self.view.userInteractionEnabled = NO;

        if (UI_USER_INTERFACE_IDIOM () == UIUserInterfaceIdiomPhone) {

            previousContentYOffset = self.tableView.contentOffset.y;
        }

        BOOL darkInterface = [sender isOn];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            self.view.userInteractionEnabled = YES;
            [AppDelegate appDelegate].darkInterface = darkInterface;
        });
    }
}


#pragma mark - Update Content of Cells


- (void)updateDisplayUnitCell {

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kSettingsUnitRow inSection:kSettingsSection]];
    [self configureDisplayUnitForCell:cell];
}


- (void)configureDisplayUnitForCell:(UITableViewCell *)cell {

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

        [self configureWortCorrectionForCell:(SliderCell *)cell];
    }
    else {

        ALog(@"Settings section contains cell of unexpected type: %@", [cell class]);
    }
}


- (void)configureWortCorrectionForCell:(SliderCell *)wortCorrectionCell {

    NSDecimalNumber *divisor = [AppDelegate appDelegate].preferredWortCorrectionDivisor;

    (wortCorrectionCell.detailLabel).text = [[AppDelegate numberFormatterWortCorrectionDivisor] stringFromNumber:divisor];
    [wortCorrectionCell.slider setValue:divisor.floatValue animated:YES];
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

            [self configureDisplayUnitForCell:cell];
            return cell;
        }
        else if (indexPath.row == kSettingsWortCorrectionRow) {

            SliderCell *sliderCell = (SliderCell *)[tableView dequeueReusableCellWithIdentifier:@"SliderCell" forIndexPath:indexPath];

            sliderCell.descriptionLabel.text = NSLocalizedString(kSettingsItemWortCorrectionKey, nil);
            sliderCell.detailLabel.text = @"\u2014";

            [self configureWortCorrectionForCell:sliderCell];
            return sliderCell;
        }
    }
    else {

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LinkCell" forIndexPath:indexPath];

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
