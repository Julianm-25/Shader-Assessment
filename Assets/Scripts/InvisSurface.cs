using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InvisSurface : MonoBehaviour
{
    Material Mat;
    GameObject Player;
    public int Radius = 10;
 
    void Start()
    {
        // Grabs the material from the object
        Mat = GetComponent<Renderer>().material;
        
        Player = GameObject.Find("Player");
    }
 
    void Update()
    {
        // Sets PlayerPosition on the shader to the player's position
        Mat.SetVector("_PlayerPos", Player.transform.position);
        // Sets Distance in the shader to the value of Radius
        Mat.SetFloat("_Dist", Radius);
    }
}
