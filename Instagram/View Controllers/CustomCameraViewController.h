//
//  CustomCameraViewController.h
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/9/21.
//

#import <UIKit/UIKit.h>

@interface CustomCameraViewController : UIViewController

@property (nonatomic, copy) void (^didFinishPickingMediaWithImage)(UIImage *image);

@end

