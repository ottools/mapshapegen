package com.nodename.Delaunay
{
    import com.nodename.geom.Circle;
    import com.nodename.utils.IDisposable;

    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    internal final class SiteList implements IDisposable
    {
        private var m_sites:Vector.<Site>;
        private var m_currentIndex:uint;
        private var m_sorted:Boolean;

        public function SiteList()
        {
            m_sites = new Vector.<Site>();
            m_sorted = false;
        }

        public function dispose():void
        {
            if (m_sites)
            {
                for each (var site:Site in m_sites)
                {
                    site.dispose();
                }

                m_sites.length = 0;
                m_sites = null;
            }
        }

        public function push(site:Site):uint
        {
            m_sorted = false;
            return m_sites[m_sites.length] = site;
        }

        public function get length():uint
        {
            return m_sites.length;
        }

        public function next():Site
        {
            if (!m_sorted)
            {
                throw new Error("SiteList::next():  sites have not been sorted");
            }

            if (m_currentIndex < m_sites.length)
            {
                return m_sites[m_currentIndex++];
            }

            return null;
        }

        internal function getSitesBounds():Rectangle
        {
            if (!m_sorted)
            {
                Site.sortSites(m_sites);
                m_currentIndex = 0;
                m_sorted = true;
            }

            var xmin:Number, xmax:Number, ymin:Number, ymax:Number;
            if (m_sites.length == 0)
            {
                return new Rectangle(0, 0, 0, 0);
            }

            xmin = Number.MAX_VALUE;
            xmax = Number.MIN_VALUE;
            for each (var site:Site in m_sites)
            {
                if (site.x < xmin)
                {
                    xmin = site.x;
                }

                if (site.x > xmax)
                {
                    xmax = site.x;
                }
            }

            // here's where we assume that the sites have been sorted on y:
            ymin = m_sites[0].y;
            ymax = m_sites[m_sites.length - 1].y;
            return new Rectangle(xmin, ymin, xmax - xmin, ymax - ymin);
        }
        
        public function siteColors(referenceImage:BitmapData = null):Vector.<uint>
        {
            var colors:Vector.<uint> = new Vector.<uint>(m_sites.length, true);
            for (var i:uint = 0; i < length; i++)
            {
                var site:Site = m_sites[i];
                colors[i] = referenceImage ? referenceImage.getPixel(site.x, site.y) : site.color;
            }

            return colors;
        }

        public function siteCoords():Vector.<Point>
        {
            var coords:Vector.<Point> = new Vector.<Point>(m_sites.length, true);
            for (var i:uint = 0; i < length; i++)
            {
                coords[i] = m_sites[i].coord;
            }

            return coords;
        }

        /**
         * 
         * @return the largest circle centered at each site that fits in its region;
         * if the region is infinite, return a circle of radius 0.
         * 
         */
        public function circles():Vector.<Circle>
        {
            var circles:Vector.<Circle> = new Vector.<Circle>(m_sites.length, true);
            for (var i:uint = 0; i < length; i++)
            {
                var site:Site = m_sites[i];
                var radius:Number = 0;
                var nearestEdge:Edge = site.nearestEdge();

                //!nearestEdge.isPartOfConvexHull() && (radius = nearestEdge.sitesDistance() * 0.5);
                circles[i] = new Circle(site.x, site.y, radius);
            }

            return circles;
        }

        public function regions(plotBounds:Rectangle):Vector.<Vector.<Point>>
        {
            var regions:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>(m_sites, true);
            for (var i:uint = 0; i < length; i++)
            {
                regions[i] = m_sites[i].region(plotBounds);
            }

            return regions;
        }

        /**
         * 
         * @param proximityMap a BitmapData whose regions are filled with the site index values; see PlanePointsCanvas::fillRegions()
         * @param x
         * @param y
         * @return coordinates of nearest Site to (x, y)
         * 
         */
        public function nearestSitePoint(proximityMap:BitmapData, x:Number, y:Number):Point
        {
            var index:uint = proximityMap.getPixel(x, y);
            if (index > m_sites.length - 1)
            {
                return null;
            }

            return m_sites[index].coord;
        }
        
    }
}
