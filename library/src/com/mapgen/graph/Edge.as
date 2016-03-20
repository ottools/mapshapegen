package com.mapgen.graph
{
    import flash.geom.Point;

    public class Edge
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------

        public var index:int;

        // Delaunay edge
        public var d0:Center;
        public var d1:Center;

        // Voronoi edge
        public var v0:Corner
        public var v1:Corner;

        // halfway between v0,v1
        public var midpoint:Point;

        // volume of water, or 0
        public var river:int;
    }
}
