//
//  MainMenuViewController.m
//  RTQuiz
//
//  Created by C. A. Beninati on 1/29/12.
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

#import "MainMenuViewController.h"

#import "GamePlayVC.h"
#import "HighScoresViewController.h"

@implementation MainMenuViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sharedDataManager = [SharedDataManager sharedDataManager];
    }
    return self;
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)didClickQuickplay {

    // set up game controller
    sharedGamePlayController = [GamePlayController sharedGamePlayController];
    [sharedGamePlayController newGame];

    // set up game data
    [sharedGamePlayController setCurrentTopic:@"spanish-1"];
    [sharedGamePlayController setCurrentTopicLevelsList:[sharedDataManager getArrayFromTopic:sharedGamePlayController.currentTopic]];
    
    // set up game view
    GamePlayVC *gamePlayVC = [[GamePlayVC alloc] initWithNibName:@"GamePlayVC" bundle:nil];
    [self addChildViewController:gamePlayVC];
    [self.view addSubview:gamePlayVC.view];
    
    [sharedGamePlayController setCurrentGameScene:gamePlayVC];
    [sharedGamePlayController startGame];
    
}

- (IBAction)didClickHighScores {
    
    HighScoresViewController *highScoresVC = [[HighScoresViewController alloc] initWithNibName:@"HighScoresViewController" bundle:nil category:@"spanish-1"];
    [self addChildViewController:highScoresVC];
    [self.view addSubview:highScoresVC.view];
    
}

@end
