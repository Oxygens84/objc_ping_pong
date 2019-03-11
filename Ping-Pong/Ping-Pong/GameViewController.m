//
//  GameViewController
//  Ping-Pong
//
//  Created by Оксана Лобышева on 10/03/2019.
//  Copyright © 2019 Oxana Lobysheva. All rights reserved.
//

#import "GameViewController.h"

enum Position {
    TOP,
    BOTTOM
};
typedef enum Position Position;

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define HALF_SCREEN_WIDTH SCREEN_WIDTH/2
#define HALF_SCREEN_HEIGHT SCREEN_HEIGHT/2
#define MAX_SCORE 6
#define SCORE_SIZE 50
#define SCORE_OFFSET 70
#define PADDLE_OFFSET 40
#define PADDLE_HEIGHT 60
#define PADDLE_WIDTH  90
#define BALL_SIZE 20

@interface GameViewController ()

@property (strong, nonatomic) UIImageView *paddleTop;
@property (strong, nonatomic) UIImageView *paddleBottom;
@property (strong, nonatomic) UIView *gridView;
@property (strong, nonatomic) UIView *ball;
@property (strong, nonatomic) UITouch *topTouch;
@property (strong, nonatomic) UITouch *bottomTouch;
@property (strong, nonatomic) NSTimer * timer;
@property (nonatomic) float dx;
@property (nonatomic) float dy;
@property (nonatomic) float speed;
@property (strong, nonatomic) UILabel *scoreTop;
@property (strong, nonatomic) UILabel *scoreBottom;

@end

@implementation GameViewController


- (void)configUI {
    
    [self configPlayground];
    [self configBall];
    
    [self configPaddle: _paddleTop
            imageAsset: @"paddleTop"
              position: TOP];
 
    [self configPaddle: _paddleBottom
            imageAsset: @"paddleBottom"
              position: BOTTOM];
    
    [self configScore: _scoreTop
             position: TOP];
    
    [self configScore: _scoreBottom
             position: BOTTOM];

}

- (void)configPlayground {
    self.view.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:135.0/255.0 blue:191.0/255.0 alpha:1.0];
    _gridView = [[UIView alloc] initWithFrame:CGRectMake(0, HALF_SCREEN_HEIGHT - 2, SCREEN_WIDTH, 4)];
    _gridView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:_gridView];
}


- (void) configBall {
    _ball = [[UIView alloc]
             initWithFrame:CGRectMake(
                                      self.view.center.x - BALL_SIZE/2,
                                      self.view.center.y - BALL_SIZE/2,
                                      BALL_SIZE,
                                      BALL_SIZE)];
    _ball.backgroundColor = [UIColor whiteColor];
    _ball.layer.cornerRadius = BALL_SIZE/2;
    _ball.hidden = YES;
    [self.view addSubview:_ball];
}


- (void)configPaddle: (UIImageView*) imageView
          imageAsset: (NSString*) imageAsset
            position: (Position) position {
    double paddlePosition = 0;
    switch (position) {
        case TOP:
            paddlePosition = PADDLE_OFFSET;
            break;
        case BOTTOM:
            paddlePosition = SCREEN_HEIGHT - PADDLE_WIDTH;
            break;
    }
    imageView = [[UIImageView alloc]
                  initWithFrame:CGRectMake(
                                           PADDLE_OFFSET,
                                           paddlePosition,
                                           PADDLE_WIDTH,
                                           PADDLE_HEIGHT
                                           )];
    imageView.image = [UIImage imageNamed: imageAsset];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
}


- (void)configScore: (UILabel*) label
           position: (Position) position {
    double scorePosition = 0;
    switch (position) {
        case TOP:
            scorePosition = HALF_SCREEN_HEIGHT - SCORE_OFFSET;
            break;
        case BOTTOM:
            scorePosition = HALF_SCREEN_HEIGHT + SCORE_OFFSET - SCORE_SIZE;
            break;
    }
    
    label = [[UILabel alloc]
                 initWithFrame:CGRectMake(
                                          SCREEN_WIDTH - SCORE_OFFSET,
                                          scorePosition,
                                          SCORE_SIZE,
                                          SCORE_SIZE
                                          )];
    label.textColor = [UIColor whiteColor];
    label.text = @"0";
    label.font = [UIFont systemFontOfSize: 40.0 weight:UIFontWeightLight];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview: label];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}


@end
