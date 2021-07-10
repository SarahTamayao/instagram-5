//
//  APIManager.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/4/21.
//

#import "Utility.h"

@implementation Utility


+ (UIImage *)resizeImage:(UIImage *)image
                withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma  mark - Feed
+ (void)createLike:(Post *)post
        completion:(void(^)(BOOL succeeded, BOOL likeExisted, NSError *error))completion {
    //make sure that like does not already exist (same user and post id)
    PFQuery *query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"postId" equalTo:post.objectId];
    [query whereKey:@"userId" equalTo:[PFUser currentUser]];

    [query findObjectsInBackgroundWithBlock:^(NSArray *matchingLikes, NSError *error) {
        if (matchingLikes == nil || matchingLikes.count == 0) {
            NSLog(@"Did not find like and so adding it");
            //saving the like
            PFObject *like = [[PFObject alloc] initWithClassName:@"Like"];
            like[@"userId"] = [PFUser currentUser];
            like[@"postId"] = post.objectId;
            
            [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if (error) {
                    completion(NO, NO, error);
                } else {
                    completion(YES, NO, nil);
                }
            }];
        } else {
            NSLog(@"Like already existed");
            completion(NO, YES, nil);
        }
    }];
}

+ (void)deleteLike:(Post *)post
        completion:(void(^)(BOOL succeeded, NSError *error))completion {
    //getting the like object
    PFQuery *query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"postId" equalTo:post.objectId];
    [query whereKey:@"userId" equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *matchingLikes, NSError *error){
        if (!error){
            [PFObject deleteAllInBackground:matchingLikes block:^(BOOL succeeded, NSError *error){
                if (error){
                    completion(NO, error);
                } else {
                    completion(YES, nil);
                }
            }];
        }
    }];

}

#pragma mark - User Authentication
+ (void)registerUser:(NSString *)username
            password:(NSString *)password
          completion:(void(^)(BOOL succeeded, NSError *error))completion{
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

+ (void)loginUser:(NSString *)username
         password:(NSString *)password
       completion:(void(^)(PFUser *user, NSError *error))completion {
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (error != nil) {
            completion(nil, error);
        } else {
            completion(user, nil);
        }
    }];
}

+ (void)logout:(void(^)(NSError *error))completion {
    [PFUser logOutInBackgroundWithBlock:^(NSError *error) {
        // PFUser.current() will now be nil
        completion(error);
    }];
}

@end
