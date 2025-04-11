//
//  metalshaders.metal
//  Tuner
//
//  Created by Ashish on 28/03/25.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 noiseShader(float2 position, half4 color, float2 size, float time) {
    float value = fract(sin(dot(position + time, float2(12.9898, 78.233))) * 43758.5453);
    return half4(value, value, value, 1) * color.a;
}
