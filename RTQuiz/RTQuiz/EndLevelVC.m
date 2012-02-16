//
//  EndLevelVC.m
//  RTQuiz
//
//  Created by C. A. Beninati on 4/13/11.
//  Copyright (c) 2012 C. A. Beninati. All rights reserved.
//
//	This file is part of RTQuiz.
//
//	RTQuiz is free software: you can redistribute it and/or modify
//	it under the terms of the GNU Lesser Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//
//	RTQuiz is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU Lesser Public License for more details.
//
//	You should have received a copy of the GNU Lesser Public License
//	along with RTQuiz.  If not, see <http://www.gnu.org/licenses/>.
//

#import "EndLevelVC.h"

@implementation EndLevelVC
@synthesize delegate;
@synthesize totalPointsLabel;
@synthesize mainMenuButton;

@synthesize score = _score;
@synthesize category = _category;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sharedDataManager = [SharedDataManager sharedDataManager];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL didSave = [sharedDataManager didSaveScore:_score ForCategoryNamed:_category ForUserNamed:[textField text]];
    
    [textField resignFirstResponder];
    
    [delegate returnToMainMenu];
    return didSave;   
}

- (void)setScoreLabel:(int)theScore {
    
    [self.totalPointsLabel setText:[NSString stringWithFormat:@"%i", theScore]];
    
}

- (void)dealloc
{
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTotalPointsLabel:nil];
    [self setMainMenuButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)didClickMainMenu {
    [delegate returnToMainMenu];
}

@end
