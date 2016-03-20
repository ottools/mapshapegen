/*
* Copyright (c) 2015 Nailson Santos <nailsonnego@gmail.com>
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at 
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
* either express or implied. See the License for the specific language
* governing permissions and limitations under the License.
*/

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
