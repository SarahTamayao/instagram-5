//
//  CustomCameraViewController.m
//  Instagram
//
//  Created by Rigre Reinier Garciandia Larquin on 7/9/21.
//

#import "CustomCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Utility.h"

@interface CustomCameraViewController () <AVCapturePhotoCaptureDelegate>
@property (strong, nonatomic) IBOutlet UIView *_Nonnull previewView;
@property (strong, nonatomic) IBOutlet UIImageView *_Nonnull captureImageView;
@property (strong, nonatomic) IBOutlet UIButton *_Nonnull takePhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *_Nonnull usePhotoButton;

@property (nonatomic, strong) AVCaptureSession *_Nonnull captureSession;
@property (nonatomic, strong) AVCapturePhotoOutput *_Nonnull stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *_Nonnull videoPreviewLayer;

@end

@implementation CustomCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleComponents];
}

- (void)styleComponents {
    
    //styling button
    self.takePhotoButton.layer.cornerRadius = 5;
    self.takePhotoButton.layer.masksToBounds = true;
    
    //styling image capture view
    self.captureImageView.layer.zPosition = 1;
    self.captureImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.captureImageView.layer.borderWidth = 1;
    self.captureImageView.layer.cornerRadius = 10.0f;
    self.captureImageView.alpha = 0;
    
    //hiding use photo button
    self.usePhotoButton.alpha = 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.captureSession stopRunning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.captureSession = [AVCaptureSession new];
    self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    
    AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!backCamera) {
        NSLog(@"Unable to access back camera!");
        return;
    }
    
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera
                                                                        error:&error];
    if (!error) {
        self.stillImageOutput = [AVCapturePhotoOutput new];
    }
    else {
        NSLog(@"Error Unable to initialize back camera: %@", error.localizedDescription);
        return;
    }
    
    self.stillImageOutput = [AVCapturePhotoOutput new];

    if ([self.captureSession canAddInput:input] && [self.captureSession canAddOutput:self.stillImageOutput]) {
        
        [self.captureSession addInput:input];
        [self.captureSession addOutput:self.stillImageOutput];
        [self setupLivePreview];
    }
}

- (void)setupLivePreview {
    
    self.videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    if (self.videoPreviewLayer) {
        
        self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        [self.previewView.layer addSublayer:self.videoPreviewLayer];
        
        //async start
        dispatch_queue_t globalQueue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(globalQueue, ^{
            [self.captureSession startRunning];
            
            //sizing the preview layer to fit the preview view
            dispatch_async(dispatch_get_main_queue(), ^{
                self.videoPreviewLayer.frame = self.previewView.bounds;
            });
        });
        
    }
}

- (IBAction)didTakePhoto:(UIButton *)sender {
    
    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey: AVVideoCodecTypeJPEG}];

     [self.stillImageOutput capturePhotoWithSettings:settings delegate:self];
}

- (IBAction)didTapUsePhoto:(UIButton *)sender {
    
    if (self.didFinishPickingMediaWithImage != nil) {
        self.didFinishPickingMediaWithImage(self.captureImageView.image);
        [self dismissViewControllerAnimated:YES completion:^{}];
    } else {
        NSLog(@"Nil didFinishPickingMediaWithImage property in CustomViewController");
    }
}

- (IBAction)didTapCancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//AVCapturePhotoCaptureDelegate delegate method
- (void)captureOutput:(AVCapturePhotoOutput *)output
didFinishProcessingPhoto:(AVCapturePhoto *)photo
                error:(nullable NSError *)error {
    
    NSData *imageData = photo.fileDataRepresentation;
    if (imageData) {
        UIImage *image = [UIImage imageWithData:imageData];
        image = [Utility resizeImage:image withSize:CGSizeMake(500, 500)];
        // Add the image to captureImageView here...
        self.captureImageView.image = image;
        [UIView animateWithDuration:.2 animations:^{
            self.captureImageView.alpha = 1;
            self.usePhotoButton.alpha = 1;
        }];
    }
}

@end
