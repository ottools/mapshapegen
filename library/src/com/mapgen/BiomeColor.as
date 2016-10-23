// Author: amitp@cs.stanford.edu
// Author: nailsonnego@gmail.com
// License: MIT

package com.mapgen
{
    import com.mignari.errors.AbstractClassError;

    public final class BiomeColor
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function BiomeColor()
        {
            throw new AbstractClassError(BiomeColor);
        }

        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------

        static public const WATER:uint = 0x336699;
        static public const SAND:uint = 0xffCC99;
        static public const GRASS:uint = 0x00CC00;
    }
}
