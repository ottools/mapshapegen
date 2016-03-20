package com.mapgen.utils
{
    public final class Version
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------

        public var label:String;
        public var otb:uint;

        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function Version(label:String, otb:uint)
        {
            this.label = label;
            this.otb = otb;
        }
    }
}
