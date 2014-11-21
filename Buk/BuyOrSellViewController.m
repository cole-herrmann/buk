//
//  BuyOrSellViewController.m
//  Buk
//
//  Created by Cole Herrmann on 11/2/14.
//  Copyright (c) 2014 Cole Herrmann. All rights reserved.
//

#import "BuyOrSellViewController.h"

@interface BuyOrSellViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sellButton;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@end

@implementation BuyOrSellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.sellButton setBackgroundColor:[UIColor clearColor]];
    self.sellButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.sellButton.layer.borderWidth = 2.0f;
    
//    [self.buyButton setBackgroundColor:[UIColor clearColor]];
    self.buyButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.buyButton.layer.borderWidth = 2.0f;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    UIColor *darkBlue = [UIColor colorWithRed:0.129 green:0.231 blue:0.325 alpha:1];
    UIColor *darkRed = [UIColor colorWithRed:0.969 green:0.192 blue:0.298 alpha:1];
    gradient.colors = [NSArray arrayWithObjects:(id)[darkBlue CGColor], (id)[darkRed CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    
}
- (IBAction)buyOrSellPressed:(id)sender {
    
    if(sender == self.buyButton){
        NSLog(@"buy");
    }else{
        NSLog(@"sell");
    }
}

@end
