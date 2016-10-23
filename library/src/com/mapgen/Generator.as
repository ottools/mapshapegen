// Draws the voronoi graph produced in Map.as
// Author: amitp@cs.stanford.edu
// Author: nailsonnego@gmail.com
// License: MIT

package com.mapgen
{
    import com.mapgen.graph.Center;
    import com.mapgen.graph.Edge;
    import com.mignari.errors.FileNotFoundError;
    import com.mignari.errors.NullArgumentError;
    import com.mignari.errors.NullOrEmptyArgumentError;
    import com.mignari.signals.ProgressSignal;
    import com.mignari.signals.Signal0;
    import com.mignari.utils.Color;
    import com.mignari.utils.StringUtil;
    import com.mignari.utils.isNullOrEmpty;

    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.geom.Point;
    import flash.utils.ByteArray;

    import mx.graphics.codec.PNGEncoder;

    import otlib.map.Tile;
    import otlib.otbm.OtbmWriter;
    import otlib.otml.OTMLDocument;

    public class Generator extends Sprite
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------

        private var m_name:String;
        private var m_width:uint;
        private var m_height:uint;
        private var m_islandSeed:String;
        private var m_islandType:String;
        private var m_pointType:String;

        private var m_mask:Shape;

        private var m_beachLayer:Shape;
        private var m_riversLayer:Shape;
        private var m_map:Map;
        private var m_noisyEdges:NoisyEdges;
        private var m_created:Boolean;
        private var m_saving:Boolean;

        private var m_changedSignal:Signal0;
        private var m_progressSignal:ProgressSignal;

        //--------------------------------------
        // Getters / Setters
        //--------------------------------------

        public function get created():Boolean { return m_created; }
        public function get changed():Boolean { return false; }
        public function get saving():Boolean { return m_saving; }

        public function get islandSeed():String { return m_islandSeed; }
        public function get islandType():String { return m_islandType; }
        public function get pointType():String { return m_pointType; }
        public function get beach():Boolean { return m_beachLayer.visible; }
        public function get rivers():Boolean { return m_riversLayer.visible; }

        public function get onChanged():Signal0 { return m_changedSignal; }
        public function get onProgress():ProgressSignal { return m_progressSignal; }

        override public function get name():String { return m_name; }
        override public function get width():Number { return m_width; }
        override public function get height():Number { return m_height; }

        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function Generator()
        {
            m_width = 512;
            m_height = 512;
            m_mask = new Shape();
            m_map = new Map(m_width, m_height);
            m_beachLayer = new Shape();
            addChild(m_beachLayer);
            m_riversLayer = new Shape();
            addChild(m_riversLayer);
            m_noisyEdges = new NoisyEdges();

            m_changedSignal = new Signal0();
            m_progressSignal = new ProgressSignal();

            this.mask = m_mask;
        }

        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------

        //--------------------------------------
        // Public
        //--------------------------------------

        public function load(file:File):void
        {
            if (!file)
            {
                throw new NullArgumentError("file");
            }

            if (!file.exists)
            {
                throw new FileNotFoundError(file);
            }

            if (file.extension != "otshape")
            {
                throw new ArgumentError("Invalid shape file extension.");
            }

            var doc:OTMLDocument = OTMLDocument.parse(file);

            create(doc.readAt("name", String),
                   doc.readAt("width", uint),
                   doc.readAt("height", uint),
                   doc.readAt("seed", String),
                   doc.readAt("island-type", String),
                   doc.readAt("point-type", String),
                   doc.readAt("beach", Boolean),
                   doc.readAt("rivers", Boolean));
        }

        public function create(name:String,
                               width:uint,
                               height:uint,
                               seed:String,
                               islandType:String,
                               pointType:String,
                               beach:Boolean,
                               rivers:Boolean):void
        {
            if (isNullOrEmpty(name))
            {
                throw new NullOrEmptyArgumentError("name");
            }

            if (width == 0 || height == 0)
            {
                throw new ArgumentError("Invalid shape size.");
            }

            if (isNullOrEmpty(seed))
            {
                throw new NullOrEmptyArgumentError("seed");
            }

            if (isNullOrEmpty(islandType))
            {
                throw new NullOrEmptyArgumentError("islandType");
            }

            if (isNullOrEmpty(pointType))
            {
                throw new NullOrEmptyArgumentError("pointType");
            }

            m_name = name;

            if (m_width != width ||
                m_height != height ||
                m_islandSeed != seed ||
                m_islandType != islandType ||
                m_pointType != pointType)
            {
                if (m_width != width || m_height != height)
                {
                    m_width = width;
                    m_height = height;
                    m_map.setSize(width, height);
                }

                m_created = false;
                m_islandSeed = seed;
                m_islandType = islandType;
                m_pointType = pointType;

                var progressId:String = StringUtil.randomKeyString();

                clear();
                clearNoisyEdges();
                m_beachLayer.graphics.clear();
                m_riversLayer.graphics.clear();

                drawMask();

                m_progressSignal.dispatch(progressId, 0, 5, "Shaping map...");
                shapeMap();
                m_changedSignal.dispatch();

                m_progressSignal.dispatch(progressId, 1, 5, "Placing points...");
                m_map.placePoints();
                m_changedSignal.dispatch();

                m_progressSignal.dispatch(progressId, 2, 5, "Building graph...");
                m_map.buildGraph();
                m_map.assignBiomes();
                m_changedSignal.dispatch();

                m_progressSignal.dispatch(progressId, 3, 5, "Features...");
                m_map.assignElevations();
                m_map.assignMoisture();
                m_map.assignBiomes();
                m_changedSignal.dispatch();

                m_progressSignal.dispatch(progressId, 4, 5, "Rivers...");
                m_noisyEdges.buildNoisyEdges(m_map, m_map.mapRandom);
                drawMap();

                m_progressSignal.dispatch(progressId, 5, 5, "");
            }

            m_beachLayer.visible = beach;
            m_riversLayer.visible = rivers;
            m_created = true;
            m_changedSignal.dispatch();
        }

        public function createBitmap():BitmapData
        {
            if (m_created)
            {
                var bitmap:BitmapData = new BitmapData(m_width, m_height, false, 0);
                bitmap.draw(this);
                return bitmap;
            }

            return null;
        }

        public function save(directory:File, water:uint, sand:uint, grass:uint, savePNG:Boolean = true, version:uint = 56):void
        {
            if (!directory)
            {
                throw new NullArgumentError("directory");
            }

            if (!directory.exists)
            {
                throw new FileNotFoundError(directory);
            }

            if (!m_created || m_saving)
            {
                throw new Error("Internal erro");
            }

            m_saving = true;

            var bitmap:BitmapData = this.createBitmap();
            var bytes:ByteArray = new PNGEncoder().encode(bitmap);
            bytes.position = 0;

            if (savePNG)
            {
                var pngFile:File = directory.resolvePath(m_name + ".png");
                var stream:FileStream = new FileStream();
                stream.open(pngFile, FileMode.WRITE);
                stream.writeBytes(bytes, 0, bytes.bytesAvailable);
                stream.close();
            }

            var color:Color = new Color();
            var width:uint = bitmap.width;
            var height:uint = bitmap.height;
            var tiles:Vector.<Tile> = new Vector.<Tile>();
            var value:uint = 0;
            var total:uint = width * height;
            var progressId:String = StringUtil.randomKeyString();
            var label:String = "Creating map..."
            var start:uint = 1024 - (width / 2);

            for (var x:uint = 0; x < width; x++)
            {
                for (var y:uint = 0; y < height; y++)
                {
                    var c:uint = bitmap.getPixel(x, y);
                    if (c != 0)
                    {
                        color.RGB = c;
                        var tile:Tile = new Tile(start + x, start + y, 7);

                        if (color.R == 0xFF)
                        {
                            tile.ground = sand;
                        }
                        else if (color.G == 0xCC)
                        {
                            tile.ground = grass;
                        }
                        else
                        {
                            tile.ground = water;
                        }

                        tiles[tiles.length] = tile;
                    }

                    value++;
                    if ((value % 100) == 0)
                    {
                        m_progressSignal.dispatch(progressId, value, total, label);
                    }
                }
            }

            m_progressSignal.dispatch(progressId, total, total, label);

            tiles.fixed = true;
            var otbm:OtbmWriter = new OtbmWriter();
            otbm.onProgress.add(m_progressSignal.dispatch);
            otbm.saveOtbm(directory.resolvePath(m_name + ".otbm"), tiles, version, "Generated with MapShapeGen.");

            var shapeFile:File = directory.resolvePath(m_name + ".otshape");
            var otshape:OTMLDocument = new OTMLDocument();
            otshape.tag = "Shape";
            otshape.writeAt("name", m_name);
            otshape.writeAt("width", m_width);
            otshape.writeAt("height", m_height);
            otshape.writeAt("seed", m_islandSeed);
            otshape.writeAt("island-type", m_islandType);
            otshape.writeAt("point-type", m_pointType);
            otshape.writeAt("beach", m_beachLayer.visible);
            otshape.writeAt("rivers", m_riversLayer.visible);
            otshape.save(shapeFile);

            otbm.onProgress.remove(m_progressSignal.dispatch);
            m_saving = false;
        }

        //--------------------------------------
        // Private
        //--------------------------------------

        // Random parameters governing the overall shape of the island
        private function shapeMap():void
        {
            var seed:int = 0;
            var variant:int = 0;

            if (m_islandSeed.length == 0)
            {
                m_islandSeed = generateSeed();
            }

            var match:Object = /\s*(\d+)(?:\-(\d+))\s*$/.exec(m_islandSeed);
            if (match != null)
            {
                // It's of the format SHAPE-VARIANT
                seed = parseInt(match[1]);
                variant = parseInt(match[2] || "0");
            }

            if (seed == 0)
            {
                // Convert the string into a number. This is a cheesy way to
                // do it but it doesn't matter. It just allows people to use
                // words as seeds.
                var length:uint = m_islandSeed.length;
                for (var i:int = 0; i < length; i++)
                {
                    seed = (seed << 4) | m_islandSeed.charCodeAt(i);
                }

                seed %= 100000;
                variant = 1 + Math.floor(9 * Math.random());
            }

            m_map.newIsland(m_islandType, m_pointType, seed, variant);
        }

        private function drawMap():void
        {
            this.clear();
            this.renderPolygons();
            this.renderRivers();
        }

        private function drawMask():void
        {
            m_mask.graphics.clear();
            m_mask.graphics.beginFill(0x000000);
            m_mask.graphics.drawRect(0, 0, m_width, m_height);
            m_mask.graphics.endFill();
        }

        private function clearNoisyEdges():void
        {
            m_noisyEdges.clear();
        }

        private function clear():void
        {
            graphics.clear();
            graphics.beginFill(0, 0);
            graphics.drawRect(0, 0, 2000, 2000);
            graphics.endFill();
            graphics.beginFill(BiomeColor.WATER);
            graphics.drawRect(0, 0, m_width, m_height);
            graphics.endFill();
        }

        // Helper functions for rendering paths
        private function drawPathForwards(graphics:Graphics, path:Vector.<Point>):void
        {
            for (var i:int = 0; i < path.length; i++)
            {
                graphics.lineTo(path[i].x, path[i].y);
            }
        }

        private function drawPathBackwards(graphics:Graphics, path:Vector.<Point>):void
        {
            for (var i:int = path.length-1; i >= 0; i--)
            {
                graphics.lineTo(path[i].x, path[i].y);
            }
        }

        public function renderRivers():void
        {
            var graphics:Graphics = m_riversLayer.graphics;
            for each (var p:Center in m_map.centers)
            {
                for each (var r:Center in p.neighbors)
                {
                    var edge:Edge = m_map.lookupEdgeFromCenter(p, r);
                    if (m_noisyEdges.path0[edge.index] != null &&
                        m_noisyEdges.path1[edge.index] != null &&
                        edge.river > 1 &&
                        edge.river < 50)
                    {
                        graphics.lineStyle(edge.river, BiomeColor.WATER);
                        graphics.moveTo(m_noisyEdges.path0[edge.index][0].x, m_noisyEdges.path0[edge.index][0].y);
                        drawPathForwards(graphics, m_noisyEdges.path0[edge.index]);
                        drawPathBackwards(graphics, m_noisyEdges.path1[edge.index]);

                    }
                }
            }

            graphics.endFill();
        }

        public function renderPolygons():void
        {
            graphics.beginFill(BiomeColor.WATER);
            graphics.drawRect(0, 0, m_width, m_height);
            graphics.endFill();

            for each (var p:Center in m_map.centers)
            {
                for each (var r:Center in p.neighbors)
                {
                    var edge:Edge = m_map.lookupEdgeFromCenter(p, r);
                    if (m_noisyEdges.path0[edge.index] != null && m_noisyEdges.path1[edge.index] != null)
                    {
                        var color:uint = p.biome;
                        if (color == BiomeColor.SAND)
                        {
                            m_beachLayer.graphics.beginFill(color);
                            drawPath0(p, edge, m_beachLayer.graphics);
                            drawPath1(p, edge, m_beachLayer.graphics);
                            m_beachLayer.graphics.endFill();
                            color = BiomeColor.GRASS;
                        }

                        this.graphics.beginFill(color);
                        drawPath0(p, edge, this.graphics);
                        drawPath1(p, edge, this.graphics);
                        this.graphics.endFill();
                    }
                }
            }
        }

        private function drawPath0(center:Center, edge:Edge, graphics:Graphics):void
        {
            var path:Vector.<Point> = m_noisyEdges.path0[edge.index];
            graphics.moveTo(center.point.x, center.point.y);
            graphics.lineTo(path[0].x, path[0].y);
            drawPathForwards(graphics, path);
            graphics.lineTo(center.point.x, center.point.y);
        }

        private function drawPath1(center:Center, edge:Edge, graphics:Graphics):void
        {
            var path:Vector.<Point> = m_noisyEdges.path1[edge.index];
            graphics.moveTo(center.point.x, center.point.y);
            graphics.lineTo(path[0].x, path[0].y);
            drawPathForwards(graphics, path);
            graphics.lineTo(center.point.x, center.point.y);
        }

        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------

        static public function generateSeed():String
        {
            return int(Math.random() * 100000) + "-" + (1 + int(9 * Math.random()));
        }
    }
}
