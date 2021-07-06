//
//  APIManager.h
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/4/21.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (instancetype)shared;

//User Authentication
- (void)registerUser:(NSString *)username password:(NSString *)password completion:(void(^)(BOOL succeeded, NSError *error))completion;
- (void)loginUser:(NSString *)username password:(NSString *)password completion:(void(^)(PFUser *user, NSError *error))completion;
- (void)logout:(void(^)(NSError *error))completion;

//feed
- (void)getPostAuthor:(Post *)post completion:(void(^)(PFUser *user, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
