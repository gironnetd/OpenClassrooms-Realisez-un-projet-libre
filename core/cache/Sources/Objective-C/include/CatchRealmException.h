//
//  Header.h
//  
//
//  Created by damien on 10/10/2022.
//

#ifndef Header_h
#define Header_h

#import <Foundation/Foundation.h>

@interface CatchRealmException : NSObject

+ (BOOL)catch:(__attribute__((noescape)) void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end

#endif /* Header_h */
