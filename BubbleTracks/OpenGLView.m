//
//  OpenGLView.m
//  BubbleTracksBackgroundComponent
//
//  Created by Jules Testard on 23/09/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import "OpenGLView.h"

typedef struct {
    float Position[3];
    float Color[4];
} Vertex;

Vertex Vertices[] = {
    {{1, -1, 0}, {0.5, 0, 0, 1}},// Blue, Top Left
    {{1, 1, 0}, {0, 0.5, 0, 1}}, // Green, Top Right
    {{-1, 1, 0}, {0, 0, 0.5, 1}}, // Red, Bottom Right
    {{-1, -1, 0}, {0, 0, 0, 1}}, // Black, Bottom Left
    {{0, 0, 0}, {0, 0, 0, 1}} // Black, Middle
};

const GLubyte Indices[] = {
    0, 4, 1,
    1, 4, 2,
    2, 4, 3,
    3, 4, 0
};

float _sineCounters[] = {
    0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f,
    0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f
};

@implementation OpenGLView

- (id)initWithCoder:(NSCoder*)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        //Do something
    }
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    return [self initWithFrame:screenBounds];;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _renderCounter = 0.0L;
        [self setupLayer];
        [self setupContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self compileShaders];
        [self setupVBOs];
        [self setupDisplayLink];
    }
    return self;
}

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;
}

- (void)setupContext {
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupFrameBuffer {
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void)setupVBOs {
    
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_DYNAMIC_DRAW);
    
    GLuint indexBuffer;
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
}

- (void)render:(CADisplayLink*) displayLink {
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    if (_renderCounter%3==0) {
        Vertices[0].Color[0] = sinf(-_sineCounters[0])/8.0f + + 0.35f;
        Vertices[0].Color[1] = cosf(_sineCounters[1]+0.2f)/8.0f + 0.35f;
        Vertices[0].Color[2] = sinf(_sineCounters[2]-0.2f)/8.0f + 0.35f;
        Vertices[1].Color[0] = cosf(-_sineCounters[3])/8.0f + 0.35f;
        Vertices[1].Color[1] = sinf(_sineCounters[4]+0.3f)/8.0f + 0.35f;
        Vertices[1].Color[2] = cosf(_sineCounters[5]-0.3f)/8.0f + 0.35f;
        Vertices[2].Color[0] = cosf(_sineCounters[6])/8.0f + 0.35f;
        Vertices[2].Color[1] = sinf(-_sineCounters[7]+0.4f)/8.0f + 0.35f;
        Vertices[2].Color[2] = cosf(_sineCounters[8]-0.4f)/8.0f + 0.35f;
        Vertices[3].Color[0] = cosf(_sineCounters[9])/8.0f + 0.35f;
        Vertices[3].Color[1] = sinf(_sineCounters[10]+0.5f)/8.0f + 0.35f;
        Vertices[3].Color[2] = sinf(-_sineCounters[11]-0.5f)/8.0f + 0.35f;
        Vertices[4].Color[0] = cosf(-_sineCounters[12])/8.0f + 0.35f;
        Vertices[4].Color[1] = sinf(-_sineCounters[13]+0.5f)/8.0f + 0.35f;
        Vertices[4].Color[2] = sinf(-_sineCounters[14]-0.5f)/8.0f + 0.35f;
        for (int i = 0 ; i < 15; i++) {
            _sineCounters[i] += drand48()*0.1f;
        }
        GLuint vertexBuffer;
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_DYNAMIC_DRAW);
    }
    _renderCounter++;
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    // 2
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE,
                          sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE,
                          sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
    
    // 3
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]),
                   GL_UNSIGNED_BYTE, 0);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

// Add new method before init
- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

// Replace dealloc method with this
- (void)dealloc
{
    _context = nil;
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    // 1
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                           ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 2
    GLuint shaderHandle = glCreateShader(shaderType);
    
    // 3
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4
    glCompileShader(shaderHandle);
    
    // 5
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
    
}

- (void)compileShaders {
    
    // 1
    GLuint vertexShader = [self compileShader:@"SimpleVertex"
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment"
                                       withType:GL_FRAGMENT_SHADER];
    
    // 2
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    // 4
    glUseProgram(programHandle);
    
    // 5
    _positionSlot = glGetAttribLocation(programHandle, "Position");
    _colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
}
@end
