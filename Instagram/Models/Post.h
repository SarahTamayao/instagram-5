//
//  Post.h
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/5/21.
//

#import <Parse/Parse.h>

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *_Nonnull postID;
@property (nonatomic, strong) NSString *_Nonnull userID;
@property (nonatomic, strong) PFUser *_Nonnull author;
@property (nonatomic, strong) NSString *_Nonnull caption;
@property (nonatomic, strong) PFFileObject *_Nonnull image;
@property (nonatomic, strong) NSNumber *_Nonnull likeCount;
@property (nonatomic, strong) NSNumber *_Nonnull commentCount;
@property (nonatomic, assign) BOOL isLikedByCurrentUser;

+ (void) postUserImage:(UIImage * _Nullable)image withCaption:(NSString * _Nullable)caption withCompletion:(PFBooleanResultBlock  _Nullable)completion;
+ (PFFileObject *_Nullable)getPFFileFromImage:(UIImage * _Nullable)image;

@end
