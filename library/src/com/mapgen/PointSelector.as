package com.mapgen
{
    import com.nodename.Delaunay.Voronoi;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    import de.polygonal.math.PM_PRNG;

    internal final class PointSelector
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function PointSelector()
        {
            ////
        }

        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------

        static public var NUM_LLOYD_RELAXATIONS:int = 2;
        
        // The square and hex grid point selection remove randomness from
        // where the points are; we need to inject more randomness elsewhere
        // to make the maps look better. I do this in the corner
        // elevations. However I think more experimentation is needed.
        static public function needsMoreRandomness(type:String):Boolean
        {
            return type == PointType.SQUARE || type == PointType.HEXAGON;
        }

        // Generate points at random locations
        static public function generateRandom(size:int, seed:int):Function
        {
            return function(numPoints:int):Vector.<Point>
            {
                var mapRandom:PM_PRNG = new PM_PRNG();
                mapRandom.seed = seed;

                var points:Vector.<Point> = new Vector.<Point>(numPoints, true);
                for (var i:int = 0; i < numPoints; i++)
                {
                    var point:Point = new Point(mapRandom.nextDoubleRange(10, size - 10),
                                                mapRandom.nextDoubleRange(10, size - 10));
                    points[i] = point;
                }

                return points;
            }
        }

        // Improve the random set of points with Lloyd Relaxation
        static public function generateRelaxed(size:int, seed:int):Function
        {
            return function(numPoints:int):Vector.<Point>
            {
                // We'd really like to generate "blue noise". Algorithms:
                // 1. Poisson dart throwing: check each new point against all
                //     existing points, and reject it if it's too close.
                // 2. Start with a hexagonal grid and randomly perturb points.
                // 3. Lloyd Relaxation: move each point to the centroid of the
                //     generated Voronoi polygon, then generate Voronoi again.
                // 4. Use force-based layout algorithms to push points away.
                // 5. More at http://www.cs.virginia.edu/~gfx/pubs/antimony/
                // Option 3 is implemented here. If it's run for too many iterations,
                // it will turn into a grid, but convergence is very slow, and we only
                // run it a few times.

                var points:Vector.<Point> = generateRandom(size, seed)(numPoints);
                for (var i:int = 0; i < NUM_LLOYD_RELAXATIONS; i++)
                {
                    var voronoi:Voronoi = new Voronoi(points, null, new Rectangle(0, 0, size, size));
                    for each (var p:Point in points)
                    {
                        var region:Vector.<Point> = voronoi.region(p);
                        p.x = 0.0;
                        p.y = 0.0;

                        for each (var q:Point in region)
                        {
                            p.x += q.x;
                            p.y += q.y;
                        }

                        p.x /= region.length;
                        p.y /= region.length;
                        region.splice(0, region.length);
                    }

                    voronoi.dispose();
                }

                return points;
            }
        }

        // Generate points on a square grid
        static public function generateSquare(size:int, seed:int):Function
        {
            return function(numPoints:int):Vector.<Point>
            {
                numPoints = Math.sqrt(numPoints);

                var points:Vector.<Point> = new Vector.<Point>();
                for (var x:int = 0; x < numPoints; x++)
                {
                    for (var y:int = 0; y < numPoints; y++)
                    {
                        points[points.length] = new Point((0.5 + x) / numPoints * size, (0.5 + y) / numPoints * size);
                    }
                }

                return points;
            }
        }

        // Generate points on a hexagon grid
        static public function generateHexagon(size:int, seed:int):Function
        {
            return function(numPoints:int):Vector.<Point>
            {
                numPoints = Math.sqrt(numPoints);
                
                var points:Vector.<Point> = new Vector.<Point>();
                for (var x:int = 0; x < numPoints; x++)
                {
                    for (var y:int = 0; y < numPoints; y++)
                    {
                        points[points.length] = new Point((0.5 + x) / numPoints * size, (0.25 + 0.5 * x % 2 + y) / numPoints * size);
                    }
                }

                return points;
            }
        }
    }
}
