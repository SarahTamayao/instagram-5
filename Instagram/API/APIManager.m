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

- (void)getPostAuthor:(Post *)post completion:(void(^)(PFUser *user, NSError *error))completion {
    PFUser *user = post[@"author"];
    NSString *userId = user.objectId;
    
    //construct query
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    
    [query getObjectInBackgroundWithId:@"ImynwQNg3z" block:^(PFObject *user, NSError *error) {
        if (!error) {
            // Success!
            completion(user, nil);
        } else {
            // Failure!
            completion(nil, error);
        }
    }];
}

#pragma mark - User Authentication
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

- (void)logout:(void(^)(NSError *error))completion {
    [PFUser logOutInBackgroundWithBlock:^(NSError *error) {
        // PFUser.current() will now be nil
        completion(error);
    }];
}

@end
