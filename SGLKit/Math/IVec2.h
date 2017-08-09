//
//  IVec2.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2014 Secret Geometry. All rights reserved.
//

#ifndef SGL_IVEC2_H
#define SGL_IVEC2_H

#import "SGLMath.h"

//
// IVec2
//

typedef struct ivec2
{
    int x, y;
    
    #ifdef __cplusplus
    
        // Constructors.
        
        ivec2() {}
        
        ivec2(int i, int j) : x(i), y(j) {}
        
        explicit ivec2(int i) : x(i), y(i) {}
        
        explicit ivec2(const vec2& v);
    
        ivec2(CGPoint point) : x(point.x), y(point.y) {}
    
        ivec2(CGSize size) : x(size.width), y(size.height) {}
    
        CGPoint toPoint()
        {
            return CGPointMake(x, y);
        }
    
        CGSize toSize()
        {
            return CGSizeMake(x, y);
        }
    
        int& at(int i)
        {
            switch (i)
            {
                case 0:  return x;
                case 1:  return y;
                    
                default:
                    SGL_ASSERT(false);
                    return x;
            }
        }
        
        float aspect()
        {
            return float(x) / float(y);
        }
        
        // Arithmetic operators.
        
        ivec2 operator+(const ivec2& v) const
        {
            return ivec2(x + v.x, y + v.y);
        }
        
        ivec2 operator-(const ivec2& v) const
        {
            return ivec2(x - v.x, y - v.y);
        }
        
        ivec2 operator*(int s) const
        {
            return ivec2(x * s, y * s);
        }
        
        ivec2 operator*(const ivec2& v) const
        {
            return ivec2(x * v.x, y * v.y);
        }
        
        ivec2 operator/(int s) const
        {
            return ivec2(x / s, y / s);
        }
        
        ivec2 operator/(const ivec2& v) const
        {
            return ivec2(x / v.x, y / v.y);
        }
        
        // Arithmetic operators.
        
        ivec2& operator+=(const ivec2& v)
        {
            x += v.x;
            y += v.y;
            return *this;
        }
        
        ivec2& operator-=(const ivec2& v)
        {
            x -= v.x;
            y -= v.y;
            return *this;
        }
        
        ivec2& operator*=(int s)
        {
            x *= s;
            y *= s;
            return *this;
        }
        
        ivec2& operator/=(int s)
        {
            x /= s;
            y /= s;
            return *this;
        }
        
        // Equality operators.
        
        bool operator==(const ivec2& v) const
        {
            return x == v.x && y == v.y;
        }
        
        bool operator!=(const ivec2& v) const
        {
            return x != v.x || y != v.y;
        }
    
    #endif

} ivec2;

typedef ivec2 IntPair;
typedef ivec2 IntPoint;
typedef ivec2 IntSize;

#endif
