#ifndef PLATFORM_GLSL
#define PLATFORM_GLSL

#if defined(GL_ES)

    #define SGL_IOS

#else

    #define SGL_MAC

#endif

#if defined(GL_ES) || (__VERSION__ < 150)

    #define  VERT_IN    attribute
    #define  VERT_OUT   varying
    #define  FRAG_IN    varying
    #define  FRAG_OUT   gl_FragColor

#else

    #define  VERT_IN    in
    #define  VERT_OUT   out
    #define  FRAG_IN    in
    out vec4 FRAG_OUT;

#endif

#if defined(GL_ES)

    #define LOWP_FLOAT  precision lowp float;
    #define MEDP_FLOAT  precision medp float;
    #define HIGHP_FLOAT precision highp float;

#else

    #define LOWP_FLOAT
    #define MEDP_FLOAT
    #define HIGHP_FLOAT

#endif

#endif
