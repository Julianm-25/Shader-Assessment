using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoMovePlayer : MonoBehaviour
{
    public GameObject player;
    private bool isGoingForward;
    
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine("GoForward");
    }

    private void Update()
    {
        if (isGoingForward)
        {
            player.transform.Translate(2 * Time.deltaTime,0,0);
        }
        else
        {
            player.transform.Translate(2 * -Time.deltaTime,0,0);
        }
    }

    IEnumerator GoForward()
    {
        isGoingForward = true;
        yield return new WaitForSeconds(3);
        StartCoroutine("GoBack");
    }

    IEnumerator GoBack()
    {
        isGoingForward = false;
        yield return new WaitForSeconds(3);
        StartCoroutine("GoForward");
    }
}
