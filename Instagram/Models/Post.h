//
//  Post.h
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/5/21.
//

#import <Parse/Parse.h>

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, assign) BOOL isLikedByCurrentUser;

+ (void) postUserImage:(UIImage * _Nullable)image withCaption:(NSString * _Nullable)caption withCompletion:(PFBooleanResultBlock  _Nullable)completion;
+ (PFFileObject *_Nullable)getPFFileFromImage:(UIImage * _Nullable)image;

@end
