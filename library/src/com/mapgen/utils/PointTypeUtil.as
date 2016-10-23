// Author: amitp@cs.stanford.edu
// Author: nailsonnego@gmail.com
// License: MIT

package com.mapgen.utils
{
    import com.mignari.errors.AbstractClassError;

    import flash.geom.Point;

    public final class PointTypeUtil
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function PointTypeUtil()
        {
            throw new AbstractClassError(PointTypeUtil);
        }

        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------

        /**
         * Generate points on a hexagon grid.
         */
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
                        points[points.length] = new Point((0.5 + x)/numPoints * size, (0.25 + 0.5*x%2 + y)/numPoints * size);
                    }
                }

                return points;
            }
        }
    }
}
