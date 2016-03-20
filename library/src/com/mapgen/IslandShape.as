package com.mapgen
{
    import flash.display.BitmapData;
    import flash.geom.Point;
    
    import de.polygonal.math.PM_PRNG;
    
    // This class has factory functions for generating islands of
    // different shapes. The factory returns a function that takes a
    // normalized point (x and y are -1 to +1) and returns true if the
    // point should be on the island, and false if it should be water
    // (lake or ocean).
    internal final class IslandShape
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function IslandShape()
        {
            ////
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        // The radial island radius is based on overlapping sine waves 
        static public var ISLAND_FACTOR:Number = 1.07;  // 1.0 means no small islands; 2.0 leads to a lot
        static public function makeRadial(seed:int):Function
        {
            var islandRandom:PM_PRNG = new PM_PRNG();
            islandRandom.seed = seed;
            var bumps:int = islandRandom.nextIntRange(1, 6);
            var startAngle:Number = islandRandom.nextDoubleRange(0, 2*Math.PI);
            var dipAngle:Number = islandRandom.nextDoubleRange(0, 2*Math.PI);
            var dipWidth:Number = islandRandom.nextDoubleRange(0.2, 0.7);
            
            function inside(q:Point):Boolean
            {
                var angle:Number = Math.atan2(q.y, q.x);
                var length:Number = 0.5 * (Math.max(Math.abs(q.x), Math.abs(q.y)) + q.length);
                
                var r1:Number = 0.5 + 0.40*Math.sin(startAngle + bumps*angle + Math.cos((bumps+3)*angle));
                var r2:Number = 0.7 - 0.20*Math.sin(startAngle + bumps*angle - Math.sin((bumps+2)*angle));
                if (Math.abs(angle - dipAngle) < dipWidth
                    || Math.abs(angle - dipAngle + 2*Math.PI) < dipWidth
                    || Math.abs(angle - dipAngle - 2*Math.PI) < dipWidth) {
                    r1 = r2 = 0.2;
                }
                
                return  (length < r1 || (length > r1*ISLAND_FACTOR && length < r2));
            }
            
            return inside;
        }
        
        
        // The Perlin-based island combines perlin noise with the radius
        static public function makePerlin(seed:int):Function
        {
            var perlin:BitmapData = new BitmapData(256, 256);
            perlin.perlinNoise(64, 64, 8, seed, false, true);
            
            return function (q:Point):Boolean {
                var c:Number = (perlin.getPixel(int((q.x+1)*128), int((q.y+1)*128)) & 0xff) / 255.0;
                return c > (0.3+0.3*q.length*q.length);
            };
        }
    }
}
