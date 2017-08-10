//
//  Mat3.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2017 Secret Geometry. All rights reserved.
//

#ifndef SGL_MAT3_H
#define SGL_MAT3_H

#import "SGLMath.h"

//
// Mat3
//

typedef struct mat3
{
    float elements[9];
    
    #ifdef __cplusplus
        
        mat3() {}
        
        mat3(float f) { fill(f); }
        
        mat3(float* f) { fill(f); }
        
        explicit mat3(const mat4& m);
        
        float* pointerToElements()
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
        
    #endif
    
} mat3;

#endif
