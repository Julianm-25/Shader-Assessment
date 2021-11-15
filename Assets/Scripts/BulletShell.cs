using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BulletShell : MonoBehaviour
{
    public ParticleSystem shellSystem;
    public Transform shellspot;

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.Q))
        {
            shellSystem.Play();
        }
    }
}
