// Author: nailsonnego@gmail.com
// License: MIT

package com.mapgen.settings
{
    import com.mapgen.IslandType;
    import com.mapgen.PointType;
    import com.mignari.settings.Settings;

    import flash.filesystem.File;

    public class MapShapeGenSettings extends Settings
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------

        public var maximized:Boolean = true;

        public var islandType:String = IslandType.PERLIN;
        public var pointType:String = PointType.RELAXED;
        public var showBeach:Boolean = true;
        public var showRivers:Boolean = true;

        public var waterItem:uint = 4608;
        public var sandItem:uint = 231;
        public var grassItem:uint = 106;

        public var ouputDirectory:File = null;
        public var savePNG:Boolean = true;
        public var version:uint = 57;

        public var mapName:String = "Untitled";
        public var mapWidth:uint = 512;
        public var mapHeight:uint = 512;

        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function MapShapeGenSettings()
        {
            super();
        }
    }
}
