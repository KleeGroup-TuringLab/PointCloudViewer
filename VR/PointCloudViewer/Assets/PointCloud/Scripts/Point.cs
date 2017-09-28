using System;
using System.Collections.Generic;
using UnityEngine;

public class Point {
	// Size that the octree was on creation
	public Vector3 pos;
    public Vector3 normal;
    public Color color;
    public Color defaultColor;

    internal String meshName;
    internal int[] meshIdx;
    //internal Color[] meshColors;

    public Point() {
	}

    internal void inMesh(String meshName,  int[] meshIdx/*, Color[] meshColors*/)
    {
        this.meshName = meshName;
        this.meshIdx = meshIdx;
       // this.meshColors = meshColors;

    }

    internal String Highlight()
    {
  
        defaultColor = color;
        color = Color.green;
        return meshName;
    }

    internal String unHighlight()
    {
        
        color = defaultColor;
        return meshName;
    }

    internal void applyColors(Color[] meshColors)
    {
       for (int i = 0; i < meshIdx.Length; i++)
        {
            meshColors[i] = color;
        }
    }
}