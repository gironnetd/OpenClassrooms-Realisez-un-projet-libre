//
//  File.m
//  
//
//  Created by damien on 10/10/2022.
//

#import "RealmException.h"

@implementation RealmException

+ (BOOL)catch:(__attribute__((noescape)) void(^)(void))tryBlock error:(__autoreleasing NSError **)error {
    @try {
        tryBlock();
        return YES;
    } @catch (NSException *exception) {
        *error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:@{
            NSUnderlyingErrorKey: exception,
            NSLocalizedDescriptionKey: exception.reason,
            @"CallStackSymbols": exception.callStackSymbols
        }];

        return NO;
    }
}

@end
