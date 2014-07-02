//
//  SGLMath.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2014 Secret Geometry. All rights reserved.
//

#ifndef SGL_MATH_H
#define SGL_MATH_H

#import "SGLDebug.h"
#include <cmath>
#include <algorithm>
//#include <glm/glm.hpp>

class vec2;
class vec3;
class vec4;
class sphere;
class ray;
class aabb;
class tri;
class quad;
class plane;
class mat3;
class mat4;

static const float FLOAT_EPSILON = 0.00001f;

extern vec2 ORIGIN_2D;
extern vec3 ORIGIN_3D;
extern vec4 ORIGIN_4D;

extern vec3 BLACK;
extern vec3 RED;
extern vec3 GREEN;
extern vec3 BLUE;
extern vec3 CYAN;
extern vec3 MAGENTA;
extern vec3 YELLOW;
extern vec3 WHITE;

extern vec4 TRANSPARENT_BLACK;
extern vec4 OPAQUE_BLACK;

#define PI         3.1415926535897931
#define HALF_PI    1.5707963267948966
#define QUARTER_PI 0.7853981633974483

inline float randomFloat()
{
    return float(rand()) / float(RAND_MAX);
}

inline float randomFloatInRange(float lo, float hi)
{
    return lo + randomFloat() * (hi - lo);
}

inline float radians(float d)
{
    return d * PI / 180.0f;
}

inline float degrees(float r)
{
    return r * 180.0f / PI;
}

template <typename T>
T min(const T& a, const T& b)
{
    return (a < b) ? a : b;
}

template <typename T>
T max(const T& a, const T& b)
{
    return (a > b) ? a : b;
}

template <typename T>
T mix(const T& a, const T& b, float offset)
{
    return a + (b - a) * offset;
}

template <typename T>
float length(const T& v)
{
    return v.length();
}

template <typename T>
float distance(const T& a, const T& b)
{
    return sqrtf(distancesqrd(a, b));
}

template <typename T>
float distancesqrd(const T& a, const T& b)
{
    T diff = a - b;
    return dot(diff, diff);
}

template <typename T>
float magnitude(const T& v)
{
    return sqrtf(magnitudesqrd(v));
}

template <typename T>
float magnitudesqrd(const T& v)
{
    return dot(v, v);
}

template <typename T>
T normalize(const T& v)
{
    float len = v.length();
    
    T scaledVector = v;
    
    if (len > 0.0f)
        scaledVector /= len;
    
    return scaledVector;
}


class ivec2
{
public:
    
    // Constructors.
    
    ivec2() {}
    
    ivec2(int i, int j) : x(i), y(j) {}
    
    explicit ivec2(int i) : x(i), y(i) {}
    
    explicit ivec2(const vec2& v);
    
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
    
    int x, y;
};

typedef ivec2 IntPair;
typedef ivec2 IntPoint;
typedef ivec2 IntSize;


class vec2
{
public:
    
    // Constructors.

    vec2() {}
    
    vec2(float i) : x(i), y(i) {}
    
    vec2(float i, float j) : x(i), y(j) {}
    
    vec2(ivec2 v) : x(v.x), y(v.y) {}
    
    explicit vec2(const vec3& v);
    
    explicit vec2(const vec4& v);
    
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
    
    //Arithmetic operators.
    
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
    
    // Member variables.
    
    float x, y;
};

// 

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

/*
inline vec2 sqrt(const vec2& v)
{
    return vec2(float(sqrt(v.x)), float(sqrt(v.y)));
}

inline vec2 pow(const vec2& v, float exp)
{
    return vec2(float(pow(v.x, exp)), float(pow(v.y, exp)));
}
*/


class vec3
{
public:
    
    // Constructors.
    
    vec3() {}
    
    vec3(float i) : x(i), y(i), z(i) {}
    
    vec3(float i, float j, float k) : x(i), y(j), z(k) {}
    
    vec3(vec2 v, float k) : x(v.x), y(v.y), z(k) {}
    
    vec3(float i, vec2 v) : x(i), y(v.x), z(v.y) {}
    
    explicit vec3(const vec4& v);
    
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
    
    // Member variables.
    
    float x, y, z;
};

// 

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


class vec4
{
public:
    
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
    
    // Member variables.
    
    float x, y, z, w;
};

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


class sphere
{
public:
    
    sphere() {}
    
    sphere(vec3 p, float r) : center(p), radius(r) {}
    
    float circumference() const
    {
        return 2.0f * PI * radius;
    }

    bool contains(vec3 point) const
    {
        return distancesqrd(center, point) <= radius * radius;
    }
    
    vec3 convertSphereCoordsToCartesian(vec2 coords) const
    {
        // Find the point on the sphere when it's at the origin.
        vec2 angles = convertSphereCoordsToEuler(coords);
        
        // Calculate the point.
        float r = +radius;
        float x = -sin(angles.y) * r;
        float y = +sin(angles.x) * r;
        float z = -sqrt(r * r - x * x - y * y);
        
        // Move the point back into the sphere's space.
        return vec3(x, y, z) + center;
    }
    
    vec2 convertSphereCoordsToEuler(vec2 coords) const
    {
        return vec2(-coords.x / radius, +coords.y / radius);
    }
    
    vec3 center;
    float radius;
};


class ray
{
public:
    
    ray() {}
    
    ray(vec3 from, vec3 to)
	:
		origin(from),
		target(to)
	{}
	
	ray& operator+=(const vec3& v)
    {
        origin += v;
		target += v;
        return *this;
    }
	
	ray& operator-=(const vec3& v)
    {
        origin -= v;
		target -= v;
        return *this;
    }
	
	ray& operator*=(const vec3& v)
    {
        origin *= v;
		target *= v;
        return *this;
    }
	
	ray& operator/=(const vec3& v)
    {
        origin /= v;
		target /= v;
        return *this;
    }
    
    vec3 direction()
    {
        return normalize(target - origin);
    }
    
    vec3 origin;
    vec3 target;
};


class aabb
{
public:
    
    aabb() {}
    
    aabb(vec3 low, vec3 high) : lo(low), hi(high) {}
    
    bool contains(vec3 p)
    {
        return lo.x <= p.x && p.x <= hi.x &&
               lo.y <= p.y && p.y <= hi.y &&
               lo.z <= p.z && p.z <= hi.z;
    }
    
    float width()  {return hi.x - lo.x;}
    float height() {return hi.y - lo.y;}
    float depth()  {return hi.z - lo.z;}
    
    vec3 lo;
    vec3 hi;
};


class tri
{
public:
    
    tri() {}
    
    tri(vec3 d, vec3 e, vec3 f) : a(d), b(e), c(f) {}
    
    vec3 normal()
    {
        vec3 u = b - a;
        vec3 v = c - a;
        return cross(u, v).normalize(); // CJC note: is the normalize necessary?
    }
    
    vec3 a;
    vec3 b;
    vec3 c;
};


class quad
{
public:
    
    quad() {}
    
    quad(vec3 bl, vec3 br, vec3 tr, vec3 tl) : bottomLeft(bl), bottomRight(br), topRight(tr), topLeft(tl) {}
    
    vec3 normal()
    {
        vec3 u = bottomRight - bottomLeft;
        vec3 v = topRight - bottomLeft;
        return normalize(cross(u, v)); // CJC note: is the normalize necessary?
    }
    
    aabb boundingBox()
    {
        aabb box;
        
        box.lo.x = min(min(bottomLeft.x, bottomRight.x), min(topRight.x, topLeft.x));
        box.lo.y = min(min(bottomLeft.y, bottomRight.y), min(topRight.y, topLeft.y));
        box.lo.z = min(min(bottomLeft.z, bottomRight.z), min(topRight.z, topLeft.z));
        
        box.hi.x = max(max(bottomLeft.x, bottomRight.x), max(topRight.x, topLeft.x));
        box.hi.y = max(max(bottomLeft.y, bottomRight.y), max(topRight.y, topLeft.y));
        box.hi.z = max(max(bottomLeft.z, bottomRight.z), max(topRight.z, topLeft.z));
        
        return box;
    }
    
    vec3 bottomLeft;
    vec3 bottomRight;
    vec3 topRight;
    vec3 topLeft;
};


class plane
{
public:
    
    plane() {}
    
    plane(vec3 point, vec3 normal);
    
    vec3 point;
    vec3 normal;
};

inline float distance(const plane& p, vec3 v)
{
    return dot(v - p.point, p.normal);
}

inline float infront(const plane& p, vec3 v)
{
    return distance(p, v) > 0.0f;
}


class mat3
{
public:
    
    mat3() {}
    
    mat3(float f) { fill(f); }
    
    mat3(float* f) { fill(f); }
    
    explicit mat3(const mat4& m);
    
    float* array()
    {
        return elements;
    }
    
    float& at(int row, int col)
    {
        return elements[row * 3 + col];
    }
    
    const float& at(int row, int col) const
    {
        return elements[row * 3 + col];
    }
    
    vec3 row(int row) const
    {
        float x = at(row, 0);
        float y = at(row, 1);
        float z = at(row, 2);
        
        return vec3(x, y, z);
    }
    
    void setRow(int row, vec3 v)
    {
        at(row, 0) = v.x;
        at(row, 1) = v.y;
        at(row, 2) = v.z;
    }
    
    bool operator==(const mat3& v) const
    {
        for (int i = 0; i < 3; i++)
            for (int j = 0; j < 3; j++)
                if (at(i, j) != v.at(i, j))
                    return false;
        
        return true;
    }
    
    bool isAffine() const
    {
        return at(0, 2) == 0.0f && at(1, 2) == 0.0f && at(2, 2) == 0.0f;
    }
    
    mat3 transpose() const
    {
        mat3 result;
        
        for (int i = 0; i < 3; i++)
            for (int j = 0; j < 3; j++)
                result.at(i, j) = at(j, i);
        
        return result;
    }
    
    mat3 inverse() const
    {
        float S00 = at(0,0);
		float S01 = at(0,1);
		float S02 = at(0,2);
		float S10 = at(1,0);
		float S11 = at(1,1);
		float S12 = at(1,2);
		float S20 = at(2,0);
		float S21 = at(2,1);
		float S22 = at(2,2);

		mat3 result;
        result.at(0,0) = S11 * S22 - S21 * S12;
        result.at(0,1) = S12 * S20 - S22 * S10;
        result.at(0,2) = S10 * S21 - S20 * S11;
        result.at(1,0) = S02 * S21 - S01 * S22;
        result.at(1,1) = S00 * S22 - S02 * S20;
        result.at(1,2) = S01 * S20 - S00 * S21;
        result.at(2,0) = S12 * S01 - S11 * S02;
        result.at(2,1) = S10 * S02 - S12 * S00;
        result.at(2,2) = S11 * S00 - S10 * S01;
        
		float determinant =
            S00 * (S11 * S22 - S21 * S12) -
            S10 * (S01 * S22 - S21 * S02) +
            S20 * (S01 * S12 - S11 * S02);
        
		result /= determinant;
		
        return result;
    }
    
    vec3 operator*(vec3 v) const
    {
        vec3 result = vec3(0.0f);
        vec3 result2 = vec3(0.0f);
        
        //glm::vec3 vv(v.x, v.y, v.z);
        //glm::mat3 mm;
        
        for (int i = 0; i < 3; i++)
            for (int c = 0; c < 3; c++)
                result.at(i) += at(c, i) * v.at(c);
        
        for (int r = 0; r < 3; r++)
            for (int c = 0; c < 3; c++)
                result2.at(r) += at(r, c) * v.at(c);
        
        //SGL_ASSERT(result == result2);
                
        return result;
    }
    
    mat3 operator*(const mat3& m) const
    {
        mat3 result = mat3(0.0f);
        mat3 result2 = mat3(0.0f);
        
        for (int i = 0; i < 3; i++)
            for (int j = 0; j < 3; j++)
                for (int c = 0; c < 3; c++)
                    result.at(i, j) += at(c, j) * m.at(i, c);
        
        for (int r = 0; r < 3; r++)
            for (int c = 0; c < 3; c++)
                for (int i = 0; i < 3; i++)
                    result2.at(r, c) += at(r, i) * m.at(i, c);
        
        //SGL_ASSERT(result == result2);
        
        return result;
    }
    
    /*
    mat3& operator*=(const mat3& m)
    {
        mat3 old = *this;
        *this = old * m;
        return *this;
    }
    */
    
    mat3& operator*=(float value)
    {
        for (int i = 0; i < 9; i++)
            elements[i] *= value;
        
        return *this;
    }
    
    mat3& operator/=(float value)
    {
        for (int i = 0; i < 9; i++)
            elements[i] /= value;
        
        return *this;
    }
    
    void fill(float value)
    {
        std::fill(elements, elements + 9, value);
        
        //memset(elements, value, 9 * sizeof(float));
    }
    
    void fill(float* values)
    {
        fill(values, 9);
    }
    
    void fill(float* values, int count)
    {
        memcpy(elements, values, count * sizeof(float));
    }
    
    void reset()
    {
        fill(0.0f);
        
        for (int c = 0; c < 3; c++)
            at(c, c) = 1.0f;
    }
    
    static mat3 identity()
    {
        mat3 im;
        im.reset();
        return im;
    }
    
    static mat3 rotationX(float radians)
    {
        float s = sin(radians);
        float c = cos(radians);
        
        mat3 xrm;
        xrm.reset();
        
        xrm.at(1, 1) = +c;
        xrm.at(1, 2) = -s;
        xrm.at(2, 1) = +s;
        xrm.at(2, 2) = +c;
        
        return xrm;
    }
    
    static mat3 rotationY(float radians)
    {
        float s = sin(radians);
        float c = cos(radians);
        
        mat3 yrm;
        yrm.reset();
        
        yrm.at(0, 0) = +c;
        yrm.at(0, 2) = +s;
        yrm.at(2, 0) = -s;
        yrm.at(2, 2) = +c;
        
        return yrm;
    }
    
    static mat3 rotationZ(float radians)
    {
        float s = sin(radians);
        float c = cos(radians);
        
        mat3 zrm;
        zrm.reset();
        
        zrm.at(0, 0) = +c;
        zrm.at(0, 1) = -s;
        zrm.at(1, 0) = +s;
        zrm.at(1, 1) = +c;
        
        return zrm;
    }
    
    static mat3 rotationYX(float yradians, float xradians)
    {
        float siny = sin(yradians);
        float cosy = cos(yradians);
        float sinx = sin(xradians);
        float cosx = cos(xradians);
        
        mat3 yrm;
        yrm.reset();
        yrm.at(0, 0) = +cosy;
        yrm.at(0, 2) = +siny;
        yrm.at(2, 0) = -siny;
        yrm.at(2, 2) = +cosy;
        
        mat3 xrm;
        xrm.reset();
        xrm.at(1, 1) = +cosx;
        xrm.at(1, 2) = -sinx;
        xrm.at(2, 1) = +sinx;
        xrm.at(2, 2) = +cosx;
        
        return yrm * xrm;
    }
    
    static mat3 scale(vec3 scale)
    {
        mat3 sm;
        sm.reset();
        
        sm.at(0, 0) = scale.x;
        sm.at(1, 1) = scale.y;
        sm.at(2, 2) = scale.z;
        
        return sm;
    }
    
    float elements[9];
};


class mat4
{
  public:
    
    mat4() {}
    
    mat4(float f) { fill(f); }
    
    mat4(float* f) { fill(f); }
    
    mat4(const mat3& m)
    {
        setRow(0, vec4(m.row(0), 0.0));
        setRow(1, vec4(m.row(1), 0.0));
        setRow(2, vec4(m.row(2), 0.0));
        
        setRow(3, vec4(0.0, 0.0, 0.0, 1.0));
    }
    
    float* array()
    {
        return elements;
    }
    
    float& at(int row, int col)
    {
        return elements[row * 4 + col];
    }
    
    const float& at(int row, int col) const
    {
        return elements[row * 4 + col];
    }
    
    vec4 row(int row) const
    {
        float x = at(row, 0);
        float y = at(row, 1);
        float z = at(row, 2);
        float w = at(row, 3);
        
        return vec4(x, y, z, w);
    }
    
    void setRow(int row, vec4 v)
    {
        at(row, 0) = v.x;
        at(row, 1) = v.y;
        at(row, 2) = v.z;
        at(row, 3) = v.w;
    }
    
    bool operator==(const mat4& v) const
    {
        for (int i = 0; i < 4; i++)
            for (int j = 0; j < 4; j++)
                if (at(i, j) != v.at(i, j))
                    return false;
        
        return true;
    }
    
    bool isAffine() const
    {
        return at(0, 3) == 0.0f &&
               at(1, 3) == 0.0f &&
               at(2, 3) == 0.0f &&
               at(3, 3) == 1.0f;
    }
    
    vec3 position() const
    {
        return vec3(at(3,0), at(3,1), at(3,2));
    }
    
    mat4 transpose() const
    {
        mat4 result;
        
        for (int i = 0; i < 4; i++)
            for (int j = 0; j < 4; j++)
                result.at(i, j) = at(j, i);
        
        return result;
    }
    
    vec3 operator*(vec3 v) const
    {
        vec4 v4 = vec4(v.x, v.y, v.z, 1.0f);
        vec3 result = vec3(0.0f);
        vec3 result2 = vec3(0.0f);
        
        for (int i = 0; i < 3; i++)
            for (int c = 0; c < 4; c++)
                result.at(i) += at(c, i) * v4.at(c);
        
        for (int r = 0; r < 3; r++)
            for (int c = 0; c < 4; c++)
                result2.at(r) += at(r, c) * v4.at(c);
        
        return result;
    }
    
    mat4 operator*(const mat4& m) const
    {
        mat4 result = mat4(0.0f);
        mat4 result2 = mat4(0.0f);
        
        for (int i = 0; i < 4; i++)
            for (int j = 0; j < 4; j++)
                for (int c = 0; c < 4; c++)
                    result.at(i, j) += at(c, j) * m.at(i, c);
        
        for (int r = 0; r < 4; r++)
            for (int c = 0; c < 4; c++)
                for (int i = 0; i < 4; i++)
                    result2.at(r, c) += at(r, i) * m.at(i, c);
        
        return result;
    }
    
    /*
    mat4& operator*=(const mat4& m)
    {
        mat4 old = *this;
        *this = old * m;
        return *this;
    }
    */
    
    mat4& operator*=(float value)
    {
        for (int i = 0; i < 16; i++)
            elements[i] *= value;
        
        return *this;
    }
    
    mat4& operator/=(float value)
    {
        for (int i = 0; i < 16; i++)
            elements[i] /= value;
        
        return *this;
    }
    
    void fill(float value)
    {
        std::fill(elements, elements + 16, 0.0f);
        
        //memset(elements, value, 16 * sizeof(float));
    }
    
    void fill(float* values)
    {
        fill(values, 16);
    }
    
    void fill(float* values, int count)
    {
        memcpy(elements, values, count * sizeof(float));
    }
    
    void reset()
    {
        fill(0.0f);
        
        for (int c = 0; c < 4; c++)
            at(c, c) = 1.0f;
    }
    
    static mat4 identity()
    {
        mat4 im;
        im.reset();
        return im;
    }
    
    static mat4 translation(vec3 v)
    {
        mat4 tm;
        tm.reset();
        
        tm.at(3, 0) = v.x;
        tm.at(3, 1) = v.y;
        tm.at(3, 2) = v.z;
        
        //tm.at(0, 3) = v.x;
        //tm.at(1, 3) = v.y;
        //tm.at(2, 3) = v.z;
        
        return tm;
    }
    
    static mat4 rotationYX(float yrot, float xrot)
    {
        float siny = sin(yrot);
        float cosy = cos(yrot);
        float sinx = sin(xrot);
        float cosx = cos(xrot);
        
        mat4 yrm;
        yrm.reset();
        yrm.at(0, 0) = +cosy;
        yrm.at(2, 0) = -siny;
        yrm.at(0, 2) = +siny;
        yrm.at(2, 2) = +cosy;
        
        mat4 xrm;
        xrm.reset();
        xrm.at(1, 1) = +cosx;
        xrm.at(2, 1) = +sinx;
        xrm.at(1, 2) = -sinx;
        xrm.at(2, 2) = +cosx;
        
        return yrm * xrm;
    }
    
    static mat4 rotation(float radians, vec3 axis)
    {
        float cos = cosf(radians);
        float sin = sinf(radians);
        float cosp = 1.0f - cos;
        
        axis.normalize();
        
        mat4 result;
        result.reset();
        
        result.at(0, 0) = cos + cosp * axis.x * axis.x;
        result.at(1, 1) = cos + cosp * axis.y * axis.y;
        result.at(2, 2) = cos + cosp * axis.z * axis.z;
        
        result.at(0, 1) = cosp * axis.x * axis.y + axis.z * sin;
        result.at(1, 0) = cosp * axis.x * axis.y - axis.z * sin;
        result.at(1, 2) = cosp * axis.y * axis.z + axis.x * sin;
        result.at(2, 1) = cosp * axis.y * axis.z - axis.x * sin,
        result.at(0, 2) = cosp * axis.x * axis.z - axis.y * sin;
        result.at(2, 0) = cosp * axis.x * axis.z + axis.y * sin;
        
        return result;
    }
    
    static mat4 scale(vec3 scale)
    {
        mat4 sm;
        sm.reset();
        
        sm.at(0, 0) = scale.x;
        sm.at(1, 1) = scale.y;
        sm.at(2, 2) = scale.z;
        
        return sm;
    }
    
    static mat4 ortho(float left, float right, float bottom, float top, float near, float far)
    {
        mat4 result;
        result.reset();
        
        result.at(0, 0) = +2.0 / (right - left);
        result.at(1, 1) = +2.0 / (top - bottom);
        result.at(2, 2) = -2.0 / (far - near);
        
        result.at(3, 0) = -1.0 * (right + left) / (right - left);
        result.at(3, 1) = -1.0 * (top + bottom) / (top - bottom);
        result.at(3, 2) = -1.0 * (far + near) / (far - near);
        
        return result;
    }
    
    static mat4 projection(float fovy, float aspect, float nearZ, float farZ)
    {
        float cotan = 1.0f / tanf(fovy / 2.0f);
        
        mat4 result;
        result.reset();
        
        result.at(0, 0) = cotan / aspect;
        result.at(1, 1) = cotan;
        result.at(2, 2) = (farZ + nearZ) / (nearZ - farZ);
        result.at(2, 3) = -1.0f;
        result.at(3, 2) = (2.0f * farZ * nearZ) / (nearZ - farZ);
        result.at(3, 3) = 0.0f;
        
        return result;
    }
    
    static mat4 offsetProjection(float left, float right, float bottom, float top, float near, float far)
    {
        mat4 result;
        result.reset();
        
        result.at(0, 0) = 2.0 * near / (right - left);
        result.at(1, 1) = 2.0 * near / (top - bottom);
        result.at(2, 0) = (right + left) / (right - left);
        result.at(2, 1) = (top + bottom) / (top - bottom);
        result.at(2, 2) = -1.0 * (far + near) / (far - near);
        result.at(2, 3) = -1.0;
        result.at(3, 2) = -2.0 * far * near / (far - near);
        result.at(3, 3) = 0.0;
        
        return result;
    }
    
    float elements[16];
};


inline ivec2::ivec2(const vec2& v) : x(v.x), y(v.y) {}

inline vec2::vec2(const vec3& v) : x(v.x), y(v.y) {}

inline vec2::vec2(const vec4& v) : x(v.x), y(v.y) {}

inline vec3::vec3(const vec4& v) : x(v.x), y(v.y), z(v.z) {}

inline mat3::mat3(const mat4& m)
{
    for (int i = 0; i < 3; i++)
        for (int j = 0; j < 3; j++)
            at(i, j) = m.at(i, j);
}


bool intersect(ray& r, sphere& s, float sphereAspect, vec3* intersectPos);

bool intersect(const ray& r, const tri& t);

bool intersect(const ray& r, const quad& q);

#endif
