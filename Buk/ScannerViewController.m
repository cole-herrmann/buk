//
//  ScannerViewController.m
//  Buk
//
//  Created by Cole Herrmann on 11/12/14.
//  Copyright (c) 2014 Cole Herrmann. All rights reserved.
//

#import "ScannerViewController.h"
#import <POP/POP.h>


@interface ScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIView *scannerView;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) NSArray *barCodeTypes;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *editionLabel;
@property (weak, nonatomic) IBOutlet UILabel *isbnLabel;

@property (weak, nonatomic) IBOutlet UIView *resultsView;
@property (weak, nonatomic) IBOutlet UILabel *correctLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *xButton;
@property (weak, nonatomic) IBOutlet UILabel *tapToScanLabel;
@property (weak, nonatomic) IBOutlet UIButton *barcodeButton;

@end

@implementation ScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    UIColor *darkBlue = [UIColor colorWithRed:0.129 green:0.231 blue:0.325 alpha:1];
    UIColor *darkRed = [UIColor colorWithRed:0.969 green:0.192 blue:0.298 alpha:1];
    gradient.colors = [NSArray arrayWithObjects:(id)[darkBlue CGColor], (id)[darkRed CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    [self.resultsView setBackgroundColor:[UIColor clearColor]];
    self.resultsView.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.resultsView.layer.borderWidth = 2.0f;
    
    self.xButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.xButton.layer.borderWidth = 2.0f;
    self.xButton.layer.cornerRadius = 40.0f;

    self.checkButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.checkButton.layer.borderWidth = 2.0f;
    self.checkButton.layer.cornerRadius = 40.0f;

    self.checkButton.alpha = 0;
    self.xButton.alpha = 0;
    
    self.resultsView.layer.opacity = 0;
    self.correctLabel.layer.opacity = 0;
    
}
- (IBAction)barcodeTapped:(id)sender {
    POPBasicAnimation *shrinkDown = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    shrinkDown.toValue = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    shrinkDown.duration = 0.2;
    [shrinkDown setCompletionBlock:^(POPAnimation *animation, BOOL completed) {
        [self startScanningSession];
    }];
    [self.tapToScanLabel pop_addAnimation:shrinkDown forKey:@"shrinkDown"];
    [self.barcodeButton pop_addAnimation:shrinkDown forKey:@"shrinkDown"];

}

-(void)startScanningSession
{
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:captureMetadataOutput];
    
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.barCodeTypes = @[AVMetadataObjectTypeUPCECode,
                          AVMetadataObjectTypeCode39Code,
                          AVMetadataObjectTypeCode39Mod43Code,
                          AVMetadataObjectTypeEAN13Code,
                          AVMetadataObjectTypeEAN8Code,
                          AVMetadataObjectTypeCode93Code,
                          AVMetadataObjectTypeCode128Code,
                          AVMetadataObjectTypePDF417Code,
                          AVMetadataObjectTypeQRCode,
                          AVMetadataObjectTypeAztecCode];
    
    [captureMetadataOutput setMetadataObjectTypes:self.barCodeTypes];
    
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.scannerView.bounds];
    [self.scannerView.layer addSublayer:_videoPreviewLayer];
    
    [self.captureSession startRunning];

}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        
        for (AVMetadataObject *metadata in metadataObjects) {
            for (NSString *type in self.barCodeTypes) {
                if ([metadata.type isEqualToString:type])
                {

                    barCodeObject = (AVMetadataMachineReadableCodeObject *)[self.videoPreviewLayer transformedMetadataObjectForMetadataObject:
                                                                            (AVMetadataMachineReadableCodeObject *)metadata];
                    highlightViewRect = barCodeObject.bounds;
                    detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                    [self.captureSession stopRunning];
                    
                    self.titleLabel.text = @"Caclculs 2: Fundamentals";
                    self.authorLabel.text = @"Dr. Steve Brule";
                    self.editionLabel.text = @"4th Edition";
                    self.isbnLabel.text = detectionString;
                    [self animateScanPreviewAway];
                    [self animateResultsIn];
                    [self animateButtonsIn];

                }
            }
        }
        
    }
}

-(void)animateScanPreviewAway
{
    [self.scannerView.layer removeAnimationForKey:@"scanAnimation"];
    
    POPSpringAnimation *scanAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
    scanAnimation.toValue = @(-350);
    scanAnimation.velocity = @15;
    scanAnimation.springBounciness = 8;
    
    [self.scannerView.layer pop_addAnimation:scanAnimation forKey:@"scanAnimation"];
    
}

-(void)animateButtonsIn
{
    
    self.checkButton.alpha = 1;
    self.xButton.alpha = 1;
    
    POPBasicAnimation *fadeInAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    fadeInAnim.toValue = @1;
    [self.correctLabel.layer pop_addAnimation:fadeInAnim forKey:@"fadeIn"];
    
    POPSpringAnimation *moveCheckOut = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationX];
    moveCheckOut.toValue = @(340);
    moveCheckOut.velocity = @15;
    moveCheckOut.springBounciness = 8;
    [self.checkButton.layer pop_addAnimation:moveCheckOut forKey:@"moveCheckOut"];
    
    POPSpringAnimation *moveXOut = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationX];
    moveXOut.toValue = @(-340);
    moveXOut.velocity = @15;
    moveXOut.springBounciness = 8;
    [self.xButton.layer pop_addAnimation:moveXOut forKey:@"moveXOut"];
}

-(void)animateResultsIn
{
    [self.resultsView.layer removeAllAnimations];
    
    POPBasicAnimation *fadeInAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    fadeInAnim.toValue = @1;
    [self.resultsView.layer pop_addAnimation:fadeInAnim forKey:@"fadeIn"];
    
    POPBasicAnimation *shrinkDown = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    shrinkDown.toValue = [NSValue valueWithCGSize:CGSizeMake(.85, .85)];
    [self.resultsView pop_addAnimation:shrinkDown forKey:@"shrinkDown"];
    
    POPSpringAnimation *scaleUp = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleUp.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    scaleUp.springBounciness = 15;
    scaleUp.velocity = [NSValue valueWithCGSize:CGSizeMake(3, 3)];
    [self.resultsView pop_addAnimation:scaleUp forKey:@"scaleUp"];


    
}

@end
