//
//  ViewController.m
//  Buk
//
//  Created by Cole Herrmann on 10/23/14.
//  Copyright (c) 2014 Cole Herrmann. All rights reserved.
//

#import "ViewController.h"
#import "TextFieldCell.h"
#import <POP/POP.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *bukLabel;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UITextField *firstResponderTextField;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic, assign) BOOL isInSignInMode;

@end

@implementation ViewController
{
    int initialSignInY;
    int initialBukY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    self.tableView.layer.opacity = 0.0f;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    UIColor *darkBlue = [UIColor colorWithRed:0.129 green:0.231 blue:0.325 alpha:1];
    UIColor *darkRed = [UIColor colorWithRed:0.969 green:0.192 blue:0.298 alpha:1];
    gradient.colors = [NSArray arrayWithObjects:(id)[darkBlue CGColor], (id)[darkRed CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    self.tableView.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.tableView.layer.borderWidth = 1.0f;
    
    self.signInButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.signInButton.layer.borderWidth = 1.0f;

    self.signUpButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.signUpButton.layer.borderWidth = 1.0f;
    
    self.closeButton.layer.opacity = 0.0f;
   
    initialBukY = self.bukLabel.frame.origin.y;
    initialSignInY = self.signInButton.frame.origin.y;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (IBAction)cancelTapped:(id)sender {
    if(self.isInSignInMode){
        self.isInSignInMode = NO;
        [self startAnimations:YES];
    }
}

- (IBAction)signInTapped:(id)sender {
    [self startAnimations:NO];
}

-(void)startAnimations:(BOOL)shouldReverse
{
    if(!self.isInSignInMode){
        [self animateBookLabel:shouldReverse];
        if(shouldReverse)
            [self fadeInTableViewAnimation:shouldReverse];
        
        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        positionAnimation.toValue = (shouldReverse) ? @(self.signUpButton.frame.origin.y - self.signInButton.frame.size.height/2 - 10) : @(CGRectGetMaxY(self.tableView.frame) + 34);
        positionAnimation.velocity = @5;
        positionAnimation.springBounciness = 14;
        [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
            if(!shouldReverse)
                [self fadeInTableViewAnimation: shouldReverse];
            self.isInSignInMode = (shouldReverse) ? NO : YES;
        }];
        [self.signInButton.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    }
}

-(void)animateBookLabel:(BOOL)shouldReverse
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = (shouldReverse) ? @(initialBukY) : @(self.bukLabel.frame.origin.y - 34);
    positionAnimation.velocity = @5;
    positionAnimation.springBounciness = 14;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
    }];
    [self.bukLabel.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];

}

-(void)fadeInTableViewAnimation:(BOOL)shouldReverse
{
    if(shouldReverse)
        [self.view endEditing:YES];
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = (shouldReverse) ? @(0) : @(1);
    [opacityAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        if(!shouldReverse)
            [self.firstResponderTextField becomeFirstResponder];
    }];
    
    [self.tableView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    [self.closeButton.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
    if(cell == nil)
        cell = [[TextFieldCell alloc]init];

    if(indexPath.row == 0){
        cell.cellTextField.placeholder = @"email";
        cell.cellTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"email" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        self.firstResponderTextField = cell.cellTextField;
    }else if(indexPath.row == 1){
        cell.cellTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    }
    
    
    return cell;
}

@end
