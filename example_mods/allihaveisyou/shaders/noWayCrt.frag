#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D bitmap;
uniform float iTime;
varying vec2 openfl_TextureCoordv;

float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 uv) {
    return rand(uv + iTime * 0.5);
}

void main() {
    const bool USE_ANIMATION = false;
    const bool USE_EPIC_MODE = true;

    const float GAMMA_BASE = 0.4;
    const float GAMMA_INTENSITY = 0.3;
    const float CONTRAST = 1.4;
    const float CHROMA_OFFSET = 0.005;

    const float SCANLINE_INTENSITY = 0.15;
    const float SCANLINE_FREQ = 700.0;
    const float SCANLINE_SPEED = 20.0;

    const float CURVATURE = 0.03;

    const float VIGNETTE_STRENGTH = 0.8;
    const float VIGNETTE_INNER = 0.15;
    const float VIGNETTE_OUTER = 0.8;

    const float BLUR_AMOUNT = 0.0025;
    const float GRAIN_INTENSITY = 0.09;

    vec2 uv = openfl_TextureCoordv;
    vec2 curveUV = uv * 2.0 - 1.0;
    curveUV *= vec2(
        1.0 + CURVATURE * pow(curveUV.y, 2.0),
        1.0 + CURVATURE * pow(curveUV.x, 2.0)
    );
    uv = (curveUV + 1.0) / 2.0;

    vec4 texColor = (
        texture2D(bitmap, uv + vec2(-BLUR_AMOUNT, -BLUR_AMOUNT)) +
        texture2D(bitmap, uv + vec2( BLUR_AMOUNT, -BLUR_AMOUNT)) +
        texture2D(bitmap, uv + vec2(-BLUR_AMOUNT,  BLUR_AMOUNT)) +
        texture2D(bitmap, uv + vec2( BLUR_AMOUNT,  BLUR_AMOUNT)) +
        texture2D(bitmap, uv)
    ) / 5.0;

    float gamma = USE_ANIMATION
        ? GAMMA_BASE + GAMMA_INTENSITY * sin(iTime * 6.0)
        : GAMMA_BASE + GAMMA_INTENSITY;

    float chroma = USE_EPIC_MODE ? CHROMA_OFFSET * sin(iTime * 2.0) : CHROMA_OFFSET;
    vec2 redUV = uv + vec2(-chroma, 0.0);
    vec2 greenUV = uv;
    vec2 blueUV = uv + vec2(chroma, 0.0);

    vec3 color;
    color.r = texture2D(bitmap, redUV).r;
    color.g = texture2D(bitmap, greenUV).g;
    color.b = texture2D(bitmap, blueUV).b;

    color = pow(color, vec3(gamma));
    color = ((color - 0.5) * CONTRAST) + 0.5;

    float scanline = sin(uv.y * SCANLINE_FREQ + iTime * SCANLINE_SPEED);
    float scanlight = 0.5 + 0.5 * scanline;
    color *= 1.0 - SCANLINE_INTENSITY * scanlight;
    if (USE_EPIC_MODE) {
        color += 0.01 * vec3(scanlight);
    }

    float dist = distance(uv, vec2(0.5));
    float vignette = smoothstep(VIGNETTE_INNER, VIGNETTE_OUTER, dist);
    color *= 1.0 - vignette * VIGNETTE_STRENGTH;

    float grain = (noise(uv * vec2(400.0, 300.0)) - 0.5) * GRAIN_INTENSITY;
    color += grain;

    if (USE_EPIC_MODE) {
        float glow = 0.08 * sin(iTime * 4.0 + uv.y * 10.0);
        color += glow * vec3(0.2, 0.4, 1.0);
    }

    color = clamp(color, 0.0, 1.0);
    gl_FragColor = vec4(color, texColor.a);
}