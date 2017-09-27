using UnityEngine;
using System.Collections;
using System.IO;

public class PointCloudManager : MonoBehaviour {

	// File
	public string dataPath;
	private string filename;
	public Material matVertex;

	// GUI
	private float progress = 0;
	private string guiText;
	private bool loaded = false;

	// PointCloud
	private GameObject pointCloud;
	public bool pointsCloud; //Points
	public bool normalsCloud; //Normals
	public bool facesCloud; //Normals
	public float faceSize = 0.01f;

    public float sparse = 0.25f;
    public float scale = 0.3f;
    public float normalsScale = 0.1f;
    public bool negZOnReload = false;
    public bool invertYZOnReload = false;
	public bool forceReload = false;

    public int totalPoints;
    public int numPoints;
	public int numPointGroups;
    private int limitPoints = 65000/4;
    private float localScale = 1f;
    private Vector3[] points;
    private Vector3[] normals;
    private Color[] colors;
	private Vector3 minValue;
    private Vector3 maxValue;
    private Vector3 center;
    private Vector3 size;


    void Start () {
		// Create Resources folder
		createFolders ();

		// Get Filename
		filename = Path.GetFileName(dataPath);

		loadScene ();


	}
    
    void loadScene(){
        // Check if the PointCloud was loaded previously
        if (!Directory.Exists(Application.dataPath + "/Resources/PointCloudMeshes/" + filename))
        {
            UnityEditor.AssetDatabase.CreateFolder("Assets/Resources/PointCloudMeshes", filename);
            loadPointCloud();
        }
        else if (forceReload)
        {
            UnityEditor.FileUtil.DeleteFileOrDirectory(Application.dataPath + "/Resources/PointCloudMeshes/" + filename);
            UnityEditor.AssetDatabase.Refresh();
            UnityEditor.AssetDatabase.CreateFolder("Assets/Resources/PointCloudMeshes", filename);
            loadPointCloud();
        }
        else
        {
            // Load stored PointCloud
            loadStoredMeshes();
        }

        
    }


    void loadPointCloud(){
		// Check what file exists
		if (File.Exists (Application.dataPath + dataPath + ".off")) 
			// load off
			StartCoroutine ("loadOFF", dataPath + ".off");
		else 
			Debug.Log ("File '" + Application.dataPath + dataPath + ".off" + "' could not be found"); 
		
	}
	
	// Load stored PointCloud
	void loadStoredMeshes(){

		Debug.Log ("Using previously loaded PointCloud: " + filename);

		pointCloud = Instantiate(Resources.Load ("PointCloudMeshes/" + filename)) as GameObject;
        pointCloud.transform.parent = this.transform;
        pointCloud.transform.localPosition = new Vector3();
        
        size = pointCloud.GetComponentInChildren<MeshFilter>().mesh.bounds.size;
        center = pointCloud.GetComponentInChildren<MeshFilter>().mesh.bounds.center;
        Debug.Log("size : " + pointCloud.GetComponentInChildren<MeshFilter>().mesh.bounds.size + "  center:" + pointCloud.GetComponentInChildren<MeshFilter>().mesh.bounds.center);
        Debug.Log("center : " + center + "  size:" + size);
        Debug.Log("should center: (-5.6, 2.4, 6.2)  size: (165.0, 62.7, 93.5)");

        
        this.GetComponent<BoxCollider>().size = size;
        this.GetComponent<MeshFilter>().mesh = makeCube(Vector3.zero, size);
        this.transform.localScale = this.transform.localScale * scale;

        loaded = true;
	}
	
	// Start Coroutine of reading the points from the OFF file and creating the meshes
	IEnumerator loadOFF(string dPath){

		// Read file
		StreamReader sr = new StreamReader (Application.dataPath + dPath);
		sr.ReadLine (); // OFF
		string[] buffer = sr.ReadLine ().Split(); // nPoints, nFaces

        totalPoints = int.Parse(buffer[0]);
        numPoints = Mathf.CeilToInt((totalPoints) * sparse);
        points = new Vector3[numPoints];
		colors = new Color[numPoints];
        normals = new Vector3[numPoints];
        minValue = new Vector3();
        maxValue = new Vector3();
        Debug.Log("load : " + numPoints + "  points of "+totalPoints);

        int lastI =-1;
        for (int j = 0; j < totalPoints; j++)
        {
            string bufferLine = sr.ReadLine();
           
            int i = Mathf.FloorToInt(j*sparse);
            //Debug.Log("read : " + i + " j:" + j );
            if (i == lastI)
                continue;
            
            lastI = i;
            //Debug.Log("compute : " + i + " j:" + j);
            buffer = bufferLine.Split();

            if (!invertYZOnReload)
				points[i] = new Vector3 (float.Parse (buffer[0]), float.Parse (buffer[1]),float.Parse (buffer[2]) * (negZOnReload ? -1f : 1f)) ;
			else
				points[i] = new Vector3 (float.Parse (buffer[0]), float.Parse (buffer[2]),float.Parse (buffer[1]) * (negZOnReload ? -1f : 1f)) ;
			
			if (buffer.Length >= 5)
				colors[i] = new Color (int.Parse (buffer[3])/255.0f,int.Parse (buffer[4])/255.0f,int.Parse (buffer[5])/255.0f);
			else
				colors[i] = Color.cyan;

            if (buffer.Length >= 9)
                if (!invertYZOnReload)
                    normals[i] = new Vector3(float.Parse(buffer[7]), float.Parse(buffer[8]), float.Parse(buffer[9]) * (negZOnReload ? -1f : 1f));
                else
                    normals[i] = new Vector3(float.Parse(buffer[7]), float.Parse(buffer[9]), float.Parse(buffer[8]) * (negZOnReload ? -1f : 1f));

            // Relocate Points near the origin
            calculateMinMax(points[i]);

            // GUI
            progress = i *1.0f/(numPoints-1)*1.0f;
            if (i%Mathf.FloorToInt(Mathf.Max(numPoints / 20, 1)) == 0){
				guiText=i.ToString() + " out of " + numPoints.ToString() + " loaded";
				yield return null;
			}
		}
        size = maxValue - minValue;
        center = minValue + size / 2;
        Debug.Log("Min : "+minValue +"  Max:"+maxValue);
        Debug.Log("center : " + center + "  size:" + size);
        localScale = 1 / Mathf.Max(Mathf.Max(size.x, size.y), size.z);
        // Instantiate Point Groups
        numPointGroups = Mathf.CeilToInt (numPoints*1.0f / limitPoints*1.0f);

		pointCloud = new GameObject (filename);
        pointCloud.transform.parent = this.transform;
        pointCloud.transform.localPosition = new Vector3();

        for (int i = 0; i < numPointGroups-1; i ++) {
			InstantiateMesh (i, limitPoints);
			if (i%10==0){
				guiText = i.ToString() + " out of " + numPointGroups.ToString() + " PointGroups loaded";
				yield return null;
			}
		}       
        InstantiateMesh(numPointGroups-1, numPoints- (numPointGroups-1) * limitPoints);
      
		//Store PointCloud
		UnityEditor.PrefabUtility.CreatePrefab ("Assets/Resources/PointCloudMeshes/" + filename + ".prefab", pointCloud);

        this.GetComponent<BoxCollider>().size = size;
        this.GetComponent<MeshFilter>().mesh = makeCube(Vector3.zero, size);
        this.transform.localScale = this.transform.localScale * scale;
        
        loaded = true;
	}

	void InstantiateMesh(int meshInd, int nPoints){
		if(pointsCloud) {
			InstantiatePointsMesh(meshInd, nPoints);
		}
		if(normalsCloud) {
			InstantiateNormalsMesh(meshInd, nPoints);
		}
		if(facesCloud) {
			InstantiateFacesMesh(meshInd, nPoints);
		}
	}
	
	
	void InstantiatePointsMesh(int meshInd, int nPoints){
		// Create Mesh
		GameObject pointGroup = new GameObject (filename + meshInd);
		pointGroup.AddComponent<MeshFilter> ();
		pointGroup.AddComponent<MeshRenderer> ();
		pointGroup.GetComponent<Renderer>().material = matVertex;

        pointGroup.GetComponent<MeshFilter> ().mesh = CreatePointsMesh(meshInd, nPoints, limitPoints);
		pointGroup.transform.parent = pointCloud.transform;
        pointGroup.transform.localPosition = new Vector3();
       
        // Store Mesh
        UnityEditor.AssetDatabase.CreateAsset(pointGroup.GetComponent<MeshFilter> ().mesh, "Assets/Resources/PointCloudMeshes/" + filename + @"/" + filename + "Points" + meshInd + ".asset");
		UnityEditor.AssetDatabase.SaveAssets();
		UnityEditor.AssetDatabase.Refresh();
	}
	
	void InstantiateNormalsMesh(int meshInd, int nPoints){
		// Create Mesh
		GameObject pointGroup = new GameObject (filename + meshInd);
		pointGroup.AddComponent<MeshFilter> ();
		pointGroup.AddComponent<MeshRenderer> ();
		pointGroup.GetComponent<Renderer>().material = matVertex;

        pointGroup.GetComponent<MeshFilter> ().mesh = CreateNormalsMesh(meshInd, nPoints, limitPoints);
		pointGroup.transform.parent = pointCloud.transform;
        pointGroup.transform.localPosition = new Vector3();
       
        // Store Mesh
        UnityEditor.AssetDatabase.CreateAsset(pointGroup.GetComponent<MeshFilter> ().mesh, "Assets/Resources/PointCloudMeshes/" + filename + @"/" + filename + "Normals" + meshInd + ".asset");
		UnityEditor.AssetDatabase.SaveAssets();
		UnityEditor.AssetDatabase.Refresh();
	}
	
	void InstantiateFacesMesh(int meshInd, int nPoints){
		// Create Mesh
		GameObject pointGroup = new GameObject (filename + meshInd);
		pointGroup.AddComponent<MeshFilter> ();
		pointGroup.AddComponent<MeshRenderer> ();
		pointGroup.GetComponent<Renderer>().material = matVertex;

        pointGroup.GetComponent<MeshFilter> ().mesh = CreateFacesMesh(meshInd, nPoints, limitPoints);
		pointGroup.transform.parent = pointCloud.transform;
        pointGroup.transform.localPosition = new Vector3();
        
        // Store Mesh
        UnityEditor.AssetDatabase.CreateAsset(pointGroup.GetComponent<MeshFilter> ().mesh, "Assets/Resources/PointCloudMeshes/" + filename + @"/" + filename + "Faces" + meshInd + ".asset");
		UnityEditor.AssetDatabase.SaveAssets ();
		UnityEditor.AssetDatabase.Refresh();
	}

	Mesh CreatePointsMesh(int id, int nPoints, int limitPoints){
		
		Mesh mesh = new Mesh ();
		
		Vector3[] myPoints = new Vector3[nPoints];
        Vector3[] myNormals = new Vector3[nPoints];
        int[] indecies = new int[nPoints];
		Color[] myColors = new Color[nPoints];

		for(int i=0;i<nPoints;++i) {
			myPoints[i] = (points[id*limitPoints + i] - center);
            indecies[i] = i;
			myColors[i] = colors[id*limitPoints + i];
            myNormals[i] = normals[id * limitPoints + i];
        }
		mesh.vertices = myPoints;
		mesh.colors = myColors;
		mesh.SetIndices(indecies, MeshTopology.Points,0);
		mesh.uv = new Vector2[nPoints];
		mesh.normals = myNormals;
        mesh.bounds = new Bounds(center, size);
        return mesh;
	}
	
	Mesh CreateNormalsMesh(int id, int nPoints, int limitPoints){
		Mesh mesh = new Mesh();
        Vector3[] myPoints = new Vector3[nPoints*2];
        Vector3[] myNormals = new Vector3[nPoints*2];
        int[] myLines = new int[nPoints*2];
        Color[] myColors = new Color[nPoints*2];

        for (int i = 0; i < nPoints; ++i)
        {
            int meshPtIndice = i * 2;
            
            myColors[meshPtIndice] = Color.blue;
            myColors[meshPtIndice + 1] = Color.red;

            myNormals[meshPtIndice] = normals[id * limitPoints + i];
            myNormals[meshPtIndice + 1] = myNormals[meshPtIndice];

            myPoints[meshPtIndice] = (points[id * limitPoints + i] - center);
            myPoints[meshPtIndice+1] = myPoints[meshPtIndice] + myNormals[meshPtIndice]* normalsScale;
			
			myLines[meshPtIndice] = meshPtIndice;
            myLines[meshPtIndice + 1] = meshPtIndice + 1;
        }
        mesh.vertices = myPoints;
        //mesh.normals = myNormals;
        mesh.SetIndices(myLines, MeshTopology.Lines, 0);
        mesh.colors = myColors;
        mesh.uv = new Vector2[nPoints * 2];
        //mesh.RecalculateNormals();
        mesh.bounds = new Bounds(center, size);
        return mesh;
    }
    
   Mesh CreateFacesMesh(int id, int nPoints, int limitPoints)
    {
        
        Mesh mesh = new Mesh();
        Vector3[] myPoints = new Vector3[nPoints*4];
        Vector3[] myNormals = new Vector3[nPoints*4];
        int[] myTriangles = new int[nPoints*6];
        Color[] myColors = new Color[nPoints*4];

        for (int i = 0; i < nPoints; ++i)
        {
            int meshPtIndice = i * 4;
            
            myColors[meshPtIndice] = colors[id * limitPoints + i];
            myColors[meshPtIndice + 1] = myColors[meshPtIndice];
            myColors[meshPtIndice + 2] = myColors[meshPtIndice];
            myColors[meshPtIndice + 3] = myColors[meshPtIndice];

            myNormals[meshPtIndice] = normals[id * limitPoints + i];
            myNormals[meshPtIndice + 1] = myNormals[meshPtIndice];
            myNormals[meshPtIndice + 2] = myNormals[meshPtIndice];
            myNormals[meshPtIndice + 3] = myNormals[meshPtIndice];

            Vector3 ptCenter = (points[id * limitPoints + i] - center);
            Quaternion faceToNormal = Quaternion.FromToRotation(Vector3.down, myNormals[meshPtIndice]);
            //Debug.Log("normal: "+ myNormals[meshPtIndice]+ "rot[" + meshPtIndice + "] : " + faceToNormal);
            myPoints[meshPtIndice] = faceToNormal * (new Vector3(-faceSize,0, -faceSize)) + ptCenter;
            //Debug.Log("from " + ((new Vector3(-faceSize, 0, -faceSize)) + ptCenter) + " to " + myPoints[meshPtIndice]);
            myPoints[meshPtIndice+1] = faceToNormal * (new Vector3(faceSize,0, -faceSize)) + ptCenter;
            myPoints[meshPtIndice+2] = faceToNormal * (new Vector3(faceSize, 0, faceSize)) + ptCenter;
            myPoints[meshPtIndice+3] = faceToNormal * (new Vector3(-faceSize, 0, faceSize)) + ptCenter;

            //{ 0, 1, 2, 0, 2, 3 };
            int meshTrIndice = i * 6;
            myTriangles[meshTrIndice] = meshPtIndice;
            myTriangles[meshTrIndice + 1] = meshPtIndice + 1;
            myTriangles[meshTrIndice + 2] = meshPtIndice + 2;
            myTriangles[meshTrIndice + 3] = meshPtIndice;
            myTriangles[meshTrIndice + 4] = meshPtIndice + 2;
            myTriangles[meshTrIndice + 5] = meshPtIndice + 3;
            //Debug.Log("triangles[" + meshTrIndice + "] : " + myPoints[myTriangles[meshTrIndice]] + ", " + myPoints[myTriangles[meshTrIndice + 1]] + ", " + myPoints[myTriangles[meshTrIndice + 2]]);
            //Debug.Log("triangles[" + meshTrIndice + 3 + "] : " + myPoints[myTriangles[meshTrIndice]] + ", " + myPoints[myTriangles[meshTrIndice + 2]] + ", " + myPoints[myTriangles[meshTrIndice + 3]]);

        }
        mesh.vertices = myPoints;
        mesh.normals = myNormals;//new Vector3[nPoints * 4];
        mesh.triangles = myTriangles;
        //mesh.SetIndices(triangles, MeshTopology.Triangles, 0);
        mesh.colors = myColors;
        mesh.uv = new Vector2[nPoints * 4];
        mesh.bounds = new Bounds(center, size);
        
        return mesh;
    }
    
    void calculateMinMax(Vector3 point){
		if (minValue.magnitude == 0)
			minValue = point;
        if (maxValue.magnitude == 0)
            maxValue = point;


        if (point.x < minValue.x)
			minValue.x = point.x;
		if (point.y < minValue.y)
			minValue.y = point.y;
		if (point.z < minValue.z)
			minValue.z = point.z;

        if (point.x > maxValue.x)
            maxValue.x = point.x;
        if (point.y > maxValue.y)
            maxValue.y = point.y;
        if (point.z > maxValue.z)
            maxValue.z = point.z;
    }

	void createFolders(){
		if(!Directory.Exists (Application.dataPath + "/Resources/"))
			UnityEditor.AssetDatabase.CreateFolder ("Assets", "Resources");

		if (!Directory.Exists (Application.dataPath + "/Resources/PointCloudMeshes/"))
			UnityEditor.AssetDatabase.CreateFolder ("Assets/Resources", "PointCloudMeshes");
	}


	void OnGUI(){

		if (!loaded){
			GUI.BeginGroup (new Rect(Screen.width/2-100, Screen.height/2, 400.0f, 20));
			GUI.Box (new Rect (0, 0, 200.0f, 20.0f), guiText);
			GUI.Box (new Rect (0, 0, progress*200.0f, 20), "");
			GUI.EndGroup ();
		}
	}

    Mesh makeCube(Vector3 pos, Vector3 size)   {
        Mesh mesh = new Mesh();

        #region Vertices
        Vector3 p0 = new Vector3(-size.x * .5f, -size.y * .5f, size.z * .5f)+pos;
        Vector3 p1 = new Vector3(size.x * .5f, -size.y * .5f, size.z * .5f) + pos;
        Vector3 p2 = new Vector3(size.x * .5f, -size.y * .5f, -size.z * .5f) + pos;
        Vector3 p3 = new Vector3(-size.x * .5f, -size.y * .5f, -size.z * .5f) + pos;

        Vector3 p4 = new Vector3(-size.x * .5f, size.y * .5f, size.z * .5f) + pos;
        Vector3 p5 = new Vector3(size.x * .5f, size.y * .5f, size.z * .5f) + pos;
        Vector3 p6 = new Vector3(size.x * .5f, size.y * .5f, -size.z * .5f) + pos;
        Vector3 p7 = new Vector3(-size.x * .5f, size.y * .5f, -size.z * .5f) + pos;

        Vector3[] vertices = new Vector3[]
        {
	// Bottom
	p0, p1, p2, p3,
 
	// Left
	p7, p4, p0, p3,
 
	// Front
	p4, p5, p1, p0,
 
	// Back
	p6, p7, p3, p2,
 
	// Right
	p5, p6, p2, p1,
 
	// Top
	p7, p6, p5, p4
        };
        #endregion

        #region Normales
        Vector3 up = Vector3.up;
        Vector3 down = Vector3.down;
        Vector3 front = Vector3.forward;
        Vector3 back = Vector3.back;
        Vector3 left = Vector3.left;
        Vector3 right = Vector3.right;

        Vector3[] normales = new Vector3[]
        {
	// Bottom
	down, down, down, down,
 
	// Left
	left, left, left, left,
 
	// Front
	front, front, front, front,
 
	// Back
	back, back, back, back,
 
	// Right
	right, right, right, right,
 
	// Top
	up, up, up, up
        };
        #endregion

        #region UVs
        Vector2 _00 = new Vector2(0f, 0f);
        Vector2 _10 = new Vector2(1f, 0f);
        Vector2 _01 = new Vector2(0f, 1f);
        Vector2 _11 = new Vector2(1f, 1f);

        Vector2[] uvs = new Vector2[]
        {
	// Bottom
	_11, _01, _00, _10,
 
	// Left
	_11, _01, _00, _10,
 
	// Front
	_11, _01, _00, _10,
 
	// Back
	_11, _01, _00, _10,
 
	// Right
	_11, _01, _00, _10,
 
	// Top
	_11, _01, _00, _10,
        };
        #endregion

        #region Triangles
        int[] triangles = new int[]
        {
	// Bottom
	3, 1, 0,
    3, 2, 1,			
 
	// Left
	3 + 4 * 1, 1 + 4 * 1, 0 + 4 * 1,
    3 + 4 * 1, 2 + 4 * 1, 1 + 4 * 1,
 
	// Front
	3 + 4 * 2, 1 + 4 * 2, 0 + 4 * 2,
    3 + 4 * 2, 2 + 4 * 2, 1 + 4 * 2,
 
	// Back
	3 + 4 * 3, 1 + 4 * 3, 0 + 4 * 3,
    3 + 4 * 3, 2 + 4 * 3, 1 + 4 * 3,
 
	// Right
	3 + 4 * 4, 1 + 4 * 4, 0 + 4 * 4,
    3 + 4 * 4, 2 + 4 * 4, 1 + 4 * 4,
 
	// Top
	3 + 4 * 5, 1 + 4 * 5, 0 + 4 * 5,
    3 + 4 * 5, 2 + 4 * 5, 1 + 4 * 5,

        };
        #endregion

        mesh.vertices = vertices;
        mesh.normals = normales;
        mesh.uv = uvs;
        mesh.triangles = triangles;
        return mesh;

    }

}
