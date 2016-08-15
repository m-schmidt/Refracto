//
//  AppDelegate.h
//


// Notification sent when gravity unit or wort correction factor changes
#define kRefractoComputationDefaultsChangedNotification (@"RefractoComputationDefaultsChangedNotification")


// Units for gravity/extract
typedef NS_ENUM(NSInteger, RFGravityUnit) {

    RFGravityUnitPlato,
    RFGravityUnitSG,
};


// Modes for computation of specific gravity
typedef NS_ENUM(NSInteger, RFSpecificGravityMode) {

    RFSpecifiyGravityModeStandard,
    RFSpecifiyGravityModeKleier,
    RFSpecifiyGravityModeTerrill,
    RFSpecifiyGravityModeTerrillCubic,
};


@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (AppDelegate *)appDelegate;

@property (strong, nonatomic) UIWindow *window;

// Properties for user preferences
@property (nonatomic) BOOL darkInterface;
@property (nonatomic) RFGravityUnit preferredGravityUnit;
@property (nonatomic) RFSpecificGravityMode preferredSpecificGravityMode;
@property (strong, nonatomic) NSDecimalNumber *preferredWortCorrectionDivisor;
@property (strong, nonatomic) NSDecimalNumber *recentBeforeRefraction;
@property (strong, nonatomic) NSDecimalNumber *recentCurrentRefraction;

- (BOOL)refractionValueIsValid:(NSDecimalNumber *)refraction;

// Number formatters
+ (NSNumberFormatter *)numberFormatterBrix;

+ (NSNumberFormatter *)numberFormatterPlato;
+ (NSNumberFormatter *)accessibleNumberFormatterPlato;
+ (NSNumberFormatter *)numberFormatterSGForHorizontalSizeClass:(UIUserInterfaceSizeClass)sizeClass;
+ (NSNumberFormatter *)numberFormatterForGravityUnit:(RFGravityUnit)gravityUnit horizontalSizeClass:(UIUserInterfaceSizeClass)sizeClass accessible:(BOOL)accessible;
+ (NSNumberFormatter *)numberFormatterAttenuation;
+ (NSNumberFormatter *)numberFormatterPercentABV;
+ (NSNumberFormatter *)numberFormatterWortCorrectionDivisor;

@end
