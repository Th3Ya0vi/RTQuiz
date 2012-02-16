//
//  GamePlayVC.m
//  RTQuiz
//
//  Created by C. A. Beninati on 3/17/11.
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

#import "GamePlayVC.h"
#import "GamePlayController.h"

#import "QuizElement.h"

#import "EndStageVC.h"
#import "EndLevelVC.h"

@implementation GamePlayVC
@synthesize warningView;

@synthesize currentPointsLabel, currentWordLabel, timeRemainingLabel;
@synthesize firstWordButton     = _firstWordButton;
@synthesize secondWordButton    = _secondWordButton;
@synthesize thirdWordButton     = _thirdWordButton;
@synthesize fourthWordButton    = _fourthWordButton;

@synthesize thePointsAlertView;
@synthesize theEndLevelAlertView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    sharedGamePlayController = [GamePlayController sharedGamePlayController];
    [super viewDidLoad];
}

#pragma mark -
#pragma mark GamePlayDelegate Methods
#pragma mark

- (void)timerWasUpdated:(int)updatedTime {
    [timeRemainingLabel setText:[NSString stringWithFormat:@"%i", ((int)updatedTime)/(100)]];
}
- (void)pointsWereAdded:(int)totalPoints {
    [self updatePointsLabelWithPoints:totalPoints];
    [self notifyAnswerWasCorrect:YES];
}
- (void)pointsWereLost:(int)totalPoints {
    [self updatePointsLabelWithPoints:totalPoints];
    [self notifyAnswerWasCorrect:NO];
}

- (void)newWord:(NSString *)quizWord withChoices:(NSArray *)choicesArray {
	[_firstWordButton	setTitle:[choicesArray objectAtIndex:0]	forState: UIControlStateNormal];
	[_secondWordButton	setTitle:[choicesArray objectAtIndex:1]	forState: UIControlStateNormal];
	[_thirdWordButton	setTitle:[choicesArray objectAtIndex:2]	forState: UIControlStateNormal];
	[_fourthWordButton	setTitle:[choicesArray objectAtIndex:3]	forState: UIControlStateNormal];
	
	[currentWordLabel setText:quizWord];    
}

- (void)endLevel:(int)level points:(int)points bonusPoints:(int)bonusPoints {
    EndStageVC *endStageVC = [[EndStageVC alloc] initWithNibName:@"EndStageVC" bundle:[NSBundle mainBundle]];
    [self addChildViewController:endStageVC];
    [self.view addSubview:endStageVC.view];
    [endStageVC setDelegate:self];
    [endStageVC setLabelsForStage:level withPoints:points withBonus:bonusPoints];
    [endStageVC.view setAlpha:0];    
    
    [UIView animateWithDuration:.35 animations:^(void) {
        [endStageVC.view setAlpha:1.0f];
    }];	
}
- (void)endGameWithPoints:(int)points topic:(NSString *)topic { 
    EndLevelVC *endLevelVC = [[EndLevelVC alloc] initWithNibName:@"EndLevelVC" bundle:[NSBundle mainBundle]];
    [self addChildViewController:endLevelVC];
    [self.view addSubview:endLevelVC.view];
    [endLevelVC setDelegate:self];
    [endLevelVC setScore:points];
    [endLevelVC setCategory:topic];
    [endLevelVC.totalPointsLabel setText:[NSString stringWithFormat:@"%i", points]];
    [endLevelVC.view setAlpha:0];
    
    [UIView animateWithDuration:.35 animations:^(void) {
        [endLevelVC.view setAlpha:1.0f];
    }];
}

- (void)returnToMainMenu {
    [sharedGamePlayController resetGame];
    [self.view removeFromSuperview];    
}

#pragma mark -
#pragma mark Winning Conditions
#pragma mark

- (void)updatePointsLabelWithPoints:(int)points {
	[currentPointsLabel setText:[NSString stringWithFormat:@"%i", points]];
}

-(void)notifyAnswerWasCorrect:(BOOL)answer {
	
	if (answer == TRUE) {
		UIImageView *pointsAlertView = [[UIImageView alloc] initWithFrame:CGRectMake(240, 40, 48, 48)];
		[pointsAlertView setImage:[UIImage imageNamed:@"Correct.png"]];
		[self.view addSubview:pointsAlertView];
        
        [UIView animateWithDuration:.55 animations:^(void) {
            [pointsAlertView setFrame:CGRectOffset(pointsAlertView.frame, 20, -30)];
            [pointsAlertView setAlpha:0];
        }];
	}else {
        [warningView setAlpha:1.0f];
 		UIImageView *pointsAlertView = [[UIImageView alloc] initWithFrame:CGRectMake(240, 40, 48, 48)];
		[pointsAlertView setImage:[UIImage imageNamed:@"Wrong.png"]];
		[self.view addSubview:pointsAlertView];
        
        [UIView animateWithDuration:.55 animations:^(void) {
            [pointsAlertView setFrame:CGRectOffset(pointsAlertView.frame, 20, -30)];
            [pointsAlertView setAlpha:0];
            [warningView setAlpha:0.0f];
        }];
    }
	
}

#pragma mark -
#pragma mark Interactions
#pragma mark

- (IBAction) didClickWordButtonWithID:(id)sender {
    [sharedGamePlayController checkWordForTag:[sender tag]];
}
- (IBAction)didClickReturnToMainMenu {
    [self returnToMainMenu];
}

#pragma mark -
#pragma mark Maintenance
#pragma mark

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self removeFromParentViewController];
    [self setWarningView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
}


@end
