using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthbarShader : MonoBehaviour
{
    Material Mat;
    public bool healthIncreasing;
    public float health;
    void Start()
    {
        Mat = GetComponent<Renderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        if (healthIncreasing)
        {
            health += Time.deltaTime / 5;
        }
        else
        {
            health -= Time.deltaTime / 5;
        }

        if (health > 1)
        {
            healthIncreasing = false;
        }
        else if (health < 0)
        {
            healthIncreasing = true;
        }

        Mat.SetFloat("_Health", health);
    }
}
