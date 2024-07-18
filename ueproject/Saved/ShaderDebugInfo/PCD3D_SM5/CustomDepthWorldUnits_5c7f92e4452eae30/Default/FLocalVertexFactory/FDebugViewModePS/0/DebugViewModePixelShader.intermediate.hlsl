#pragma warning(disable : 3571) // pow() intrinsic suggested to be used with abs()
cbuffer View
{
    float4 View_View_InvDeviceZToWorldZTransform : packoffset(c66);
};

cbuffer InstancedView
{
    row_major float4x4 InstancedView_InstancedView_SVPositionToTranslatedWorld[2] : packoffset(c88);
    row_major float4x4 InstancedView_InstancedView_ScreenToRelativeWorld[2] : packoffset(c96);
    float3 InstancedView_InstancedView_ViewOriginHigh : packoffset(c120);
    float4 InstancedView_InstancedView_ViewRectMin[2] : packoffset(c268);
    float4 InstancedView_InstancedView_ViewSizeAndInvSize : packoffset(c270);
};

cbuffer DebugViewModePass
{
    float4 DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[5] : packoffset(c7);
    float4 DebugViewModePass_DebugViewModePass_DebugViewMode_LODColors[8] : packoffset(c12);
};

cbuffer Material
{
    float4 Material_Material_PreshaderBuffer[1] : packoffset(c0);
};

float4 CPUTexelFactor;
float4 NormalizedComplexity;
int2 AnalysisParams;
float PrimitiveAlpha;
int TexCoordAnalysisIndex;
float CPULogDistance;
uint bShowQuadOverdraw;
uint bOutputQuadOverdraw;
int LODIndex;
float3 SkinCacheDebugColor;
int VisualizeMode;

RWTexture2D<uint> DebugViewModePass_QuadOverdraw;

static uint gl_PrimitiveID;
static float4 gl_FragCoord;
static float4 in_var_TEXCOORD0;
static float4 in_var_TEXCOORD1;
static float4 in_var_TEXCOORD2;
static float3 in_var_TEXCOORD3;
static float3 in_var_TEXCOORD4;
static float3 in_var_TEXCOORD5;
static uint in_var_EYE_INDEX;
static float4 out_var_SV_Target0;

struct SPIRV_Cross_Input
{
    float4 in_var_TEXCOORD0 : TEXCOORD0;
    float4 in_var_TEXCOORD1 : TEXCOORD1;
    float4 in_var_TEXCOORD2 : TEXCOORD2;
    float3 in_var_TEXCOORD3 : TEXCOORD3;
    float3 in_var_TEXCOORD4 : TEXCOORD4;
    float3 in_var_TEXCOORD5 : TEXCOORD5;
    nointerpolation uint in_var_EYE_INDEX : EYE_INDEX;
    uint gl_PrimitiveID : SV_PrimitiveID;
    float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output
{
    float4 out_var_SV_Target0 : SV_Target0;
};

void frag_main()
{
    float4x4 _121 = InstancedView_InstancedView_ScreenToRelativeWorld[in_var_EYE_INDEX];
    float4 _699 = 0.0f.xxxx;
    [branch]
    if ((((VisualizeMode == 1) || (VisualizeMode == 2)) || (VisualizeMode == 3)) || (VisualizeMode == 4))
    {
        float3 _694 = 0.0f.xxx;
        if (bOutputQuadOverdraw != 0u)
        {
            float3 _608 = NormalizedComplexity.xyz;
            float3 _693 = 0.0f.xxx;
            [branch]
            if ((bShowQuadOverdraw != 0u) && (NormalizedComplexity.x > 0.0f))
            {
                uint2 _620 = uint2(gl_FragCoord.xy) / uint2(2u, 2u);
                uint _622 = 0u;
                int _625 = 0;
                _622 = 3u;
                _625 = 0;
                uint _623 = 0u;
                int _626 = 0;
                [loop]
                for (int _627 = 0; _627 < 24; _622 = _623, _625 = _626, _627++)
                {
                    uint _648 = 0u;
                    int _649 = 0;
                    [branch]
                    if (true && (_625 == 1))
                    {
                        uint4 _637 = DebugViewModePass_QuadOverdraw[_620].xxxx;
                        uint _638 = _637.x;
                        bool _641 = ((_638 >> 2u) - 1u) != uint(gl_PrimitiveID);
                        uint _646 = 0u;
                        [flatten]
                        if (_641)
                        {
                            _646 = _622;
                        }
                        else
                        {
                            _646 = _638 & 3u;
                        }
                        _648 = _646;
                        _649 = _641 ? (-1) : _625;
                    }
                    else
                    {
                        _648 = _622;
                        _649 = _625;
                    }
                    int _664 = 0;
                    [branch]
                    if (_649 == 2)
                    {
                        uint4 _654 = DebugViewModePass_QuadOverdraw[_620].xxxx;
                        uint _656 = _654.x & 3u;
                        uint _662 = 0u;
                        int _663 = 0;
                        [branch]
                        if (_656 == _648)
                        {
                            DebugViewModePass_QuadOverdraw[_620] = 0u;
                            _662 = _648;
                            _663 = -1;
                        }
                        else
                        {
                            _662 = _656;
                            _663 = _649;
                        }
                        _623 = _662;
                        _664 = _663;
                    }
                    else
                    {
                        _623 = _648;
                        _664 = _649;
                    }
                    [branch]
                    if (_664 == 0)
                    {
                        uint _671;
                        InterlockedCompareExchange(DebugViewModePass_QuadOverdraw[_620], 0u, (uint(gl_PrimitiveID) + 1u) << 2u, _671);
                        int _680 = 0;
                        [branch]
                        if (((_671 >> 2u) - 1u) == uint(gl_PrimitiveID))
                        {
                            uint _679;
                            InterlockedAdd(DebugViewModePass_QuadOverdraw[_620], 1u, _679);
                            _680 = 1;
                        }
                        else
                        {
                            _680 = (_671 == 0u) ? 2 : _664;
                        }
                        _626 = _680;
                    }
                    else
                    {
                        _626 = _664;
                    }
                }
                [branch]
                if (_625 == 2)
                {
                    DebugViewModePass_QuadOverdraw[_620] = 0u;
                }
                float3 _692 = _608;
                _692.x = NormalizedComplexity.x * (4.0f / float((_625 != (-2)) ? (1u + _622) : 0u));
                _693 = _692;
            }
            else
            {
                _693 = _608;
            }
            _694 = _693;
        }
        else
        {
            _694 = NormalizedComplexity.xyz;
        }
        _699 = float4(_694, 1.0f);
    }
    else
    {
        float4 _596 = 0.0f.xxxx;
        if (VisualizeMode == 5)
        {
            float3 _589 = 0.0f.xxx;
            if (CPULogDistance >= 0.0f)
            {
                float4 _566 = mul(float4(gl_FragCoord.xyz, 1.0f), InstancedView_InstancedView_SVPositionToTranslatedWorld[in_var_EYE_INDEX]);
                float _575 = clamp(log2(max(1.0f, length(_566.xyz / _566.w.xxx))) - CPULogDistance, -1.9900000095367431640625f, 1.9900000095367431640625f);
                int _578 = int(floor(_575) + 2.0f);
                _589 = lerp(DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_578].xyz, DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_578 + 1].xyz, frac(_575).xxx);
            }
            else
            {
                _589 = 0.014999999664723873138427734375f.xxx;
            }
            _596 = float4(_589, PrimitiveAlpha);
        }
        else
        {
            float4 _556 = 0.0f.xxxx;
            if (VisualizeMode == 6)
            {
                float3 _549 = 0.0f.xxx;
                if (TexCoordAnalysisIndex >= 0)
                {
                    bool _469 = false;
                    float _486 = 0.0f;
                    do
                    {
                        _469 = TexCoordAnalysisIndex == 0;
                        [flatten]
                        if (_469)
                        {
                            _486 = CPUTexelFactor.x;
                            break;
                        }
                        [flatten]
                        if (TexCoordAnalysisIndex == 1)
                        {
                            _486 = CPUTexelFactor.y;
                            break;
                        }
                        [flatten]
                        if (TexCoordAnalysisIndex == 2)
                        {
                            _486 = CPUTexelFactor.z;
                            break;
                        }
                        _486 = CPUTexelFactor.w;
                        break;
                    } while(false);
                    float3 _548 = 0.0f.xxx;
                    if (_486 > 0.0f)
                    {
                        float4 _494 = mul(float4(gl_FragCoord.xyz, 1.0f), InstancedView_InstancedView_SVPositionToTranslatedWorld[in_var_EYE_INDEX]);
                        float3 _498 = _494.xyz / _494.w.xxx;
                        float2 _513 = 0.0f.xx;
                        do
                        {
                            [flatten]
                            if (_469)
                            {
                                _513 = in_var_TEXCOORD1.xy;
                                break;
                            }
                            [flatten]
                            if (TexCoordAnalysisIndex == 1)
                            {
                                _513 = in_var_TEXCOORD1.zw;
                                break;
                            }
                            [flatten]
                            if (TexCoordAnalysisIndex == 2)
                            {
                                _513 = in_var_TEXCOORD2.xy;
                                break;
                            }
                            _513 = in_var_TEXCOORD2.zw;
                            break;
                        } while(false);
                        float2 _514 = ddx_fine(_513);
                        float2 _515 = ddy_fine(_513);
                        float _534 = clamp(log2(_486) - log2(sqrt(length(cross(ddx_fine(_498), ddy_fine(_498))) / max(abs(mad(_514.x, _515.y, -(_514.y * _515.x))), 1.0000000133514319600180897396058e-10f))), -1.9900000095367431640625f, 1.9900000095367431640625f);
                        int _537 = int(floor(_534) + 2.0f);
                        _548 = lerp(DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_537].xyz, DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_537 + 1].xyz, frac(_534).xxx);
                    }
                    else
                    {
                        _548 = 0.014999999664723873138427734375f.xxx;
                    }
                    _549 = _548;
                }
                else
                {
                    float _319 = 0.0f;
                    float _320 = 0.0f;
                    if (CPUTexelFactor.x > 0.0f)
                    {
                        float4 _290 = mul(float4(gl_FragCoord.xyz, 1.0f), InstancedView_InstancedView_SVPositionToTranslatedWorld[in_var_EYE_INDEX]);
                        float3 _294 = _290.xyz / _290.w.xxx;
                        float2 _296 = ddx_fine(in_var_TEXCOORD1.xy);
                        float2 _297 = ddy_fine(in_var_TEXCOORD1.xy);
                        float _316 = clamp(log2(CPUTexelFactor.x) - log2(sqrt(length(cross(ddx_fine(_294), ddy_fine(_294))) / max(abs(mad(_296.x, _297.y, -(_296.y * _297.x))), 1.0000000133514319600180897396058e-10f))), -1.9900000095367431640625f, 1.9900000095367431640625f);
                        _319 = max(_316, -1024.0f);
                        _320 = min(_316, 1024.0f);
                    }
                    else
                    {
                        _319 = -1024.0f;
                        _320 = 1024.0f;
                    }
                    float _359 = 0.0f;
                    float _360 = 0.0f;
                    if (CPUTexelFactor.y > 0.0f)
                    {
                        float4 _330 = mul(float4(gl_FragCoord.xyz, 1.0f), InstancedView_InstancedView_SVPositionToTranslatedWorld[in_var_EYE_INDEX]);
                        float3 _334 = _330.xyz / _330.w.xxx;
                        float2 _336 = ddx_fine(in_var_TEXCOORD1.zw);
                        float2 _337 = ddy_fine(in_var_TEXCOORD1.zw);
                        float _356 = clamp(log2(CPUTexelFactor.y) - log2(sqrt(length(cross(ddx_fine(_334), ddy_fine(_334))) / max(abs(mad(_336.x, _337.y, -(_336.y * _337.x))), 1.0000000133514319600180897396058e-10f))), -1.9900000095367431640625f, 1.9900000095367431640625f);
                        _359 = max(_356, _319);
                        _360 = min(_356, _320);
                    }
                    else
                    {
                        _359 = _319;
                        _360 = _320;
                    }
                    float _399 = 0.0f;
                    float _400 = 0.0f;
                    if (CPUTexelFactor.z > 0.0f)
                    {
                        float4 _370 = mul(float4(gl_FragCoord.xyz, 1.0f), InstancedView_InstancedView_SVPositionToTranslatedWorld[in_var_EYE_INDEX]);
                        float3 _374 = _370.xyz / _370.w.xxx;
                        float2 _376 = ddx_fine(in_var_TEXCOORD2.xy);
                        float2 _377 = ddy_fine(in_var_TEXCOORD2.xy);
                        float _396 = clamp(log2(CPUTexelFactor.z) - log2(sqrt(length(cross(ddx_fine(_374), ddy_fine(_374))) / max(abs(mad(_376.x, _377.y, -(_376.y * _377.x))), 1.0000000133514319600180897396058e-10f))), -1.9900000095367431640625f, 1.9900000095367431640625f);
                        _399 = max(_396, _359);
                        _400 = min(_396, _360);
                    }
                    else
                    {
                        _399 = _359;
                        _400 = _360;
                    }
                    float _439 = 0.0f;
                    float _440 = 0.0f;
                    if (CPUTexelFactor.w > 0.0f)
                    {
                        float4 _410 = mul(float4(gl_FragCoord.xyz, 1.0f), InstancedView_InstancedView_SVPositionToTranslatedWorld[in_var_EYE_INDEX]);
                        float3 _414 = _410.xyz / _410.w.xxx;
                        float2 _416 = ddx_fine(in_var_TEXCOORD2.zw);
                        float2 _417 = ddy_fine(in_var_TEXCOORD2.zw);
                        float _436 = clamp(log2(CPUTexelFactor.w) - log2(sqrt(length(cross(ddx_fine(_414), ddy_fine(_414))) / max(abs(mad(_416.x, _417.y, -(_416.y * _417.x))), 1.0000000133514319600180897396058e-10f))), -1.9900000095367431640625f, 1.9900000095367431640625f);
                        _439 = max(_436, _399);
                        _440 = min(_436, _400);
                    }
                    else
                    {
                        _439 = _399;
                        _440 = _400;
                    }
                    int2 _442 = int2(gl_FragCoord.xy);
                    float _448 = ((_442.x & 8) == (_442.y & 8)) ? _440 : _439;
                    float3 _466 = 0.0f.xxx;
                    if (abs(_448) != 1024.0f)
                    {
                        int _455 = int(floor(_448) + 2.0f);
                        _466 = lerp(DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_455].xyz, DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_455 + 1].xyz, frac(_448).xxx);
                    }
                    else
                    {
                        _466 = 0.014999999664723873138427734375f.xxx;
                    }
                    _549 = _466;
                }
                _556 = float4(_549, PrimitiveAlpha);
            }
            else
            {
                float4 _274 = 0.0f.xxxx;
                if ((VisualizeMode == 7) || (VisualizeMode == 8))
                {
                    float4 _273 = 0.0f.xxxx;
                    if (AnalysisParams.y != 0)
                    {
                        _273 = 256.0f.xxxx;
                    }
                    else
                    {
                        _273 = float4(0.0f, 0.0f, 0.0f, PrimitiveAlpha);
                    }
                    _274 = _273;
                }
                else
                {
                    float4 _263 = 0.0f.xxxx;
                    if ((VisualizeMode == 9) || (VisualizeMode == 10))
                    {
                        _263 = float4(0.0f, 0.0f, 0.0f, PrimitiveAlpha);
                    }
                    else
                    {
                        float4 _259 = 0.0f.xxxx;
                        if (VisualizeMode == 11)
                        {
                            float3 _234 = _121[3].xyz + InstancedView_InstancedView_ViewOriginHigh;
                            float4x4 _236 = _121;
                            _236[3] = float4(_234.x, _234.y, _234.z, _121[3].w);
                            _259 = float4(DebugViewModePass_DebugViewModePass_DebugViewMode_LODColors[LODIndex].xyz * mad(0.949999988079071044921875f, dot(lerp((length(-((View_View_InvDeviceZToWorldZTransform.y + ((-1.0f) / View_View_InvDeviceZToWorldZTransform.w)).xxx * mul(float4(mad((gl_FragCoord.xy - InstancedView_InstancedView_ViewRectMin[in_var_EYE_INDEX].xy) * InstancedView_InstancedView_ViewSizeAndInvSize.zw, 2.0f.xx, (-1.0f).xx), 1.0f, 0.0f), _236).xyz)) * 0.00999999977648258209228515625f).xxx, Material_Material_PreshaderBuffer[0].yzw, Material_Material_PreshaderBuffer[0].x.xxx), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)), 0.0500000007450580596923828125f), 1.0f);
                        }
                        else
                        {
                            float4 _211 = 0.0f.xxxx;
                            if (VisualizeMode == 12)
                            {
                                float3 _186 = _121[3].xyz + InstancedView_InstancedView_ViewOriginHigh;
                                float4x4 _188 = _121;
                                _188[3] = float4(_186.x, _186.y, _186.z, _121[3].w);
                                _211 = float4(SkinCacheDebugColor * mad(0.949999988079071044921875f, dot(lerp((length(-((View_View_InvDeviceZToWorldZTransform.y + ((-1.0f) / View_View_InvDeviceZToWorldZTransform.w)).xxx * mul(float4(mad((gl_FragCoord.xy - InstancedView_InstancedView_ViewRectMin[in_var_EYE_INDEX].xy) * InstancedView_InstancedView_ViewSizeAndInvSize.zw, 2.0f.xx, (-1.0f).xx), 1.0f, 0.0f), _188).xyz)) * 0.00999999977648258209228515625f).xxx, Material_Material_PreshaderBuffer[0].yzw, Material_Material_PreshaderBuffer[0].x.xxx), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)), 0.0500000007450580596923828125f), 1.0f);
                            }
                            else
                            {
                                _211 = float4(1.0f, 0.0f, 1.0f, 1.0f);
                            }
                            _259 = _211;
                        }
                        _263 = _259;
                    }
                    _274 = _263;
                }
                _556 = _274;
            }
            _596 = _556;
        }
        _699 = _596;
    }
    out_var_SV_Target0 = _699;
}

[earlydepthstencil]
SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_PrimitiveID = stage_input.gl_PrimitiveID;
    gl_FragCoord = stage_input.gl_FragCoord;
    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
    in_var_TEXCOORD0 = stage_input.in_var_TEXCOORD0;
    in_var_TEXCOORD1 = stage_input.in_var_TEXCOORD1;
    in_var_TEXCOORD2 = stage_input.in_var_TEXCOORD2;
    in_var_TEXCOORD3 = stage_input.in_var_TEXCOORD3;
    in_var_TEXCOORD4 = stage_input.in_var_TEXCOORD4;
    in_var_TEXCOORD5 = stage_input.in_var_TEXCOORD5;
    in_var_EYE_INDEX = stage_input.in_var_EYE_INDEX;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.out_var_SV_Target0 = out_var_SV_Target0;
    return stage_output;
}
