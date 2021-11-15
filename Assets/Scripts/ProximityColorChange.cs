using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProximityColorChange : MonoBehaviour
{
    Material Mat;
    GameObject Player;
    public int Distance = 10;
 
    void Start()
    {
        // Grabs the material from the object
        Mat = GetComponent<Renderer>().material;
        
        Player = GameObject.Find("Player2");
    }
 
    void Update()
    {
        Distance = (int) Vector3.Distance(transform.position, Player.transform.position);
        // Sets PlayerPosition on the shader to the player's position
        Mat.SetVector("_PlayerPos", Player.transform.position);
        // Sets Distance in the shader to the value of Radius
        Mat.SetFloat("_Dist", Distance);
    }
}
