//
//  OpenGLView.h
//  BubbleTracksBackgroundComponent
//
//  Created by Jules Testard on 23/09/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

@interface OpenGLView : UIView {
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    GLuint _positionSlot;
    GLuint _colorSlot;
    unsigned long _renderCounter;
    GLuint _modelViewUniform;
    float _currentRotation;
}

@end