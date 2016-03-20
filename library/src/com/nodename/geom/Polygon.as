package com.nodename.geom
{
    import flash.geom.Point;

    public final class Polygon
    {
        private var m_vertices:Vector.<Point>;
        
        public function Polygon(vertices:Vector.<Point>)
        {
            m_vertices = vertices;
        }
        
        public function area():Number
        {
            return Math.abs(signedDoubleArea() * 0.5);
        }
        
        public function winding():String
        {
            var signedDoubleArea:Number = this.signedDoubleArea();
            if (signedDoubleArea < 0)
            {
                return Winding.CLOCKWISE;
            }
            
            if (signedDoubleArea > 0)
            {
                return Winding.COUNTERCLOCKWISE;
            }
            
            return Winding.NONE;
        }
        
        private function signedDoubleArea():Number
        {
            var index:uint, nextIndex:uint;
            var n:uint = m_vertices.length;
            var point:Point, next:Point;
            var signedDoubleArea:Number = 0;
            for (index = 0; index < n; ++index)
            {
                nextIndex = (index + 1) % n;
                point = m_vertices[index] as Point;
                next = m_vertices[nextIndex] as Point;
                signedDoubleArea += point.x * next.y - next.x * point.y;
            }
            return signedDoubleArea;
        }
    }
}
