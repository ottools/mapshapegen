package com.mapgen
{
    import com.mignari.errors.AbstractClassError;
    import com.mignari.utils.StringUtil;

    public final class IslandType
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function IslandType()
        {
            throw new AbstractClassError(IslandType);
        }

        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------

        static public const PERLIN:String = "perlin";
        static public const RADIAL:String = "radial";

        static public function value(index:int):String
        {
            switch(index)
            {
                case 0: return PERLIN;
                case 1: return RADIAL;
            }

            return PERLIN;
        }

        static public function index(value:String):int
        {
            switch(StringUtil.toKeyString(value))
            {
                case PERLIN: return 0;
                case RADIAL: return 1;
            }

            return 0;
        }
    }
}
