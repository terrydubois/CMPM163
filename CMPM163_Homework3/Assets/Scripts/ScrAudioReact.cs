// Credit to Brian Hansen for first part of this script

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrAudioReact : MonoBehaviour
{
    public Light lt;
	public float threshold = 0;
	public float lightIntensityFull = 0;
	private float lightIntensityDest = 0;

    void Start()
    {
        lt = GetComponent<Light>();
    }

    void Update()
    {
		int numPartitions = 8;
		float[] aveMag = new float[numPartitions];
		float partitionIndx = 0;
		int numDisplayedBins = 512 / 2; //NOTE: we only display half the spectral data because the max displayable frequency is Nyquist (at half the num of bins)

		for (int i = 0; i < numDisplayedBins; i++) 
		{
			if(i < numDisplayedBins * (partitionIndx + 1) / numPartitions){
				aveMag[(int)partitionIndx] += ScrAudioPeer.spectrumData [i] / (512/numPartitions);
			}
			else{
				partitionIndx++;
				i--;
			}
		}

		// scale and bound the average magnitude.
		for(int i = 0; i < numPartitions; i++)
		{
			aveMag[i] = (float)0.5 + aveMag[i]*100;
			if (aveMag[i] > 100) {
				aveMag[i] = 100;
			}
		}

		// Map the magnitude to the cubes based on the cube name.
        //transform.localScale = new Vector3 (aveMag[0], aveMag[0], aveMag[0]);
		float mag = aveMag[0];


		// if magnitude is above threshold, light will try to reach maximum intensity
		// otherwise light will go for 0 intensity
		if (mag > threshold) {
			lightIntensityDest = lightIntensityFull;
		}
		else {
			lightIntensityDest = 0;
		}

		// have the intensity reach its destination smoothly
		if (lt.intensity < lightIntensityDest) {
			lt.intensity += Mathf.Abs(lt.intensity - lightIntensityDest) / 12;
		}
		else if (lt.intensity > lightIntensityDest) {
			lt.intensity -= Mathf.Abs(lt.intensity - lightIntensityDest) / 12;
		}
    }
}
