// Credit for this script to Brian Hansens

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrAudioReact : MonoBehaviour
{
    public Light lt;
	public float threshold = 0;
	public float lightIntensityFull = 0;
	private float lightIntensityDest = 0;

    // Start is called before the first frame update
    void Start()
    {
        lt = GetComponent<Light>();
    }

    // Update is called once per frame
    void Update()
    {
        // --------------------------------------------------------
		// ------- animate the cube size based on spectrum data.

		// consolidate spectral data to 8 partitions (1 partition for each rotating cube)
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

		if (mag > threshold) {
			lightIntensityDest = lightIntensityFull;
		}
		else {
			lightIntensityDest = 0;
		}

		if (lt.intensity < lightIntensityDest) {
			lt.intensity += Mathf.Abs(lt.intensity - lightIntensityDest) / 12;
		}
		else if (lt.intensity > lightIntensityDest) {
			lt.intensity -= Mathf.Abs(lt.intensity - lightIntensityDest) / 12;
		}


		// --------- End animating cube via spectral data
		// --------------------------------------------------------

    }
}
