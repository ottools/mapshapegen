package com.nodename.geom
{
    import com.mignari.errors.AbstractClassError;

    public final class Winding
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function Winding()
        {
            throw new AbstractClassError(Winding);
        }

        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------

        static public const NONE:String = "none";
        static public const CLOCKWISE:String = "clockwise";
        static public const COUNTERCLOCKWISE:String = "counterclockwise"
    }
}
