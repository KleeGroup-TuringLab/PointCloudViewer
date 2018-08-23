using UnityEngine;
using System.Collections;

public class WandController : MonoBehaviour {
    private Valve.VR.EVRButtonId gripButton = Valve.VR.EVRButtonId.k_EButton_Grip;
    private Valve.VR.EVRButtonId triggerButton = Valve.VR.EVRButtonId.k_EButton_SteamVR_Trigger;

    private SteamVR_Controller.Device controller { get { return SteamVR_Controller.Input((int)trackedObj.index); } }
    private SteamVR_TrackedObject trackedObj;

    private GameObject pickup;
    public GameObject player;

    public Material onSelect;
    public Material onUnselect;

    private bool trackingSwipe = false;
    private float speed = 0;
	private float scale = 1;
    private float previsousTrack = 0;
    public float maxSpeed = 20f;

    // Use this for initialization
    void Start () {
        trackedObj = GetComponent<SteamVR_TrackedObject>();
    }
	
	// Update is called once per frame
	void Update () {
	    if (controller == null) {
            Debug.Log("Controller not initialized");
            return;
        }

        if (controller.GetPressDown(triggerButton)) {
            speed = 0.01f;
        }
        if (controller.GetPressUp(triggerButton))        {
            speed = 0f;
        }
        if (speed > 0.00001f) {
            Vector3 dir = Quaternion.Euler(controller.transform.rot.eulerAngles) * Vector3.forward;
            player.transform.position += dir * speed * Time.deltaTime;
            speed += 0.01f;
            if(speed > maxSpeed) {
                speed = maxSpeed;
            }
        }
        if (controller.GetPressDown(gripButton) && pickup != null) {
            pickup.transform.parent = this.transform;
            // pickup.GetComponent<Rigidbody>().useGravity = false;
        }
        if (controller.GetPressUp(gripButton) && pickup != null) {
            pickup.transform.parent = null;
         //   pickup.GetComponent<Rigidbody>().useGravity = true;
        }
		
		
		//Test swipe
		if ((int)trackedObj.index != -1 && controller.GetTouchDown (Valve.VR.EVRButtonId.k_EButton_Axis0) && pickup != null) {
			trackingSwipe = true;
			// Record start time and position
			previsousTrack = controller.GetAxis(Valve.VR.EVRButtonId.k_EButton_Axis0).y;
			//print("trackingSwipe "+trackingSwipe);
		}
		// Touch up , possible chance for a swipe
		else if (controller.GetTouchUp (Valve.VR.EVRButtonId.k_EButton_Axis0)) {
			trackingSwipe = false;
			//print("trackingSwipe "+trackingSwipe);
		} else if(trackingSwipe && pickup != null) {
			float deltaScale = controller.GetAxis (Valve.VR.EVRButtonId.k_EButton_Axis0).y - previsousTrack;
			//print("deltaScale "+deltaScale);
			if(	deltaScale > 0.1 || deltaScale < -0.1) {
                deltaScale *= 0.1f;
                pickup.transform.localScale = pickup.transform.localScale*(1+deltaScale);
                Vector3 posDelta = pickup.transform.position -  this.transform.position ;
                pickup.transform.position = this.transform.position + posDelta*(1 + deltaScale);

            } 
        }		
	}

    private void OnTriggerEnter(Collider collider) {
        pickup = collider.gameObject;
        pickup.GetComponent<MeshRenderer>().material = onSelect;

    }

    private void OnTriggerExit(Collider collider) {
        pickup.GetComponent<MeshRenderer>().material = onUnselect;
        trackingSwipe = false;
        pickup.transform.parent = null;
        pickup = null;
    }
}
