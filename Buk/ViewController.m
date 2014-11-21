//
//  ViewController.m
//  Buk
//
//  Created by Cole Herrmann on 10/23/14.
//  Copyright (c) 2014 Cole Herrmann. All rights reserved.
//

#import "ViewController.h"
#import "TextFieldCell.h"
#import "BuyOrSellViewController.h"
#import <POP/POP.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (nonatomic, strong) UITextField *firstResponderTextField;
@property (nonatomic, assign) BOOL isInSignInMode;
@property (nonatomic, assign) BOOL isInSignUpMode;
@property (weak, nonatomic) IBOutlet UIImageView *bukView;
@property (weak, nonatomic) IBOutlet UIView *signInView;

@property (weak, nonatomic) IBOutlet UITextField *signInEmail;
@property (weak, nonatomic) IBOutlet UITextField *signInPassword;

@end

@implementation ViewController
{
    int initialSignInY;
    int initialBukY;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.signInButton.layer.cornerRadius = 15.0f;

    self.signUpButton.layer.cornerRadius = 15.0f;
    
    self.signInView.layer.opacity = 0;
    
    //
////    initialBukY = self.bukLabel.frame.origin.y;
//    initialSignInY = self.signInButton.frame.origin.y;
}


- (IBAction)cancelTapped:(id)sender {
    if(self.isInSignInMode){
        self.isInSignInMode = NO;
        [self startAnimations:YES];
    }
    
    if(self.isInSignUpMode){
        self.isInSignUpMode = NO;
        [self startAnimationsSignUp:YES];
    }
}

- (IBAction)signInTapped:(id)sender {
//    if(self.isInSignInMode){
//        NSString * storyboardName = @"Main";
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"BuyOrSellVC"];
//        [self.navigationController showViewController:vc sender:self];
//    }else{
        [self startAnimations:NO];
//    }
}
- (IBAction)signUpTapped:(id)sender {
//    if(self.isInSignUpMode){
//        NSString * storyboardName = @"Main";
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"BuyOrSellVC"];
//        [self.navigationController showViewController:vc sender:self];
//    }else{
        [self startAnimationsSignUp:NO];
//    }
}

//animations for signin

-(void)startAnimations:(BOOL)shouldReverse
{
    NSString *signInAnim = @"signInAnim";
    
    [self.signInButton.layer removeAnimationForKey:signInAnim];

    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
    
    positionAnimation.toValue = (shouldReverse) ? @0 : @-180;
    positionAnimation.velocity = @5;
    positionAnimation.springBounciness = 10;
   
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        if(!shouldReverse)
            [self fadeInTableViewAnimation: shouldReverse isSignUp:NO];
        
        self.isInSignInMode = (shouldReverse) ? NO : YES;
    }];
    
    [self animateBookLabel:shouldReverse];
    [self.signInButton.layer pop_addAnimation:positionAnimation forKey:signInAnim];

}

//-(void)startAnimations:(BOOL)shouldReverse
//{
//    if(!self.isInSignInMode){
//        [self animateBookLabel:shouldReverse];
//        
//        if(shouldReverse)
//            [self fadeInTableViewAnimation:shouldReverse isSignUp:NO];
//        
//        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
//        
//        positionAnimation.toValue = (shouldReverse) ? @0 : @-180;
//        positionAnimation.velocity = @5;
//        positionAnimation.springBounciness = 10;
//        
//        [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
//            if(!shouldReverse)
//                [self fadeInTableViewAnimation: shouldReverse isSignUp:NO];
//            self.isInSignInMode = (shouldReverse) ? NO : YES;
//        }];
//        
//        [self.signInButton.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
//    }
//}

-(void)animateBookLabel:(BOOL)shouldReverse
{
    NSString *bukAnim = @"bukAnim";
    
    [self.signInButton.layer removeAnimationForKey:bukAnim];
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
    
    positionAnimation.toValue = (shouldReverse) ? @0 : @-60;
    positionAnimation.velocity = @5;
    positionAnimation.springBounciness = 10;
    
    [self.bukView.layer pop_addAnimation:positionAnimation forKey:bukAnim];
}

-(void)fadeInTableViewAnimation:(BOOL)shouldReverse isSignUp:(BOOL) isSignUp
{
    if(shouldReverse)
        [self.view endEditing:YES];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    
    opacityAnimation.toValue = (shouldReverse) ? @(0) : @(1);
    
    [opacityAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        if(!shouldReverse)
            [self.signInEmail becomeFirstResponder];
    }];
    
    if(isSignUp){
//        [self.createAcctTableView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    }else{
        [self.signInView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    }
    
   }

//animations for signup

-(void)startAnimationsSignUp:(BOOL)shouldReverse
{
    if(!self.isInSignUpMode){
        [self animateBookLabel:shouldReverse];
        
        if(shouldReverse)
            [self fadeInTableViewAnimation:shouldReverse isSignUp:YES];
        
        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        
//        positionAnimation.toValue = (shouldReverse) ? @(CGRectGetMaxY(self.signInButton.frame) + 34)
//                                                    : @(CGRectGetMaxY(self.createAcctTableView.frame) + 34);
        
        positionAnimation.velocity = @5;
        positionAnimation.springBounciness = 10;
        
        [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
           
            if(!shouldReverse)
                [self fadeInTableViewAnimation: shouldReverse isSignUp:YES];
            
            self.isInSignUpMode = (shouldReverse) ? NO : YES;
            
        }];
        
        [self.signUpButton.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
        [self fadeOutOrInSignInButton:shouldReverse];
    }
}

-(void)fadeOutOrInSignInButton:(BOOL)fadeIn
{
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = (fadeIn) ? @(1) : @(0);
    
    [self.signInButton.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}


@end
