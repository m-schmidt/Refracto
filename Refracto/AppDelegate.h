//
//  AppDelegate.h
//


// Units for gravity/extract
typedef enum
{
    RFGravityUnitPlato = 0,
    RFGravityUnitSG    = 1,
} RFGravityUnit;


// Modes for computation of specific gravity
typedef enum
{
    RFSpecifiyGravityModeStandard     = 0,
    RFSpecifiyGravityModeTerrill      = 1,
    RFSpecifiyGravityModeTerrillCubic = 2,
} RFSpecificGravityMode;


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
