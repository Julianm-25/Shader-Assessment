using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shrapnel : MonoBehaviour
{
    // The particle system prefab
    public GameObject shrapnelSystem;

    // The material taken from the raycast target
    public Material targetMat;

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            // This raycast goes towards the mouse
            Ray clickCheck;

            clickCheck = Camera.main.ScreenPointToRay(Input.mousePosition);

            RaycastHit hitInfo;

            if (Physics.Raycast(clickCheck, out hitInfo))
            {
                targetMat = hitInfo.collider.gameObject.GetComponent<Renderer>().material;

                shrapnelSystem.GetComponent<ParticleSystemRenderer>().material = targetMat;

                shrapnelSystem.transform.position = hitInfo.point;
                
                Instantiate(shrapnelSystem);
            }
        }
    }
}
