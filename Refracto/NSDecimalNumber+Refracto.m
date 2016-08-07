//
//  NSDecimalNumber+Refracto.m
//  Extensions for NSDecimalNumber class
//


#import "NSDecimalNumber+Refracto.h"


@implementation NSDecimalNumber (RefractoExtension)

+ (instancetype)decimalNumberWithInteger:(NSInteger)value {

    return [NSDecimalNumber decimalNumberWithDecimal:(@(value)).decimalValue];
}


- (BOOL)isGreaterThan:(NSDecimalNumber *)number {

    return (number != nil && [self compare:number] == NSOrderedDescending);
}


- (BOOL)isGreaterThanOrEqual:(NSDecimalNumber *)number {

    return (number != nil && [self compare:number] != NSOrderedAscending);
}


- (BOOL)isLessThan:(NSDecimalNumber *)number {

    return (number != nil && [self compare:number] == NSOrderedAscending);
}


- (BOOL)isLessThanOrEqual:(NSDecimalNumber *)number {

    return (number != nil && [self compare:number] != NSOrderedDescending);
}


- (NSDecimalNumber *)constrainedBetweenMinimum:(NSDecimalNumber *)min maximum:(NSDecimalNumber *)max {

    if (min != nil && [self compare:min] != NSOrderedDescending) {

        return min;
    }
    else if (max != nil && [self compare:max] != NSOrderedAscending) {

        return max;
    }

    return self;
}

@end
