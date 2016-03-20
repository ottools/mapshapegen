package
{
    import flash.utils.ByteArray;

    public class Workers
    {
        [Embed(source="../workerswfs/MapShapeGenWorker.swf", mimeType="application/octet-stream")]
        private static var MapShapeGenWorkerByteClass:Class;
        public static function get MapShapeGenWorker():ByteArray
        {
            return new MapShapeGenWorkerByteClass();
        }
    }
}
