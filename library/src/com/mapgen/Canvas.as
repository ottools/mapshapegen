package com.mapgen
{
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;

    public class Canvas
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------

        private var m_bitmap:BitmapData;
        private var m_rect:Rectangle;

        //--------------------------------------
        // Getters / Setters
        //--------------------------------------

        public function get bitmap():BitmapData { return m_bitmap; }

        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function Canvas(width:int, height:int)
        {
            m_bitmap = new BitmapData(width, height, true, 0);
            m_rect = new Rectangle(0, 0, width, height);
        }

        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------

        //--------------------------------------
        // Public
        //--------------------------------------

        public function draw(generator:Generator):void
        {
            m_bitmap.draw(generator);
        }

        public function copyFromByteArray(input:ByteArray):void
        {
            input.position = 0;
            m_bitmap.setPixels(m_rect, input);
        }

        public function copyToByteArray(output:ByteArray):void
        {
            output.position = 0;
            m_bitmap.copyPixelsToByteArray(m_rect, output);
        }

        public function clear():void
        {
            m_bitmap.fillRect(m_rect, 0);
        }
    }
}
