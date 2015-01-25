//
//  AppDelegate.h
//


// Units for gravity/extract
typedef NS_ENUM(NSInteger, RFGravityUnit) {

    RFGravityUnitPlato,
    RFGravityUnitSG,
};


// Modes for computation of specific gravity
typedef NS_ENUM(NSInteger, RFSpecificGravityMode) {

    RFSpecifiyGravityModeStandard,
    RFSpecifiyGravityModeTerrill,
    RFSpecifiyGravityModeTerrillCubic,
};


@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (AppDelegate *)appDelegate;

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
