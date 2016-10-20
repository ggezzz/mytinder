//
//  MoveableImageView.m
//  AssemblyDoll
//
//  Created by khong fong tze on 18/08/2016.
//  Copyright © 2016 NextAcademy. All rights reserved.
//

#import "MoveableImageView.h"

@implementation MoveableImageView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]){
        //by default, user interaction for imageview is disbaled
        self.userInteractionEnabled=YES;
        
        //selector means a method, usually
        //dragging gesture (with more than 1 figure)
        UIPanGestureRecognizer *panRecog = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        UIPinchGestureRecognizer *pinRecog = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePin:)];
        UIRotationGestureRecognizer *rotateRecog = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleRotate:)];
        
        //it can have multiple recognizers --> added into the array;
        self.gestureRecognizers = @[panRecog,pinRecog,rotateRecog];
        
        
        for (UIGestureRecognizer *reg in self.gestureRecognizers){
            reg.delegate = self;  //to handle simutaneous gestures
            //everytime before it move, the imageview itself will check shouldRecognizeSimultaneouslyWithGestureRecognizer
        }
        
        return self;
    } else {
        return nil;
    }
}

- (BOOL) gestureRecognizer: (UIGestureRecognizer *) gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void) handleRotate: (UIRotationGestureRecognizer *) gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan
        || gestureRecognizer.state==UIGestureRecognizerStateChanged){
        
        //get the scale factor how many times of the current size
        //0.5=half of the current size, 2=2x of the current size
        CGFloat angle = gestureRecognizer.rotation;
        
        
        //telling the view, transform the image  by the angle value (radian)
        [gestureRecognizer.view setTransform:CGAffineTransformRotate(gestureRecognizer.view.transform, angle)];
        
        //reset rotation (angle) to 1
        [gestureRecognizer setRotation:1];
    }
}



- (void) handlePin: (UIPinchGestureRecognizer *) gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan
        || gestureRecognizer.state==UIGestureRecognizerStateChanged){
        
        //get the scale factor how many times of the current size
        //0.5=half of the current size, 2=2x of the current size
        CGFloat scale = gestureRecognizer.scale;
        
        
        //telling the view, transform the image  (x,y)
        [gestureRecognizer.view setTransform:CGAffineTransformScale(gestureRecognizer.view.transform, scale, scale)];
        
        //reset scale to 1
         [gestureRecognizer setScale:1];
    }
}

- (void) handlePan: (UIPanGestureRecognizer *) gestureRecognizer{
    
    /*
     translationInView provides the change in coordinates that the view has moved within the view it is contained in. That is given in the form of a CGPoint.
     
     If you drag it to the left, it might provide the coordinates:
     
     (-20.0, 0)
     
     locationInView provides the location of the view in the form of a CGPoint.
     
     If you drag it to the left and print the locationInView throughout the gesture, you will see a slur of logs with changing coordinates with the final one being its current resting place.
     
     To move a UIView with the touch's location, you would want to set the frame property of the UIView to the gesture's locationInView in the gesture's delegate method.
     */
    NSLog(@"%f",[gestureRecognizer translationInView:self].x);
    //NSLog(@"%f",[gestureRecognizer locationInView:self].x);
    
    //move the image
    //[self setCenter:[gestureRecognizer translationInView:self]];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan
        || gestureRecognizer.state==UIGestureRecognizerStateChanged){
        
        //find movement since origin position (x and y)
        //x y coordinates relative to origin coordinates of attached view (0,0)
        CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
        
        
        //telling the view, transform x y coordinates according to translation variable
        [gestureRecognizer.view setTransform:CGAffineTransformTranslate(gestureRecognizer.view.transform, translation.x, translation.y)];
        
        //reset x y position of gesture recognizer to the 0.0 position of the current view
        [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
    }
    
}

@end
