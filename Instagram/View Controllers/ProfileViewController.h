//
//  ProfileViewController.h
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/5/21.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface ProfileViewController : UIViewController

@property (strong, nonatomic) PFUser *_Nonnull targetUser;

@end

