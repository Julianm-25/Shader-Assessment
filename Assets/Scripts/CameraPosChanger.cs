using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class CameraPosChanger : MonoBehaviour
{
    public int currentCameraSpot = 1;
    public GameObject camera;
    public GameObject[] CameraPos;
    private int camSpots;
    // Start is called before the first frame update
    void Start()
    {
        CameraPos = GameObject.FindGameObjectsWithTag("CameraPos");
        if (UnityEngine.SceneManagement.SceneManager.GetActiveScene().name == "Shaders")
        {
            camSpots = 5;
        }
        else
        {
            camSpots = 3;
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void NextCameraPos()
    {
        currentCameraSpot++;
        if (currentCameraSpot > camSpots)
        {
            currentCameraSpot = 1;
        }

        camera.transform.position = CameraPos[currentCameraSpot - 1].transform.position;
    }
    
    public void PrevCameraPos()
    {
        currentCameraSpot--;
        if (currentCameraSpot < 1)
        {
            currentCameraSpot = camSpots;
        }

        camera.transform.position = CameraPos[currentCameraSpot - 1].transform.position;
    }
}
