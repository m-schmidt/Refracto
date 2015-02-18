//
//  AppDelegate.m
//


#import "AppDelegate.h"
#import "NSDecimalNumber+Refracto.h"


// Keys for user preferences
#define kSpecificGravityUnit    (@"displayUnit")
#define kSpecificGravityMode    (@"specificGravityMode")
#define kInputRefractionBefore  (@"inputBeforeRefraction")
#define kInputRefractionCurrent (@"inputCurrentRefraction")
#define kWortCorrectionDivisor  (@"wortCorrectionDivisor")


@implementation AppDelegate

+ (AppDelegate *)appDelegate {

    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;

    if ([delegate isKindOfClass:[self class]] == NO) {

        ALog(@"Unexpected type for application delegate: %@", [delegate class]);
        return nil;
    };

    return (AppDelegate *)delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[NSUserDefaults standardUserDefaults] registerDefaults:
        @{kSpecificGravityUnit:    @([self gravityUnitGuessedFromLocale]),
          kSpecificGravityMode:    @(RFSpecifiyGravityModeTerrill),
          kInputRefractionBefore:  [NSDecimalNumber decimalNumberWithMantissa:125 exponent:-1 isNegative:NO],
          kInputRefractionCurrent: [NSDecimalNumber decimalNumberWithMantissa:64  exponent:-1 isNegative:NO],
          kWortCorrectionDivisor:  [NSDecimalNumber decimalNumberWithMantissa:103 exponent:-2 isNegative:NO]}];

    return YES;
}


- (RFGravityUnit)gravityUnitGuessedFromLocale {

    NSString *country = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleCountryCode];

    if ([country isEqualToString:@"US"] ||
        [country isEqualToString:@"CA"] ||
        [country isEqualToString:@"GB"] ||
        [country isEqualToString:@"IE"] ||
        [country isEqualToString:@"AU"] ||
        [country isEqualToString:@"NZ"]) {

        return RFGravityUnitSG;
    }
    else {

        return RFGravityUnitPlato;
    }
}


#pragma mark Properties for User Preferences


- (RFGravityUnit)preferredGravityUnit {

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger gravityUnit = [[standardUserDefaults objectForKey:kSpecificGravityUnit] integerValue];

    if (0 <= gravityUnit && gravityUnit <= 1) {

        return (RFGravityUnit)gravityUnit;
    }
    else {

        ALog(@"Userdefaults cannot be converted to gravity unit: %lld", (long long)gravityUnit);
        return [self gravityUnitGuessedFromLocale];
    }
}


- (void)setPreferredGravityUnit:(RFGravityUnit)gravityUnit {

    if (gravityUnit == RFGravityUnitPlato || gravityUnit == RFGravityUnitSG) {

        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

        [standardUserDefaults setObject:@((NSInteger)gravityUnit) forKey:kSpecificGravityUnit];
        [standardUserDefaults synchronize];
    }
    else {

        ALog(@"Gravity unit out of range: %lld", (long long)gravityUnit);
    }
}


- (RFSpecificGravityMode)preferredSpecificGravityMode {

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger specificGravityMode = [[standardUserDefaults objectForKey:kSpecificGravityMode] integerValue];

    if (0 <= specificGravityMode && specificGravityMode <= 2) {

        return (RFSpecificGravityMode)specificGravityMode;
    }
    else {

        ALog(@"Userdefaults cannot be converted to specific gravity mode: %lld", (long long)specificGravityMode);
        return RFSpecifiyGravityModeTerrillCubic;
    }
}


- (void)setPreferredSpecificGravityMode:(RFSpecificGravityMode)specificGravityMode {

    if (specificGravityMode == RFSpecifiyGravityModeStandard || specificGravityMode == RFSpecifiyGravityModeTerrill || specificGravityMode == RFSpecifiyGravityModeTerrillCubic) {

        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

        [standardUserDefaults setObject:@((NSInteger)specificGravityMode) forKey:kSpecificGravityMode];
        [standardUserDefaults synchronize];
    }
    else {

        ALog(@"Specific gravity mode out of range: %lld", (long long)specificGravityMode);
    }
}


- (NSDecimalNumber *)preferredWortCorrectionDivisor {

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    id rawDivisor = [standardUserDefaults objectForKey:kWortCorrectionDivisor];

    if ([rawDivisor respondsToSelector:@selector(decimalValue)]) {

        return [NSDecimalNumber decimalNumberWithDecimal:[rawDivisor decimalValue]];
    }
    else {

        ALog(@"Userdefaults cannot be converted to decimal number: %@", rawDivisor);
        return [NSDecimalNumber decimalNumberWithMantissa:103 exponent:-2 isNegative:NO];
    }
}


- (void)setPreferredWortCorrectionDivisor:(NSDecimalNumber *)divisor {

    NSDecimalNumber *min = [NSDecimalNumber decimalNumberWithMantissa:102 exponent:-2 isNegative:NO];
    NSDecimalNumber *max = [NSDecimalNumber decimalNumberWithMantissa:106 exponent:-2 isNegative:NO];

    if ([divisor isGreaterThanOrEqual:min] && [divisor isLessThanOrEqual:max]) {

        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

        [standardUserDefaults setObject:divisor forKey:kWortCorrectionDivisor];
        [standardUserDefaults synchronize];
    }
    else {

        ALog(@"Wort correction divisor out of range: %@", divisor);
    }
}


- (NSDecimalNumber *)recentBeforeRefraction {

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    id rawRefraction = [standardUserDefaults objectForKey:kInputRefractionBefore];

    if ([rawRefraction respondsToSelector:@selector(decimalValue)]) {

        return [NSDecimalNumber decimalNumberWithDecimal:[rawRefraction decimalValue]];
    }
    else {

        ALog(@"Userdefaults cannot be converted to decimal number: %@", rawRefraction);
        return [NSDecimalNumber zero];
    }
}


- (void)setRecentBeforeRefraction:(NSDecimalNumber *)beforeRefraction {

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

    [standardUserDefaults setObject:beforeRefraction forKey:kInputRefractionBefore];
    [standardUserDefaults synchronize];
}


- (NSDecimalNumber *)recentCurrentRefraction {

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    id rawRefraction = [standardUserDefaults objectForKey:kInputRefractionCurrent];

    if ([rawRefraction respondsToSelector:@selector(decimalValue)]) {

        return [NSDecimalNumber decimalNumberWithDecimal:[rawRefraction decimalValue]];
    }
    else {

        ALog(@"Userdefaults cannot be converted to decimal number: %@", rawRefraction);
        return [NSDecimalNumber zero];
    }
}


- (void)setRecentCurrentRefraction:(NSDecimalNumber *)currentRefraction {

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

    [standardUserDefaults setObject:currentRefraction forKey:kInputRefractionCurrent];
    [standardUserDefaults synchronize];
}


#pragma mark - Number Formatters


+ (NSNumberFormatter *)numberFormatterBrix {

    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t once;

    dispatch_once (&once, ^{

        formatter = [[NSNumberFormatter alloc] init];
        formatter.positiveFormat = @"#0.0";
        formatter.locale = [NSLocale autoupdatingCurrentLocale];
    });

    return formatter;
}


+ (NSNumberFormatter *)numberFormatterPlato {

    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t once;

    dispatch_once (&once, ^{

        formatter = [[NSNumberFormatter alloc] init];
        formatter.positiveFormat = @"#0.0'\u2009°P'";
        formatter.locale = [NSLocale autoupdatingCurrentLocale];
    });

    return formatter;
    return [self numberFormatterBrix];
}


+ (NSNumberFormatter *)numberFormatterSG {

    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t once;

    dispatch_once (&once, ^{

        formatter = [[NSNumberFormatter alloc] init];

        if (UI_USER_INTERFACE_IDIOM () == UIUserInterfaceIdiomPad) {

            formatter.positiveFormat = @"#0.0000";
        }
        else {

            formatter.positiveFormat = @"#0.000";
        }

        formatter.locale = [NSLocale autoupdatingCurrentLocale];
    });

    return formatter;
}


+ (NSNumberFormatter *)numberFormatterForGravityUnit:(RFGravityUnit)gravityUnit {

    switch (gravityUnit) {

        case RFGravityUnitPlato:
            return [self numberFormatterPlato];

        case RFGravityUnitSG:
            return [self numberFormatterSG];
    }

    ALog(@"Unhandled gravity unit: %lld", (long long)gravityUnit);
    return nil;

}


+ (NSNumberFormatter *)numberFormatterAttenuation {

    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t once;

    dispatch_once (&once, ^{

        formatter = [[NSNumberFormatter alloc] init];
        formatter.positiveFormat = @"#0'\u2009%'";
        formatter.locale = [NSLocale autoupdatingCurrentLocale];
    });

    return formatter;
}


+ (NSNumberFormatter *)numberFormatterPercentABV {

    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t once;

    dispatch_once (&once, ^{

        formatter = [[NSNumberFormatter alloc] init];
        formatter.positiveFormat = @"#0.0'\u2009%'";
        formatter.locale = [NSLocale autoupdatingCurrentLocale];
    });

    return formatter;
}


+ (NSNumberFormatter *)numberFormatterWortCorrectionDivisor {

    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t once;

    dispatch_once (&once, ^{

        formatter = [[NSNumberFormatter alloc] init];
        formatter.positiveFormat = @"'1/'0.000";
        formatter.locale = [NSLocale autoupdatingCurrentLocale];
    });

    return formatter;
}


#pragma mark - State Restoration


- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {

    return YES;
}


- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {

    NSInteger bundleVersion = [[[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleVersionKey] integerValue];
    NSInteger stateVersion = [[coder decodeObjectForKey:UIApplicationStateRestorationBundleVersionKey] integerValue];

    return (stateVersion <= bundleVersion);
}

@end
