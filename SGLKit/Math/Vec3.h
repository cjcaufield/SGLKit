//
//  Vec3.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2014 Secret Geometry. All rights reserved.
//

#ifndef SGL_VEC3_H
#define SGL_VEC3_H

#import "SGLMath.h"

//
// Vec3
//

typedef struct vec3
{
    float x, y, z;
    
    #ifdef __cplusplus
    
        // Constructors.
        
        vec3() {}
        
        vec3(float i) : x(i), y(i), z(i) {}
        
        vec3(float i, float j, float k) : x(i), y(j), z(k) {}
        
        vec3(vec2 v, float k) : x(v.x), y(v.y), z(k) {}
        
        explicit vec3(const vec4& v);
    
        vec3(NSArray* array)
        {
            x = [array[0] floatValue];
            y = [array[1] floatValue];
            z = [array[2] floatValue];
        }
    
        vec3(XXColor* color);
    
        NSArray* toArray(vec3 v)
        {
            id nx = @(v.x);
            id ny = @(v.y);
            id nz = @(v.z);
            
            return @[nx, ny, nz, @1.0f];
        }
    
        XXColor* toColor(vec3 v)
        {
            return [XXColor colorWithRed:v.x green:v.y blue:v.z alpha:1.0];
        }
    
        float& at(int i)
        {
            switch (i)
            {
                case 0:  return x;
                case 1:  return y;
                case 2:  return z;
                    
                default:
                    SGL_ASSERT(false);
                    return x;
            }
        }
        
        // Arithmetic operators.
        
        vec3& operator+=(const vec3& v)
        {
            x += v.x;
            y += v.y;
            z += v.z;
            return *this;
        }
        
        vec3& operator-=(const vec3& v)
        {
            x -= v.x;
            y -= v.y;
            z -= v.z;
            return *this;
        }
        
        vec3& operator*=(const vec3& v)
        {
            x *= v.x;
            y *= v.y;
            z *= v.z;
            return *this;
        }
        
        vec3& operator/=(const vec3& v)
        {
            x /= v.x;
            y /= v.y;
            z /= v.z;
            return *this;
        }
        
        // Equality operators.
        
        bool operator==(const vec3& v) const
        {
            return x == v.x && y == v.y && z == v.z;
        }
        
        bool operator!=(const vec3& v) const
        {
            return x != v.x || y != v.y || z != v.z;
        }
        
        // Member functions.
        
        float length() const
        {
            return distance(*this, ORIGIN_3D);
        }
        
        vec3& normalize()
        {
            float len = length();
            
            if (len > 0.0f)
                *this /= length();
            
            return *this;
        }
        
    #endif
    
} vec3;

#ifdef __cplusplus

    inline vec3 operator+(const vec3& a, const vec3& b)
    {
        return vec3(a) += b;
    }

    inline vec3 operator-(const vec3& a, const vec3& b)
    {
        return vec3(a) -= b;
    }

    inline vec3 operator*(const vec3& a, const vec3& b)
    {
        return vec3(a) *= b;
    }

    inline vec3 operator/(const vec3& a, const vec3& b)
    {
        return vec3(a) /= b;
    }

    inline vec3 randomVec3()
    {
        return vec3(randomFloat(), randomFloat(), randomFloat());
    }

    inline vec3 randomVec3InRange(float lo, float hi)
    {
        return vec3(randomFloatInRange(lo, hi), randomFloatInRange(lo, hi), randomFloatInRange(lo, hi));
    }

    inline float maxComponent(const vec3& v)
    {
        return max(max(v.x, v.y), v.z);
    }

    inline float minComponent(const vec3& v)
    {
        return min(min(v.x, v.y), v.z);
    }

    inline float dot(const vec3& a, const vec3& b)
    {
        return a.x * b.x + a.y * b.y + a.z * b.z;
    }

    inline vec3 cross(vec3 a, vec3 b)
    {
        float x = a.y * b.z - a.z * b.y;
        float y = a.z * b.x - a.x * b.z;
        float z = a.x * b.y - a.y * b.x;
        return vec3(x, y, z);
    }

#endif

#endif
