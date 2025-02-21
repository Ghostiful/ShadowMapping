using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShadowObj : MonoBehaviour
{
    public GameObject depthCam;
    Renderer theRenderer;

    private void Start()
    {
        theRenderer = GetComponent<Renderer>();

    }
    // Update is called once per frame
    void Update()
    {
        //theRenderer.material.SetMatrix("_LightViewMatrix", depthCam.GetComponent<Camera>().worldToCameraMatrix);
        //theRenderer.material.SetMatrix("_LightprojectionMatrix", depthCam.GetComponent<Camera>().projectionMatrix);
        //theRenderer.material.SetTexture("_ShadowMap", depthCam.GetComponent<Camera>().targetTexture);
        Shader.SetGlobalMatrix("_LightViewMatrix", depthCam.GetComponent<Camera>().worldToCameraMatrix);
        Shader.SetGlobalMatrix("_LightprojectionMatrix", depthCam.GetComponent<Camera>().projectionMatrix);
        Shader.SetGlobalTexture("_ShadowMap", depthCam.GetComponent<Camera>().targetTexture);

    }

    //private void OnRenderImage(RenderTexture source, RenderTexture destination)
    //{
        
    //    Graphics.Blit(source, destination, theRenderer.material);
    //}
}
