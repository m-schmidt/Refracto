//
//  RefractometerComputation.h
//  Common Formulas for Refractometer Computations
//


#import "AppDelegate.h"


@interface RefractometerComputation : NSObject

// Rounding behaviour for all computation results
+ (id<NSDecimalNumberBehaviors>)defaultBehaviour;

// Conversion from Plato/SG to desired gravity unit or identiy
+ (NSDecimalNumber *)gravityFromPlato:(NSDecimalNumber *)plato withGravityUnit:(RFGravityUnit)gravityUnit;
+ (NSDecimalNumber *)gravityFromSG:(NSDecimalNumber *)specificGravity withGravityUnit:(RFGravityUnit)gravityUnit;


#pragma mark - Refraction Computations


// Convert specific gravity (SG) to °Plato according deClerk
+ (NSDecimalNumber *)platoForSpecificGravity:(NSDecimalNumber *)gravity;

// Convert °Plato to specific gravity (SG)
+ (NSDecimalNumber *)specificGravityForPlato:(NSDecimalNumber *)plato;

// Applies a correction factor (e.g. 1/1.04) to raw refraction values
// For unfermented wort this converts Brix to Plato.
+ (NSDecimalNumber *)wortCorrectedRefraction:(NSDecimalNumber *)brix;

// Compute apparent specific gravity from refraction values before and after fermentation
+ (NSDecimalNumber *)apparentSpecificGravityForInitialRefraction:(NSDecimalNumber *)initial finalRefraction:(NSDecimalNumber *)final mode:(RFSpecificGravityMode)mode;

// Convert apparent specific gravity to true specific gravity according Balling
+ (NSDecimalNumber *)trueSpecificGravityForApparentSpecificGravity:(NSDecimalNumber *)apparent initialRefraction:(NSDecimalNumber *)initial;


#pragma mark - Attenuation Computations


// Compute apparent/real attenuation in percent from initial refraction index and the apparent/actual specific gravity.
+ (NSDecimalNumber *)attenuationForInitialRefraction:(NSDecimalNumber *)initial currentSpecificGravity:(NSDecimalNumber *)gravity;


#pragma mark - Alcohol Computations


// Compute alcohol by volume in percent from initial refraction index and apparent specific gravity.
+ (NSDecimalNumber *)alcoholByVolumeForInitialRefraction:(NSDecimalNumber *)initial apparentSpecificGravity:(NSDecimalNumber *)apparent;

// Compute alcohol by volume in percent from original and final gravity.
+ (NSDecimalNumber *)alcoholByVolumeForOriginalGravity:(NSDecimalNumber *)original finalGravity:(NSDecimalNumber *)final;

// Convert ABV to ABW
+ (NSDecimalNumber *)alcoholByWeightForAlcoholByVolume:(NSDecimalNumber *)abv;

@end
