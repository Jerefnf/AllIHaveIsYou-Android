#pragma header

uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor

#define ENABLE_MODE 1
#define MODE 5

const float glitchThreshold = 0.1;
const float glitchDivision = 7.5;
const int glitchIterations = 2;

float hash(float v) {
    return fract(sin(v) * 43768.5453);
}

float hash(vec2 v) {
    return fract(sin(dot(v, vec2(12.9898, 78.233))) * 43768.5453);
}

vec2 hash2(float v) {
    return vec2(hash(v + 77.77), hash(v + 999.999));
}

vec2 hash2(vec2 v) {
    return vec2(hash(v + 77.77), hash(v + 999.999));
}

vec3 glitch(vec2 p, float seed) {
    float g = -1.0;

    for (int i = 1; i <= glitchIterations; i++) {
        float fi = float(i);
        vec2 rndOffset = hash2(fi + seed);
        vec2 scaled = p * (glitchDivision * fi) + rndOffset;
        scaled *= rndOffset * 2.0 - 1.0;

        vec2 cell = floor(scaled);
        float cellHash = hash(cell);

        if (cellHash < glitchThreshold) {
            p += hash2(cell) * 2.0 - 1.0;
            g = hash(fi + seed);
        }
    }

    return vec3(fract(p), g);
}

vec4 tex(vec2 uv) {
    return texture(iChannel0, uv);
}

// Patrones
vec3 pattern0(vec2 uv, vec3 g) {
    return tex(uv).rgb;
}

vec3 pattern1(vec2 uv, vec3 g) {
    return g.z < 0.0 ? tex(uv).rgb : g.z * tex(uv).rgb;
}

vec3 pattern2(vec2 uv, vec3 g) {
    return g.z < 0.0 ? tex(uv).rgb : tex(uv + vec2(0.1 * (g.z * 2.0 - 1.0), 0.0)).rgb;
}

vec3 pattern3(vec2 uv, vec3 g) {
    return g.z < 0.0 ? tex(uv).rgb : 1.0 - tex(uv).rgb;
}

vec3 pattern4(vec2 uv, vec3 g) {
    return g.z < 0.0 ? tex(uv).rgb : tex(g.xy).rgb;
}

vec3 pattern5(vec2 uv, vec3 g) {
    if (g.z < 0.0) return tex(uv).rgb;

    float intensity = g.z;
    vec2 offsetR = vec2(0.02 * intensity, 0.0);
    vec2 offsetG = vec2(0.0, 0.02 * intensity);
    vec2 offsetB = vec2(-0.015 * intensity, -0.01 * intensity);

    return vec3(
        tex(uv + offsetR).r,
        tex(uv + offsetG).g,
        tex(uv + offsetB).b
    );
}

vec3 getPattern(vec2 uv, vec3 g) {
    #if MODE == 1
        return pattern1(uv, g);
    #elif MODE == 2
        return pattern2(uv, g);
    #elif MODE == 3
        return pattern3(uv, g);
    #elif MODE == 4
        return pattern4(uv, g);
    #elif MODE == 5
        return pattern5(uv, g);
    #else
        return pattern0(uv, g);
    #endif
}

void main() {
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 iResolution = openfl_TextureSize;
    vec2 fragCoord = uv * iResolution;

    vec3 g = ENABLE_MODE == 1 ? glitch(fragCoord / iResolution, iTime) : vec3(0.0);

    vec3 col = getPattern(uv, g);
    float alpha = tex(uv).a * openfl_Alphav;

    fragColor = vec4(col, alpha);
}