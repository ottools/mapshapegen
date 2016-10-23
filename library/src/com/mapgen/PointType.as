// Author: amitp@cs.stanford.edu
// Author: nailsonnego@gmail.com
// License: MIT

package com.mapgen
{
    import com.mignari.errors.AbstractClassError;
    import com.mignari.utils.StringUtil;

    public final class PointType
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function PointType()
        {
            throw new AbstractClassError(PointType);
        }

        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------

        static public const RELAXED:String = "relaxed";
        static public const RANDOM:String = "random";
        static public const SQUARE:String = "square";
        static public const HEXAGON:String = "hexagon";

        static public function value(index:int):String
        {
            switch(index)
            {
                case 0: return RELAXED;
                case 1: return RANDOM;
                case 2: return SQUARE;
                case 3: return HEXAGON;
            }

            return RELAXED;
        }

        static public function index(value:String):int
        {
            switch(StringUtil.toKeyString(value))
            {
                case RELAXED: return 0;
                case RANDOM: return 1;
                case SQUARE: return 2;
                case HEXAGON: return 3;
            }

            return 0;
        }
    }
}
