//
//  AppDelegate.h
//


// Units for gravity/extract
typedef NS_ENUM(NSInteger, RFGravityUnit) {

    RFGravityUnitPlato = 0,
    RFGravityUnitSG    = 1,
};


// Modes for computation of specific gravity
typedef NS_ENUM(NSInteger, RFSpecificGravityMode) {

    RFSpecifiyGravityModeStandard     = 0,
    RFSpecifiyGravityModeTerrill      = 1,
    RFSpecifiyGravityModeTerrillCubic = 2,
};


@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (AppDelegate *)sharedAppDelegate;

@property (strong, nonatomic) UIWindow *window;

// Properties for user preferences
@property (nonatomic) RFGravityUnit preferredGravityUnit;
@property (nonatomic) RFSpecificGravityMode preferredSpecificGravityMode;
@property (strong, nonatomic) NSDecimalNumber *preferredWortCorrectionDivisor;
@property (strong, nonatomic) NSDecimalNumber *recentBeforeRefraction;
@property (strong, nonatomic) NSDecimalNumber *recentCurrentRefraction;

// Number formatters
+ (NSNumberFormatter *)numberFormatterBrix;
+ (NSNumberFormatter *)numberFormatterPlato;
+ (NSNumberFormatter *)numberFormatterSG;
+ (NSNumberFormatter *)numberFormatterForGravityUnit:(RFGravityUnit)gravityUnit;
+ (NSNumberFormatter *)numberFormatterAttenuation;
+ (NSNumberFormatter *)numberFormatterPercentABV;
+ (NSNumberFormatter *)numberFormatterWortCorrectionDivisor;

@end
