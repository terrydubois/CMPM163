/*
Following tutorial: https://www.youtube.com/watch?v=dycHQFEz8VI
*/

using System.Collections;
using System.Collections.Generic;
using UnityEngine;


// define simple class for terrain tiles
class Tile {
    public GameObject tile;
    public float createTime;

    public Tile(GameObject t, float ct) {
        tile = t;
        createTime = ct;
    }
}

public class ScrGenerateInfinite : MonoBehaviour
{
    public GameObject plane; // the prefab of the plane tile we will generate
    public GameObject player; // the object of the player to generate terrain around (the Main camera in our case)

    public int planeSize = 12;
    public int halfTilesX = 20;
    public int halfTilesZ = 20;

    public float tilesY = 0;

    Vector3 startPos;
    Hashtable tiles = new Hashtable();

    void Start()
    {
        // create grip map of tiles that will blend to make our terrain
        this.gameObject.transform.position = Vector3.zero;
        startPos = Vector3.zero;

        float updateTime = Time.realtimeSinceStartup;

        for (int x = -halfTilesX; x < halfTilesX; x++) {
            for (int z = -halfTilesZ; z < halfTilesZ; z++) {
                
                Vector3 pos = new Vector3((x * planeSize + startPos.x),
                                            tilesY,
                                            (z * planeSize + startPos.z));
                GameObject t = (GameObject) Instantiate(plane, pos, Quaternion.identity);

                string tilename = "Tile_" + ((int)(pos.x)).ToString() + "_" + ((int)(pos.z)).ToString();
                t.name = tilename;
                Tile tile = new Tile(t, updateTime);
                tiles.Add(tilename, tile);
            }
        }
    }

    void Update()
    {
        // as our camera moves, we generate surrounding terrain along with it
        // this creates an infinite terrain effect, as it will generate
        // ground below wherever the camera is

        int xMove = (int)(player.transform.position.x - startPos.x);
        int zMove = (int)(player.transform.position.z - startPos.z);

        if (Mathf.Abs(xMove) >= planeSize || Mathf.Abs(zMove) >= planeSize) {
            float updateTime = Time.realtimeSinceStartup;

            int playerX = (int)(Mathf.Floor(player.transform.position.x/planeSize) * planeSize);
            int playerZ = (int)(Mathf.Floor(player.transform.position.z/planeSize) * planeSize);

            for (int x = -halfTilesX; x < halfTilesX; x++) {
                for (int z = -halfTilesZ; z < halfTilesZ; z++) {
                    Vector3 pos = new Vector3((x * planeSize + playerX), 0, (z * planeSize + playerZ));
                    
                    string tilename = "Tile_" + ((int)(pos.x)).ToString() + "_" + ((int)(pos.z)).ToString();

                    if (tiles.ContainsKey(tilename)) {
                        (tiles[tilename] as Tile).createTime = updateTime;
                    }
                    else {
                        GameObject t = (GameObject) Instantiate(plane, pos, Quaternion.identity);

                        t.name = tilename;
                        Tile tile = new Tile(t, updateTime);
                        tiles.Add(tilename, tile);
                    }
                }
            }

            // add these terrain tiles to a hashtable
            Hashtable newTerrain = new Hashtable();
            foreach(Tile tiles_ in tiles.Values) {
                if (tiles_.createTime == updateTime) {
                    newTerrain.Add(tiles_.tile.name, tiles_);
                }
                else {
                    Destroy(tiles_.tile);
                }
            }

            tiles = newTerrain;
            startPos = player.transform.position;
        }

        

    }
}