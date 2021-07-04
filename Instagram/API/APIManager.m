//
//  APIManager.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/4/21.
//

#import "APIManager.h"

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)registerUser:(NSString *)username password:(NSString *)password completion:(void(^)(BOOL succeeded, NSError *error))completion{
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = username;
    newUser.password = password;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            completion(NO, error);
        } else {
            completion(YES, nil);
        }
    }];
}

- (void)loginUser:(NSString *)username password:(NSString *)password completion:(void(^)(PFUser *user, NSError *error))completion {
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (error != nil) {
            completion(nil, error);
        } else {
            completion(user, nil);
        }
    }];
}

@end
