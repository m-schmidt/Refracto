//
//  RefractometerTests.m
//


#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RefractometerComputation.h"
#import "AppDelegate.h"
#import "NSDecimalNumber+Refracto.h"


@interface RefractometerTests : XCTestCase

@end


@implementation RefractometerTests

- (void)setUp {

    // Computation tests below depend on assumed WCF of 1.04
    [AppDelegate appDelegate].preferredWortCorrectionDivisor = [NSDecimalNumber decimalNumberWithDecimal:[@(1.04) decimalValue]];
}


- (void)testDecimalNumberExtensions {

    NSDecimalNumber *_0 = [NSDecimalNumber zero];
    NSDecimalNumber *_1 = [NSDecimalNumber one];
    NSDecimalNumber *_2 = [NSDecimalNumber decimalNumberWithInteger:2];

    XCTAssert([_0 isLessThan:_1] == YES, @"0 < 1");
    XCTAssert([_0 isLessThan:_0] == NO,  @"0 < 0");

    XCTAssert([_0 isLessThanOrEqual:_1] == YES, @"0 <= 1");
    XCTAssert([_0 isLessThanOrEqual:_0] == YES, @"0 <= 0");
    XCTAssert([_1 isLessThanOrEqual:_0] == NO,  @"1 <= 0");

    XCTAssert([_1 isGreaterThan:_0] == YES, @"1 > 0");
    XCTAssert([_1 isGreaterThan:_1] == NO,  @"1 > 1");

    XCTAssert([_1 isGreaterThanOrEqual:_0] == YES, @"1 >= 0");
    XCTAssert([_1 isGreaterThanOrEqual:_1] == YES, @"1 >= 1");
    XCTAssert([_0 isGreaterThanOrEqual:_1] == NO,  @"0 >= 1");

    XCTAssert([_0 isGreaterThanOrEqual:_1] == NO,  @"0 >= 1");

    XCTAssert([[_1 constrainedBetweenMinimum:_0 maximum:_2] compare:_1] == NSOrderedSame, @"1 constrained in 0..2");
    XCTAssert([[_2 constrainedBetweenMinimum:_0 maximum:_1] compare:_1] == NSOrderedSame, @"2 constrained in 0..1");
    XCTAssert([[_0 constrainedBetweenMinimum:_1 maximum:_2] compare:_1] == NSOrderedSame, @"0 constrained in 1..2");
}


- (void)testRefractometerComputation {

    // Wort Correction
    XCTAssert([[RefractometerComputation wortCorrectedRefraction:[NSDecimalNumber decimalNumberWithString:@"12.8"]]
                    compare:[NSDecimalNumber decimalNumberWithString:@"12.30769231"]] == NSOrderedSame, @"Wort Correction 12.8");


    // Refractometer calculation
    NSDecimalNumber *initial = [NSDecimalNumber decimalNumberWithString:@"12.8"];
    NSDecimalNumber *final = [NSDecimalNumber decimalNumberWithString:@"6.4"];

    NSDecimalNumber *gravity = [RefractometerComputation apparentSpecificGravityForInitialRefraction:initial finalRefraction:final mode:RFSpecifiyGravityModeTerrillCubic];
    XCTAssert([gravity compare:[NSDecimalNumber decimalNumberWithString:@"1.01187741"]] == NSOrderedSame, @"Cubic Terrill 12.8 -> 6.4)");

    XCTAssert([[RefractometerComputation apparentSpecificGravityForInitialRefraction:initial finalRefraction:final mode:RFSpecifiyGravityModeTerrill]
               compare:[NSDecimalNumber decimalNumberWithString:@"1.01095655"]] == NSOrderedSame, @"Linear Terrill 12.8 -> 6.4)");

    XCTAssert([[RefractometerComputation apparentSpecificGravityForInitialRefraction:initial finalRefraction:final mode:RFSpecifiyGravityModeStandard]
               compare:[NSDecimalNumber decimalNumberWithString:@"1.01019504"]] == NSOrderedSame, @"Standard 12.8 -> 6.4)");


    // SG to °Plato
    XCTAssert([[RefractometerComputation platoForSpecificGravity:[NSDecimalNumber decimalNumberWithString:@"1.048"]]
               compare:[NSDecimalNumber decimalNumberWithString:@"11.91512851"]] == NSOrderedSame, @"SG 1.048 to Plato");

    XCTAssert([[RefractometerComputation platoForSpecificGravity:[NSDecimalNumber decimalNumberWithString:@"1.0119"]]
               compare:[NSDecimalNumber decimalNumberWithString:@"3.04443021"]] == NSOrderedSame, @"SG 1.0119 to Plato");

    XCTAssert([[RefractometerComputation platoForSpecificGravity:[NSDecimalNumber decimalNumberWithString:@"1.011"]]
               compare:[NSDecimalNumber decimalNumberWithString:@"2.81643901"]] == NSOrderedSame, @"SG 1.011 to Plato");

    XCTAssert([[RefractometerComputation platoForSpecificGravity:[NSDecimalNumber decimalNumberWithString:@"1.0102"]]
               compare:[NSDecimalNumber decimalNumberWithString:@"2.6135009"]] == NSOrderedSame, @"SG 1.0102 to Plato");


    // °Plato to SG
    XCTAssert([[RefractometerComputation specificGravityForPlato:[NSDecimalNumber decimalNumberWithString:@"0.5"]]
               compare:[NSDecimalNumber decimalNumberWithString:@"1.00193678"]] == NSOrderedSame, @"Plato 0.5 to SG");

    XCTAssert([[RefractometerComputation specificGravityForPlato:[NSDecimalNumber decimalNumberWithString:@"40"]]
               compare:[NSDecimalNumber decimalNumberWithString:@"1.17903663"]] == NSOrderedSame, @"Plato 40 to SG");

    XCTAssert([[RefractometerComputation specificGravityForPlato:[NSDecimalNumber decimalNumberWithString:@"12.31"]]
               compare:[NSDecimalNumber decimalNumberWithString:@"1.04968263"]] == NSOrderedSame, @"Plato 12.31 to SG");


    // Attenuation
    XCTAssert([[RefractometerComputation attenuationForInitialRefraction:initial currentSpecificGravity:gravity]
               compare:[NSDecimalNumber decimalNumberWithString:@"75.31046744"]] == NSOrderedSame, @"Attenuation for 12.8 -> Plato(1.0119)");


    // Alcohol Convertion
    XCTAssert([[RefractometerComputation alcoholByVolumeForInitialRefraction:initial apparentSpecificGravity:[NSDecimalNumber decimalNumberWithString:@"1.0119"]]
               compare:[NSDecimalNumber decimalNumberWithString:@"4.96354905"]] == NSOrderedSame, @"ABV 12.8 °Bx -> 1.0119 SG");

    XCTAssert([[RefractometerComputation alcoholByVolumeForInitialRefraction:initial apparentSpecificGravity:[NSDecimalNumber decimalNumberWithString:@"1.0110"]]
               compare:[NSDecimalNumber decimalNumberWithString:@"5.08571395"]] == NSOrderedSame, @"ABV 12.8 °Bx -> 1.0110 SG");

    XCTAssert([[RefractometerComputation alcoholByVolumeForInitialRefraction:initial apparentSpecificGravity:[NSDecimalNumber decimalNumberWithString:@"1.0102"]]
               compare:[NSDecimalNumber decimalNumberWithString:@"5.19445462"]] == NSOrderedSame, @"ABV 12.8 °Bx -> 1.0102 SG");
}

@end
