//
//  Theme.h
//

@interface Theme : NSObject

// Setup color theme via UIAppearance
+ (void)setupColors:(BOOL)darkTheme;

// Foreground color for labels (defined for level 0..1)
+ (UIColor *)labelForegroundColor:(BOOL)darkTheme atLevel:(int)level;

// Colors for separator lines (defined for level 0..3)
+ (UIColor *)separatorColor:(BOOL)darkTheme atLevel:(int)level;

// Background color for input area
+ (UIColor *)inputBackgroundColor:(BOOL)darkTheme;

// Background color for display area
+ (UIColor *)displayBackgroundColor:(BOOL)darkTheme;

// Background color for settings table view
+ (UIColor *)settingsBackgroundColor:(BOOL)darkTheme;

// Background color for popover on iPad
+ (UIColor *)settingsPopoverBackgroundColor:(BOOL)darkTheme;

// Background color for cells in settings table view
+ (UIColor *)settingsCellBackgroundColor:(BOOL)darkTheme;

// View used as selection indicator in settings table view
+ (UIView *)settingsSelectedCellBackgroundView:(BOOL)darkTheme;

// Color for slider knob in settings table view
+ (UIColor *)settingsKnobColor:(BOOL)darkTheme;

// Global tint color
+ (UIColor *)tintColor:(BOOL)darkTheme;

// Global tint color for navigation and tab bars
+ (UIColor *)barTintColor:(BOOL)darkTheme;

// Global tint color for on state of switches
+ (UIColor *)onTintColor:(BOOL)darkTheme;

// Status bar style for view controllers
+ (UIStatusBarStyle)statusBarStyle:(BOOL)darkTheme;

// bar style for navigation bars
+ (UIBarStyle)barStyle:(BOOL)darkTheme;

@end


#pragma mark Dummy Classes and UIAppearance Extensions


@interface UITableView (Appearance)<UIAppearance>

@property (strong, nonatomic) UIColor *thmBackgroundColor UI_APPEARANCE_SELECTOR;

@end


@interface UITableViewCell (Appearance)<UIAppearance>

@property (strong, nonatomic) UIColor *thmBackgroundColor UI_APPEARANCE_SELECTOR;

@end


@interface UICollectionReusableView (Appearance)<UIAppearance>

@property (strong, nonatomic) UIColor *thmBackgroundColor UI_APPEARANCE_SELECTOR;

@end


@interface PrimaryLabel : UILabel

@end


@interface SecondaryLabel : UILabel

@end


@interface PrimarySeparator : UIView

@end


@interface SecondarySeparator : UIView

@end


@interface TertiarySeparator : UIView

@end
