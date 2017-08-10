//
//  Vec2.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2017 Secret Geometry. All rights reserved.
//

#ifndef SGL_VEC2_H
#define SGL_VEC2_H

#import "SGLMath.h"

//
// Vec2
//

typedef struct vec2
{
    float x, y;
    
    #ifdef __cplusplus
        
        // Constructors.
        
        vec2() {}
        
        vec2(float i) : x(i), y(i) {}
        
        vec2(float i, float j) : x(i), y(j) {}
        
        vec2(ivec2 v) : x(v.x), y(v.y) {}
    
        vec2(CGPoint point) : x(point.x), y(point.y) {}
    
        vec2(CGSize size) : x(size.width), y(size.height) {}
        
        explicit vec2(const vec3& v);
        
        explicit vec2(const vec4& v);
    
        CGPoint toPoint() { return CGPointMake(x, y); }
    
        CGSize toSize() { return CGSizeMake(x, y); }
    
        float& at(int i)
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
        
        float aspect() const
        {
            return x / y;
        }
        
        // Arithmetic operators.
        
        vec2& operator+=(const vec2& v)
        {
            x += v.x;
            y += v.y;
            return *this;
        }
        
        vec2& operator-=(const vec2& v)
        {
            x -= v.x;
            y -= v.y;
            return *this;
        }
        
        vec2& operator*=(const vec2& v)
        {
            x *= v.x;
            y *= v.y;
            return *this;
        }
        
        vec2& operator/=(const vec2& v)
        {
            x /= v.x;
            y /= v.y;
            return *this;
        }
        
        // Equality operators.
        
        bool operator==(const vec2& v) const
        {
            return x == v.x && y == v.y;
        }
        
        bool operator!=(const vec2& v) const
        {
            return x != v.x || y != v.y;
        }
        
        // Length functions.
        
        float length() const
        {
            return distance(*this, ORIGIN_2D);
        }
        
        vec2& normalize()
        {
            float len = length();
            
            if (len > 0.0f)
                *this /= length();
            
            return *this;
        }
        
    #endif
    
} vec2;

#ifdef __cplusplus

    inline vec2 operator+(const vec2& a, const vec2& b)
    {
        return vec2(a) += b;
    }

    inline vec2 operator-(const vec2& a, const vec2& b)
    {
        return vec2(a) -= b;
    }

    inline vec2 operator*(const vec2& a, const vec2& b)
    {
        return vec2(a) *= b;
    }

    inline vec2 operator/(const vec2& a, const vec2& b)
    {
        return vec2(a) /= b;
    }

    inline vec2 floor(const vec2& v)
    {
        return vec2(floorf(v.x), floorf(v.y));
    }

    inline vec2 ceil(const vec2& v)
    {
        return vec2(ceilf(v.x), ceilf(v.y));
    }

    inline vec2 randomVec2()
    {
        return vec2(randomFloat(), randomFloat());
    }

    inline vec2 randomVec2InRange(float lo, float hi)
    {
        return vec2(randomFloatInRange(lo, hi), randomFloatInRange(lo, hi));
    }

    inline float minComponent(const vec2& v)
    {
        return min(v.x, v.y);
    }

    inline float maxComponent(const vec2& v)
    {
        return max(v.x, v.y);
    }

    inline float dot(const vec2& a, const vec2& b)
    {
        return a.x * b.x + a.y * b.y;
    }

#endif

#endif
