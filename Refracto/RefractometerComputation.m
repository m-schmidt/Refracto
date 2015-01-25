//
//  RefractometerComputation.m
//  Common Formulas for Refractometer Computations
//


#import "RefractometerComputation.h"
#import "NSDecimalNumber+Refracto.h"


@implementation RefractometerComputation

// Rounding behaviour for all computation results
+ (id<NSDecimalNumberBehaviors>)defaultBehaviour {

    return [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                  scale:8
                                                       raiseOnExactness:YES
                                                        raiseOnOverflow:YES
                                                       raiseOnUnderflow:YES
                                                    raiseOnDivideByZero:YES];
}


// Conversion from Plato to desired gravity unit or identiy
+ (NSDecimalNumber *)gravityFromPlato:(NSDecimalNumber *)plato withGravityUnit:(RFGravityUnit)gravityUnit {

    switch (gravityUnit) {

        case RFGravityUnitPlato:
            return plato;

        case RFGravityUnitSG:
            return [self specificGravityForPlato:plato];
    }

    ALog(@"Unhandled gravity unit: %lld", (long long)gravityUnit);
    return nil;
}


// Conversion from SG to desired gravity unit or identiy
+ (NSDecimalNumber *)gravityFromSG:(NSDecimalNumber *)specificGravity withGravityUnit:(RFGravityUnit)gravityUnit {

    switch (gravityUnit) {

        case RFGravityUnitPlato:
            return [self platoForSpecificGravity:specificGravity];

        case RFGravityUnitSG:
            return specificGravity;
    }

    ALog(@"Unhandled gravity unit: %lld", (long long)gravityUnit);
    return nil;
}


#pragma mark - Refractometer Computations


// Convert specific gravity (SG) to °Plato according deClerk
+ (NSDecimalNumber *)platoForSpecificGravity:(NSDecimalNumber *)gravity {

    NSDecimalNumber *result;

    NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithMantissa:668720 exponent:-3 isNegative:NO];
    NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithMantissa:463370 exponent:-3 isNegative:NO];
    NSDecimalNumber *c = [NSDecimalNumber decimalNumberWithMantissa:205347 exponent:-3 isNegative:NO];

    result = [[[a decimalNumberByMultiplyingBy:gravity]
                   decimalNumberBySubtracting:b]
                       decimalNumberBySubtracting:[c decimalNumberByMultiplyingBy:
                                                      [gravity decimalNumberByRaisingToPower:2]]];

    return [result decimalNumberByRoundingAccordingToBehavior:[self defaultBehaviour]];
}


// Convert °Plato to specific gravity (SG)
+ (NSDecimalNumber *)specificGravityForPlato:(NSDecimalNumber *)plato {

    NSDecimalNumber *result;

    // tmp = plato/258.2*227.1
    result = [[plato decimalNumberByDividingBy:
                  [NSDecimalNumber decimalNumberWithMantissa:2582 exponent:-1 isNegative:NO]]
                      decimalNumberByMultiplyingBy:
                          [NSDecimalNumber decimalNumberWithMantissa:2271 exponent:-1 isNegative:NO]];

    // tmp = 258.6 - tmp
    result = [[NSDecimalNumber decimalNumberWithMantissa:2586 exponent:-1 isNegative:NO]
                  decimalNumberBySubtracting:result];

    // tmp = plato / tmp
    result = [plato decimalNumberByDividingBy:result];

    // result = tmp + 1
    result = [result decimalNumberByAdding:[NSDecimalNumber one]];

    return [result decimalNumberByRoundingAccordingToBehavior:[self defaultBehaviour]];
}


// Applies a correction factor (e.g. 1/1.03) to refraction values to accomodate to wort
+ (NSDecimalNumber *)wortCorrectedRefraction:(NSDecimalNumber *)brix {

    NSDecimalNumber *divisor = [AppDelegate appDelegate].preferredWortCorrectionDivisor;
    NSDecimalNumber *result = [brix decimalNumberByDividingBy:divisor];

    return [result decimalNumberByRoundingAccordingToBehavior:[self defaultBehaviour]];
}


// Compute apparent specific gravity from refraction values before and after fermentation
+ (NSDecimalNumber *)apparentSpecificGravityForInitialRefraction:(NSDecimalNumber *)initial finalRefraction:(NSDecimalNumber *)final mode:(RFSpecificGravityMode)mode {

    NSDecimalNumber *result = nil;

    NSDecimalNumber *correctedInitial = [self wortCorrectedRefraction:initial];
    NSDecimalNumber *correctedFinal = [self wortCorrectedRefraction:final];

    if (mode == RFSpecifiyGravityModeStandard) {

        // 1.001843
        result = [NSDecimalNumber decimalNumberWithMantissa:1001843 exponent:-6 isNegative:NO];

        // - 0.002318474*(corrected RIi)
        result = [result decimalNumberBySubtracting:
                     [correctedInitial decimalNumberByMultiplyingBy:
                         [NSDecimalNumber decimalNumberWithMantissa:2318474 exponent:-9 isNegative:NO]]];

        // - 0.000007775*(corrected RIi)^2
        result = [result decimalNumberBySubtracting:
                     [[correctedInitial decimalNumberByRaisingToPower:2]
                         decimalNumberByMultiplyingBy:
                             [NSDecimalNumber decimalNumberWithMantissa:7775 exponent:-9 isNegative:NO]]];

        // - 0.000000034*(corrected RIi)^3
        result = [result decimalNumberBySubtracting:
                     [[correctedInitial decimalNumberByRaisingToPower:3]
                         decimalNumberByMultiplyingBy:
                             [NSDecimalNumber decimalNumberWithMantissa:34 exponent:-9 isNegative:NO]]];

        // + 0.00574*final
        result = [result decimalNumberByAdding:
                     [final decimalNumberByMultiplyingBy:
                         [NSDecimalNumber decimalNumberWithMantissa:574 exponent:-5 isNegative:NO]]];

        // + 0.00003344*final^2
        result = [result decimalNumberByAdding:
                     [[final decimalNumberByRaisingToPower:2]
                         decimalNumberByMultiplyingBy:
                             [NSDecimalNumber decimalNumberWithMantissa:3344 exponent:-8 isNegative:NO]]];

        // + 0.000000086*final^3
        result = [result decimalNumberByAdding:
                     [[final decimalNumberByRaisingToPower:3]
                         decimalNumberByMultiplyingBy:
                             [NSDecimalNumber decimalNumberWithMantissa:86 exponent:-9 isNegative:NO]]];
    }
    else if (mode == RFSpecifiyGravityModeTerrill) {

        // 1.0
        result = [NSDecimalNumber one];

        // - 0.00085683*(corrected RIi)
        result = [result decimalNumberBySubtracting:
                  [correctedInitial decimalNumberByMultiplyingBy:
                   [NSDecimalNumber decimalNumberWithMantissa:85683 exponent:-8 isNegative:NO]]];

        // + 0.0034941*(corrected RIf)
        result = [result decimalNumberByAdding:
                  [correctedFinal decimalNumberByMultiplyingBy:
                   [NSDecimalNumber decimalNumberWithMantissa:34941 exponent:-7 isNegative:NO]]];
    }
    else if (mode == RFSpecifiyGravityModeTerrillCubic) {

        // 1.0
        result = [NSDecimalNumber one];

        // - 0.0044993*(corrected RIi)
        result = [result decimalNumberBySubtracting:
                     [correctedInitial decimalNumberByMultiplyingBy:
                         [NSDecimalNumber decimalNumberWithMantissa:44993 exponent:-7 isNegative:NO]]];

        // + 0.011774*(corrected RIf)
        result = [result decimalNumberByAdding:
                     [correctedFinal decimalNumberByMultiplyingBy:
                         [NSDecimalNumber decimalNumberWithMantissa:11774 exponent:-6 isNegative:NO]]];

        // + 0.00027581*(corrected RIi)^2
        result = [result decimalNumberByAdding:
                     [[correctedInitial decimalNumberByRaisingToPower:2]
                         decimalNumberByMultiplyingBy:
                             [NSDecimalNumber decimalNumberWithMantissa:27581 exponent:-8 isNegative:NO]]];

        // - 0.0012717*(corrected RIf)^2
        result = [result decimalNumberBySubtracting:
                     [[correctedFinal decimalNumberByRaisingToPower:2]
                         decimalNumberByMultiplyingBy:
                             [NSDecimalNumber decimalNumberWithMantissa:12717 exponent:-7 isNegative:NO]]];

        // - 0.00000728*(corrected RIi)^3
        result = [result decimalNumberBySubtracting:
                     [[correctedInitial decimalNumberByRaisingToPower:3]
                         decimalNumberByMultiplyingBy:
                             [NSDecimalNumber decimalNumberWithMantissa:728 exponent:-8 isNegative:NO]]];


        // + 0.000063293*(corrected RIf)^3
        result = [result decimalNumberByAdding:
                     [[correctedFinal decimalNumberByRaisingToPower:3]
                         decimalNumberByMultiplyingBy:
                             [NSDecimalNumber decimalNumberWithMantissa:63293 exponent:-9 isNegative:NO]]];
    }
    else {

        ALog(@"Unhandled mode for specific gravity computation");
    }

    return [result decimalNumberByRoundingAccordingToBehavior:[self defaultBehaviour]];
}


// Convert apparent specific gravity to true specific gravity according Balling
+ (NSDecimalNumber *)trueSpecificGravityForApparentSpecificGravity:(NSDecimalNumber *)apparent initialRefraction:(NSDecimalNumber *)initial {

    NSDecimalNumber *result;

    // 0.1808*(corrected RIi)
    result = [[self wortCorrectedRefraction:initial]
                 decimalNumberByMultiplyingBy:
                     [NSDecimalNumber decimalNumberWithMantissa:1808 exponent:-4 isNegative:NO]];

    // + 0.8192*(gravity converted to Plato)
    result  = [result decimalNumberByAdding:
                  [[self platoForSpecificGravity:apparent]
                      decimalNumberByMultiplyingBy:
                          [NSDecimalNumber decimalNumberWithMantissa:8192 exponent:-4 isNegative:NO]]];

    // convert plato to specific gravity
    result = [self specificGravityForPlato:result];

    return [result decimalNumberByRoundingAccordingToBehavior:[self defaultBehaviour]];
}


#pragma mark - Attenuation Computations


// Compute apparent/real attenuation in percent from initial refraction index and the apparent/actual specific gravity.
+ (NSDecimalNumber *)attenuationForInitialRefraction:(NSDecimalNumber *)initial currentSpecificGravity:(NSDecimalNumber *)gravity {

    NSDecimalNumber *correctedInitial = [self wortCorrectedRefraction:initial];


    // tmp = (apparent gravity converted to Plato / corrected RIi)
    NSDecimalNumber *result = [[self platoForSpecificGravity:gravity]
                                  decimalNumberByDividingBy:correctedInitial];

    // result = (1 - tmp) * 100
    result = [[[NSDecimalNumber one] decimalNumberBySubtracting:result]
                 decimalNumberByMultiplyingBy:
                     [NSDecimalNumber decimalNumberWithMantissa:1 exponent:2 isNegative:NO]];

    result = [result decimalNumberByRoundingAccordingToBehavior:[self defaultBehaviour]];

    return [result constrainedBetweenMinimum:[NSDecimalNumber zero] maximum:[NSDecimalNumber decimalNumberWithInteger:100]];
}


#pragma mark - Alcohol Computations


// Compute alcohol by volume in percent from initial refraction index and the apparent specific gravity.
+ (NSDecimalNumber *)alcoholByVolumeForInitialRefraction:(NSDecimalNumber *)initial apparentSpecificGravity:(NSDecimalNumber *)apparent {

    NSDecimalNumber *correctedInitial = [self wortCorrectedRefraction:initial];


    // Convert apparent specific gravity (SG) into true specific gravity (°P)
    NSDecimalNumber *trueGravity = nil;

    // 0.1808*(corrected RIi)
    trueGravity = [correctedInitial decimalNumberByMultiplyingBy:
                      [NSDecimalNumber decimalNumberWithMantissa:1808 exponent:-4 isNegative:NO]];

    // + 0.8192*(apparent gravity converted to Plato)
    trueGravity = [trueGravity decimalNumberByAdding:
                      [[self platoForSpecificGravity:apparent]
                          decimalNumberByMultiplyingBy:
                              [NSDecimalNumber decimalNumberWithMantissa:8192 exponent:-4 isNegative:NO]]];


    // Compute alcoholic content
    NSDecimalNumber *result = nil;

    // tmp = (corrected RIi - true gravity)/0.79  (FIXME? Sean Terrill's converter uses 0.819 instead of 0.79 which leads to slightly lower ABV)
    result = [[correctedInitial decimalNumberBySubtracting:trueGravity]
                 decimalNumberByDividingBy:
                     [NSDecimalNumber decimalNumberWithMantissa:79 exponent:-2 isNegative:NO]];

    // result = tmp / (2.0665 - 0.010665*corrected RIi)
    result = [result decimalNumberByDividingBy:
                 [[NSDecimalNumber decimalNumberWithMantissa:20665 exponent:-4 isNegative:NO]
                     decimalNumberBySubtracting:
                         [correctedInitial decimalNumberByMultiplyingBy:
                             [NSDecimalNumber decimalNumberWithMantissa:10665 exponent:-6 isNegative:NO]]]];

    result = [result decimalNumberByRoundingAccordingToBehavior:[self defaultBehaviour]];

    return [result constrainedBetweenMinimum:[NSDecimalNumber zero] maximum:[NSDecimalNumber decimalNumberWithInteger:100]];
}


// Compute alcohol by volume in percent from original and final gravity.
+ (NSDecimalNumber *)alcoholByVolumeForOriginalGravity:(NSDecimalNumber *)original finalGravity:(NSDecimalNumber *)final {

    NSDecimalNumber *result;

    // tmp = 1.05 * (original - final)
    result = [[original decimalNumberBySubtracting:final]
                 decimalNumberByMultiplyingBy:
                     [NSDecimalNumber decimalNumberWithMantissa:105 exponent:-2 isNegative:NO]];

    // tmp = tmp / final
    result = [result decimalNumberByDividingBy:final];

    // result = tmp / 0.0079
    result = [result decimalNumberByDividingBy:
                 [NSDecimalNumber decimalNumberWithMantissa:79 exponent:-4 isNegative:NO]];

    result = [result decimalNumberByRoundingAccordingToBehavior:[self defaultBehaviour]];

    return [result constrainedBetweenMinimum:[NSDecimalNumber zero] maximum:[NSDecimalNumber decimalNumberWithInteger:100]];
}


// Convert ABV to ABW
+ (NSDecimalNumber *)alcoholByWeightForAlcoholByVolume:(NSDecimalNumber *)abv {

    NSDecimalNumber *factor = [NSDecimalNumber decimalNumberWithMantissa:79336 exponent:-5 isNegative:NO];
    NSDecimalNumber *result = [abv decimalNumberByMultiplyingBy:factor];

    result = [result decimalNumberByRoundingAccordingToBehavior:[self defaultBehaviour]];

    return [result constrainedBetweenMinimum:[NSDecimalNumber zero] maximum:[NSDecimalNumber decimalNumberWithInteger:100]];
}

@end
