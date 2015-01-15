//
//  NSDecimalNumber+Refracto.h
//  Extensions for NSDecimalNumber class
//


@interface NSDecimalNumber (RefractoExtension)

+ (instancetype)decimalNumberWithInteger:(NSInteger)value;

- (BOOL)isGreaterThan:(NSDecimalNumber *)number;
- (BOOL)isGreaterThanOrEqual:(NSDecimalNumber *)number;

- (BOOL)isLessThan:(NSDecimalNumber *)number;
- (BOOL)isLessThanOrEqual:(NSDecimalNumber *)number;

- (NSDecimalNumber *)constrainedBetweenMinimum:(NSDecimalNumber *)min maximum:(NSDecimalNumber *)max;

@end
