//
//  APIManager.h
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/4/21.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (instancetype)shared;
- (void)registerUser:(NSString *)username password:(NSString *)password completion:(void(^)(BOOL succeeded, NSError *error))completion;
- (void)loginUser:(NSString *)username password:(NSString *)password completion:(void(^)(PFUser *user, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
