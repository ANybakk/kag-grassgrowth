/*
 * GrassGrowth Map
 */

#include "GrassGrowthPNGLoader.as";



void onInit(CMap@ this) {

  this.set_u32("nextGrassCandidateIndex", 0);
  
}



void onTick(CMap@ this) {

  //Retrieve all grass candidate offsets
  int[] grassCandidateOffsets;
  this.get("grassCandidateOffsets", grassCandidateOffsets);
  
  //Retrive next candidate index
  u32 nextGrassCandidateIndex = this.get_u32("nextGrassCandidateIndex");
  
  //Find next offset
  int nextOffset = grassCandidateOffsets[nextGrassCandidateIndex];
  
  //Find tile
  Tile tile = this.getTile(nextOffset);
  
  //Check if grass type and not yet fully grown (Thank you, Geti)
  if(this.isTileGrass(tile.type) && tile.type != CMap::tile_grass) {
  
    //Get position
    Vec2f position = this.getTileWorldPosition(nextOffset);
    
    //Grow grass (grass tiles are in decreasing order)
    this.server_SetTile(position, tile.type - 1);
    
  }
  
  //Increment
  nextGrassCandidateIndex++;
  
  //Start over if end is reached
  if(nextGrassCandidateIndex > grassCandidateOffsets.length - 1) {
    nextGrassCandidateIndex = 0;
  }
  
  //Update index
  this.set_u32("nextGrassCandidateIndex", nextGrassCandidateIndex);
  
}



bool LoadMap(CMap@ this, const string& in fileName) {

  GrassGrowth::GrassGrowthPNGLoader loader();
  
  return loader.loadMap(this, fileName);
  
}