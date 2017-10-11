/*
 * GrassGrowth PNG Loader
 */

#include "LoaderColors.as";
#include "BasePNGLoader.as";




namespace GrassGrowth {

  //Enumeration used when storing special offsets when loading a map (extends enumeration in BasePNGLoader.as)
  enum GrassGrowthPNGLoaderOffset {
    GRASSGROWTH_CANDIDATE = offsets_count + 1 //Sky tiles (for post-stage check for grass growth)
    , GRASSGROWTH_OFFSETS_COUNT               //End reference
  };

  class GrassGrowthPNGLoader : ::PNGLoader {
  
  
  
    //Keep an array of grass candidate tile offsets
    int[] mGrassCandidateOffsets;
    
    
    
    GrassGrowthPNGLoader()    {

      super();
      
      //Extend super class' offset reference array with any custom ones
      int offsetsCountDiff = GRASSGROWTH_OFFSETS_COUNT - offsets_count;
      while (offsetsCountDiff -- > 0) {
        offsets.push_back(array<int>(0));
      }
    
    } //End constructor
    
    
    
    bool loadMap(CMap@ map, const string& in filename) override {

      bool result = false;
    
      //Call super class' version of this method
      result = PNGLoader::loadMap(map, filename);
    
      //Store grass candidate tile offsets
      map.set("grassCandidateOffsets", mGrassCandidateOffsets);

      //Finished, return result
      return result;
    
    } //End method
    
    
    
    void handlePixel(SColor color_pixel, int offset) override {

      //Call super class' version of this method, to make sure we don't miss out on any default behaviour
      PNGLoader::handlePixel(color_pixel, offset);
    
      //Check if empty/sky
      if(color_pixel == sky || color_pixel == color_tile_grass) {
    
        offsets[GRASSGROWTH_CANDIDATE].push_back(offset);                //Store offset reference
      
      }
    
      //Finished
      return;
    
    } //End method
    
    
    
    void handleOffset(int type, int offset, int position, int count) override {

      //Call super class' version of this method, to make sure we don't miss out on any default behaviour
      PNGLoader::handleOffset(type, offset, position, count);
    
      //If grass candidate
      if(type == GRASSGROWTH_CANDIDATE) {
    
        //Determine offset number for tile below
        int belowOffset = offset + map.tilemapwidth;
      
        //Determine offset number for the very last tile in the map
        int lastOffset = map.tilemapwidth * map.tilemapheight - 1;
      
        //Check if tile below is dirt/ground
        if(belowOffset <= lastOffset && map.getTile(belowOffset).type == CMap::tile_ground) {
      
          //Add this tile's offset
          mGrassCandidateOffsets.push_back(offset);
        
        }
      
      }
    
      //Finished
      return;
    
    } //End method
    
    
    
  } //End class
  
} //End namespace