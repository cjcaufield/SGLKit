//
//  Mat4.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2017 Secret Geometry. All rights reserved.
//

#ifndef SGL_MAT4_H
#define SGL_MAT4_H

//
// Mat4
//

typedef struct mat4
{
    float elements[16];
    
    #ifdef __cplusplus
        
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
        
        float* pointerToElements()
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
            std::fill(elements, elements + 16, value);
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
            result.at(2, 1) = cosp * axis.y * axis.z - axis.x * sin;
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
        
    #endif
    
} mat4;

#endif
