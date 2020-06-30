//
//  Shader.metal
//  SimplerMetal_demo
//
//  Created by BWS MacMini 1 on 21/4/2563 BE.
//  Copyright © 2563 BWS MacMini 1. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

/*struct Constants{
    float animateBy;
};*/

struct ModelConstants{
    float4x4 modelViewMatrix;
};

struct SceneConstants {
  float4x4 projectionMatrix;
};


struct VertexIn {
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float2 textureCoordinates [[ attribute(2) ]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color ;
    float2 textureCoordinates;
};

/*vertex VertexOut vertex_shader(const VertexIn vertexIn [[stage_in]],
                               constant ModelConstants &modelConstants [[buffer(1)]]){
    VertexOut vertexOut;
    //vertexOut.position = vertexIn.position;
    
    vertexOut.position = modelConstants.modelViewMatrix * vertexIn.position;
    
    vertexOut.color = vertexIn.color;
    vertexOut.textureCoordinates = vertexIn.textureCoordinates;
    
    return vertexOut;
}*/

vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                               constant ModelConstants &modelConstants [[ buffer(1) ]],
                               constant SceneConstants &sceneConstants [[ buffer(2) ]]) {
  VertexOut vertexOut;
  float4x4 matrix = sceneConstants.projectionMatrix * modelConstants.modelViewMatrix;
  vertexOut.position = matrix * vertexIn.position;
  vertexOut.color = vertexIn.color;
  vertexOut.textureCoordinates = vertexIn.textureCoordinates;
  return vertexOut;
}

fragment half4 fragment_shader(VertexOut vertexIn [[stage_in]]){
    return half4(vertexIn.color);
}

fragment half4 texture_fragment(VertexOut vertexIn [[stage_in]],
                                sampler sampler2d [[sampler(0)]],
                                texture2d<float> texture [[texture(0)]]){
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    return half4(color.r, color.g,color.b, 1);
}



// shader Code with index and moving Vertex
/*vertex float4 vertex_shader(const device packed_float3 *verticles [[buffer(0)]],
                            constant Constants &constants [[buffer(1)]],
                            uint vertexId [[vertex_id]]){
    float4 position = float4(verticles[vertexId], 1);
    position.x += constants.animateBy;
    return position;
}

fragment half4 fragment_shader() {
    return half4(1,1,0,1);
}*/

