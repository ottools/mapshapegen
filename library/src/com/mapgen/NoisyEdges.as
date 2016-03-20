// Annotate each edge with a noisy path, to make maps look more interesting.
// Author: amitp@cs.stanford.edu
// License: MIT

package com.mapgen
{
    import com.mapgen.graph.Center;
    import com.mapgen.graph.Edge;

    import flash.geom.Point;

    import de.polygonal.math.PM_PRNG;

    public class NoisyEdges
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------

        public var path0:Array;  // edge index -> Vector.<Point>
        public var path1:Array;  // edge index -> Vector.<Point>

        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function NoisyEdges()
        {
            this.path0 = [];
            this.path1 = [];
        }

        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------

        //--------------------------------------
        // Public
        //--------------------------------------

        // Build noisy line paths for each of the Voronoi edges. There are
        // two noisy line paths for each edge, each covering half the
        // distance: path0 is from v0 to the midpoint and path1 is from v1
        // to the midpoint. When drawing the polygons, one or the other
        // must be drawn in reverse order.
        public function buildNoisyEdges(map:Map, random:PM_PRNG):void
        {
            for each (var p:Center in map.centers)
            {
                for each (var edge:Edge in p.borders)
                {
                    if (edge.d0 && edge.d1 && edge.v0 && edge.v1 && !this.path0[edge.index])
                    {
                        var f:Number = NOISY_LINE_TRADEOFF;
                        var t:Point = Point.interpolate(edge.v0.point, edge.d0.point, f);
                        var q:Point = Point.interpolate(edge.v0.point, edge.d1.point, f);
                        var r:Point = Point.interpolate(edge.v1.point, edge.d0.point, f);
                        var s:Point = Point.interpolate(edge.v1.point, edge.d1.point, f);

                        var minLength:int = 10;
                        if (edge.d0.biome != edge.d1.biome)
                        {
                            minLength = 3;
                        }

                        if (edge.d0.ocean && edge.d1.ocean)
                        {
                            minLength = 100;
                        }

                        if (edge.d0.coast || edge.d1.coast)
                        {
                            minLength = 1;
                        }

                        if (edge.river)
                        {
                            minLength = 1;
                        }

                        this.path0[edge.index] = buildNoisyLineSegments(random, edge.v0.point, t, edge.midpoint, q, minLength);
                        this.path1[edge.index] = buildNoisyLineSegments(random, edge.v1.point, s, edge.midpoint, r, minLength);
                    }
                }
            }
        }

        public function clear():void
        {
            this.path0 = [];
            this.path1 = [];
        }

        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------

        static private var NOISY_LINE_TRADEOFF:Number = 0.5;  // low: jagged vedge; high: jagged dedge

        // Helper function: build a single noisy line in a quadrilateral A-B-C-D,
        // and store the output points in a Vector.
        static private function buildNoisyLineSegments(random:PM_PRNG, A:Point, B:Point, C:Point, D:Point, minLength:Number):Vector.<Point>
        {
            function subdivide(A:Point, B:Point, C:Point, D:Point):void
            {
                if (A.subtract(C).length < minLength || B.subtract(D).length < minLength)
                {
                    return;
                }

                // Subdivide the quadrilateral
                var p:Number = random.nextDoubleRange(0.2, 0.8);  // vertical (along A-D and B-C)
                var q:Number = random.nextDoubleRange(0.2, 0.8);  // horizontal (along A-B and D-C)

                // Midpoints
                var E:Point = Point.interpolate(A, D, p);
                var F:Point = Point.interpolate(B, C, p);
                var G:Point = Point.interpolate(A, B, q);
                var I:Point = Point.interpolate(D, C, q);

                // Central point
                var H:Point = Point.interpolate(E, F, q);

                // Divide the quad into subquads, but meet at H
                var s:Number = 1.0 - random.nextDoubleRange(-0.4, +0.4);
                var t:Number = 1.0 - random.nextDoubleRange(-0.4, +0.4);

                subdivide(A, Point.interpolate(G, B, s), H, Point.interpolate(E, D, t));
                points[points.length] = H;
                subdivide(H, Point.interpolate(F, C, s), C, Point.interpolate(I, D, t));
            }

            var points:Vector.<Point> = new Vector.<Point>();
            points[points.length] = A;
            subdivide(A, B, C, D);
            points[points.length] = C;
            return points;
        }
    }
}
