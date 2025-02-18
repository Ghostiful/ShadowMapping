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
        theRenderer.material.SetTexture("_ShadowMap", depthCam.GetComponent<Camera>().targetTexture);
    }
    // Update is called once per frame
    void Update()
    {
        theRenderer.material.SetMatrix("_LightViewMatrix", depthCam.GetComponent<Camera>().worldToCameraMatrix);
        theRenderer.material.SetMatrix("_LightprojectionMatrix", depthCam.GetComponent<Camera>().projectionMatrix);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        
        Graphics.Blit(source, destination, theRenderer.material);
    }
}
