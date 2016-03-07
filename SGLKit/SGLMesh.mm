//
//  SGLMesh.mm
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import "SGLMesh.h"
#import "SGLShader.h"
#import "SGLProgram.h"
#import "SGLUtilities.h"
#import "SGLDebug.h"
#import "SGLHeader.h"

@interface SGLMesh ()

@property (nonatomic) GLuint glName;
@property (nonatomic) int vertexCount;
@property (nonatomic, strong) NSMutableArray* vertexBuffers;
@property (nonatomic, strong) SGLIndexBuffer* indexBuffer;

@end


@implementation SGLMesh

- (id) initWithMode:(MeshMode)mode
         vertexData:(GLfloat*)vertexData
   vertexAttributes:(NSArray*)attributes
        vertexCount:(size_t)vertexCount
          indexData:(GLushort*)indexData
         indexCount:(size_t)indexCount
{
    self = [super init];
    
    switch (mode)
    {
        case MeshMode_Triangles:
            _glMode = GL_TRIANGLES;
            break;
            
        case MeshMode_Lines:
            _glMode = GL_LINES;
            break;
            
        default:
            SGL_ASSERT(false);
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    glDisableVertexAttribArray(POSITIONS);
    glDisableVertexAttribArray(NORMALS);
    glDisableVertexAttribArray(RGBACOLORS);
    glDisableVertexAttribArray(TEXCOORDS);
    
    //NSLog(@"Disabling all vertex attrib arrays");
    
    #ifdef SGL_MAC
        glGenVertexArraysAPPLE(1, &_glName);
        glBindVertexArrayAPPLE(_glName);
        SGL_ASSERT(glIsVertexArrayAPPLE(_glName));
    #endif
    #ifdef SGL_IOS
        glGenVertexArraysOES(1, &_glName);
        glBindVertexArrayOES(_glName);
        SGL_ASSERT(glIsVertexArrayOES(_glName));
    #endif
    
    SGLVertexBuffer* vertexBuffer =
        [[SGLVertexBuffer alloc] initWithAttributes:attributes
                                               data:vertexData
                                          byteCount:vertexCount * attributes.count * 3 * sizeof(GLfloat)
                                        vertexCount:vertexCount];
    
    _hasNormals = vertexBuffer.hasNormals;
    _hasColors = vertexBuffer.hasColors;
    _hasTexCoords = vertexBuffer.hasTexCoords;
    
    self.vertexBuffers = [NSMutableArray arrayWithObject:vertexBuffer];
    
    if (indexData != nil)
        self.indexBuffer = [[SGLIndexBuffer alloc] initWithData:indexData
                                                      byteCount:indexCount * sizeof(GLushort)
                                                     indexCount:indexCount];
    
    // Bind back to the default state?
    // The apple docs recommend this, but other sources disagree.
    //glBindBuffer(GL_ARRAY_BUFFER, 0);
    //glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    #ifdef SGL_MAC
        glBindVertexArrayAPPLE(0);
    #endif
    #ifdef SGL_IOS
        glBindVertexArrayOES(0);
    #endif
    
    self.vertexCount = (int)vertexCount;
    
    return self;
}

/*
- (id) initWithPositions:(GLfloat*)positions
                 normals:(GLfloat*)normals
             vertexCount:(size_t)vertexCount
                 indices:(GLushort*)indices
              indexCount:(size_t)indexCount
{
    self = [super init];
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    //glDisableVertexAttribArray(POSITIONS);
    glDisableVertexAttribArray(NORMALS);
    glDisableVertexAttribArray(COLORS);
    glDisableVertexAttribArray(TEXCOORDS);
    glDisableVertexAttribArray(INDICES);
    
    //NSLog(@"Disabling all vertex attrib arrays");
    
    glGenVertexArraysOES(1, &_glName);
    glBindVertexArrayOES(_glName);
    
    self.vertexBuffers = [NSMutableArray array];
    
    GLVertexAttributeList attributes(1);
    
    if (positions != NULL)
    {
        attributes[0] = POSITIONS;
        [self.vertexBuffers addObject:
            [[GLVertexBuffer alloc] initWithAttributes:attributes
                                                  data:positions
                                             byteCount:vertexCount * 3 * sizeof(GLfloat)
                                           vertexCount:vertexCount]];
    }
    
    if (normals != NULL)
    {
        attributes[0] = NORMALS;
        [self.vertexBuffers addObject:
            [[GLVertexBuffer alloc] initWithAttributes:attributes
                                                  data:normals
                                             byteCount:vertexCount * 3 * sizeof(GLfloat)
                                           vertexCount:vertexCount]];
        
        _hasNormals = YES;
    }
    
    if (indices != NULL)
    {
        attributes[0] = INDICES;
        self.indexBuffer =
            [[GLIndexBuffer alloc] initWithData:indices
                                      byteCount:indexCount * sizeof(GLushort)
                                     indexCount:indexCount];
    }
    
    // Bind back to the default state?
    // The apple docs recommend this, but other sources disagree.
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
 
    glBindVertexArrayOES(0);
    
    self.vertexCount = vertexCount;
    
    return self;
}
*/

- (void) dealloc
{
    #ifdef SGL_MAC
        glDeleteVertexArraysAPPLE(1, &_glName);
    #endif
    #ifdef SGL_IOS
        glDeleteVertexArraysOES(1, &_glName);
    #endif
}

- (void) render
{
    // CJC: remove later?
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    // CJC: remove later?
    glDisableVertexAttribArray(POSITIONS);
    glDisableVertexAttribArray(NORMALS);
    glDisableVertexAttribArray(RGBACOLORS);
    glDisableVertexAttribArray(TEXCOORDS);
    
    #ifdef SGL_MAC
        SGL_ASSERT(glIsVertexArrayAPPLE(_glName));
        glBindVertexArrayAPPLE(_glName);
    #endif
    #ifdef SGL_IOS
        SGL_ASSERT(glIsVertexArrayOES(_glName));
        glBindVertexArrayOES(_glName);
    #endif
    
    SGLShader* shader = SGLShader.currentShader;
    
    BOOL shaderHasPositions = (shader.program.positionLoc != -1);
    BOOL shaderHasNormals   = (shader.program.normalLoc != -1);
    BOOL shaderHasColors    = (shader.program.colorLoc != -1);
    BOOL shaderHasTexCoords = (shader.program.texCoordLoc != -1);
    
    SGL_ASSERT(shaderHasPositions);
    SGL_ASSERT(_hasNormals == shaderHasNormals);
    SGL_ASSERT(_hasColors == shaderHasColors);
    SGL_ASSERT(_hasTexCoords == shaderHasTexCoords);
    SGL_ASSERT(!shaderHasNormals || shader.program.normalLoc == NORMALS);
    SGL_ASSERT(!shaderHasColors || shader.program.colorLoc == RGBACOLORS);
    SGL_ASSERT(!shaderHasTexCoords || shader.program.texCoordLoc == TEXCOORDS);
    
    if (_indexBuffer != nil)
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer.glName);
    
    #ifdef DEBUG
        [shader.program validate];
    #endif
    
    if (_indexBuffer != nil)
        glDrawElements(_glMode, GLsizei(_indexBuffer.indexCount), GL_UNSIGNED_SHORT, (const GLvoid*)0);
    else
        glDrawArrays(_glMode, 0, self.vertexCount);

    #ifdef SGL_MAC
        glBindVertexArrayAPPLE(0);
    #endif
    #ifdef SGL_IOS
        glBindVertexArrayOES(0);
    #endif
}

@end
