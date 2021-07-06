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

#pragma  mark - Feed

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

- (void)createLike:(Post *)post completion:(void(^)(BOOL succeeded, BOOL likeExisted, NSError *error))completion {
    //make sure that like does not already exist (same user and post id)
    PFQuery *query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"postId" equalTo:post.objectId];
    [query whereKey:@"userId" equalTo:[PFUser currentUser]];

    [query findObjectsInBackgroundWithBlock:^(NSArray *matchingLikes, NSError *error) {
        if(matchingLikes == nil || matchingLikes.count == 0) {
            NSLog(@"Did not find like and so adding it");
            //saving the like
            PFObject *like = [[PFObject alloc] initWithClassName:@"Like"];
            like[@"userId"] = [PFUser currentUser];
            like[@"postId"] = post.objectId;
            
            [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if(error) {
                    completion(NO, NO, error);
                }
                else {
                    completion(YES, NO, nil);
                }
            }];
        }
        else {
            NSLog(@"Like already existed");
            completion(NO, YES, nil);
        }
    }];
}

- (void)deleteLike:(Post *)post completion:(void(^)(BOOL succeeded, NSError *error))completion {
    //getting the like object
    PFQuery *query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"postId" equalTo:post.objectId];
    [query whereKey:@"userId" equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *matchingLikes, NSError *error){
        if(!error){
            [PFObject deleteAllInBackground:matchingLikes block:^(BOOL succeeded, NSError *error){
                if(error){
                    completion(NO, error);
                }
                else {
                    completion(YES, nil);
                }
            }];
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
