//
//  Vec4.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2014 Secret Geometry. All rights reserved.
//

#ifndef SGL_VEC4_H
#define SGL_VEC4_H

#import "SGLMath.h"

//
// Vec4
//

typedef struct vec4
{
    float x, y, z, w;
    
    #ifdef __cplusplus
        
        // Constructors.
        
        vec4() {}
        
        vec4(float i) : x(i), y(i), z(i), w(i) {}
        
        vec4(float i, float j, float k, float l) : x(i), y(j), z(k), w(l) {}
        
        vec4(vec3 v, float l) : x(v.x), y(v.y), z(v.z), w(l) {}
        
        float& at(int i)
        {
            switch (i)
            {
                case 0:  return x;
                case 1:  return y;
                case 2:  return z;
                case 3:  return w;
                    
                default:
                    SGL_ASSERT(false);
                    return x;
            }
        }
        
        // Arithmetic operators.
        
        vec4 operator+(const vec4& v) const
        {
            return vec4(x + v.x, y + v.y, z + v.z, w + v.w);
        }
        
        vec4 operator-(const vec4& v) const
        {
            return vec4(x - v.x, y - v.y, z - v.z, w - v.w);
        }
        
        vec4 operator*(float s) const
        {
            return vec4(x * s, y * s, z * s, w * s);
        }
        
        vec4 operator*(const vec4& v) const
        {
            return vec4(x * v.x, y * v.y, z * v.z, w * v.w);
        }
        
        vec4 operator/(float s) const
        {
            return vec4(x / s, y / s, z / s, w / s);
        }
        
        vec4 operator/(const vec4& v) const
        {
            return vec4(x * v.x, y * v.y, z * v.z, w * v.w);
        }
        
        // Arithmetic operators.
        
        vec4& operator+=(const vec4& v)
        {
            x += v.x;
            y += v.y;
            z += v.z;
            w += v.w;
            return *this;
        }
        
        vec4& operator-=(const vec4& v)
        {
            x -= v.x;
            y -= v.y;
            z -= v.z;
            w -= v.w;
            return *this;
        }
        
        vec4& operator*=(float s)
        {
            x *= s;
            y *= s;
            z *= s;
            w *= s;
            return *this;
        }
        
        vec4& operator/=(float s)
        {
            x /= s;
            y /= s;
            z /= s;
            w /= s;
            return *this;
        }
        
        // Equality operators.
        
        bool operator==(const vec4& v) const
        {
            return x == v.x && y == v.y && z == v.z && w == v.w;
        }
        
        bool operator!=(const vec4& v) const
        {
            return x != v.x || y != v.y || z != v.z || w != v.w;
        }
        
        // Member functions.
        
        float length() const
        {
            return distance(*this, ORIGIN_4D);
        }
        
        vec4& normalize()
        {
            float len = length();
            
            if (len > 0.0)
                *this /= length();
            
            return *this;
        }
        
    #endif
    
} vec4;

#ifdef __cplusplus

    inline vec4 randomVec4()
    {
        return vec4(randomFloat(), randomFloat(), randomFloat(), randomFloat());
    }

    inline vec4 randomVec4InRange(float lo, float hi)
    {
        return vec4(randomFloatInRange(lo, hi),
                    randomFloatInRange(lo, hi),
                    randomFloatInRange(lo, hi),
                    randomFloatInRange(lo, hi));
    }

    inline float maxComponent(const vec4& v)
    {
        return max(max(max(v.x, v.y), v.z), v.w);
    }

    inline float minComponent(const vec4& v)
    {
        return min(min(min(v.x, v.y), v.z), v.w);
    }

    inline float dot(const vec4& a, const vec4& b)
    {
        return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
    }

#endif

#endif
