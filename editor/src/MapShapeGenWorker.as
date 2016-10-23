// Author: nailsonnego@gmail.com
// License: MIT

package
{
    import com.mapgen.Canvas;
    import com.mapgen.Generator;
    import com.mapgen.commands.CreateShapeCommand;
    import com.mapgen.commands.MapInfoCommand;
    import com.mapgen.commands.OpenShapeCommand;
    import com.mapgen.commands.ProgressCommand;
    import com.mapgen.commands.SaveMapCommand;
    import com.mapgen.commands.SettingsCommand;
    import com.mapgen.commands.UpdatePreviewCommand;
    import com.mapgen.commands.UpdateShapeComamnd;
    import com.mapgen.settings.MapShapeGenSettings;
    import com.mapgen.utils.MapInfo;
    import com.mignari.errors.NullArgumentError;
    import com.mignari.errors.NullOrEmptyArgumentError;
    import com.mignari.utils.isNullOrEmpty;
    import com.mignari.workers.IWorkerCommunicator;
    import com.mignari.workers.WorkerCommunicator;

    import flash.display.Sprite;
    import flash.filesystem.File;
    import flash.utils.ByteArray;

    public class MapShapeGenWorker extends Sprite
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------

        private var m_communicator:IWorkerCommunicator;
        private var m_generator:Generator;
        private var m_sharedByteArray:ByteArray;
        private var m_canvas:Canvas;
        private var m_settings:MapShapeGenSettings;
        private var m_progress:ProgressCommand;

        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function MapShapeGenWorker()
        {
            m_communicator = new WorkerCommunicator();
            m_communicator.registerClass(MapShapeGenSettings);
            m_communicator.registerClass(MapInfo);
            m_communicator.registerCallback(SettingsCommand, settingsCallback);
            m_communicator.registerCallback(CreateShapeCommand, createShapeCallback);
            m_communicator.registerCallback(OpenShapeCommand, openShapeCallback);
            m_communicator.registerCallback(UpdateShapeComamnd, updateShapeCallback);
            m_communicator.registerCallback(SaveMapCommand, saveMapCallback);
            m_communicator.start();

            m_sharedByteArray = m_communicator.worker.getSharedProperty("sharedByteArray");
            m_canvas = new Canvas(1024, 1024);
            m_generator = new Generator();
            m_generator.onChanged.add(changedCallback);
            m_generator.onProgress.add(progressCallback);

            m_progress = new ProgressCommand();
        }

        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------

        //--------------------------------------
        // Private
        //--------------------------------------

        private function sendMapInfo():void
        {
            var info:MapInfo = new MapInfo();
            info.name = m_generator.name;
            info.width = m_generator.width;
            info.height = m_generator.height;
            info.seed = m_generator.islandSeed;
            info.islandType = m_generator.islandType;
            info.pointType = m_generator.pointType;
            info.beach = m_generator.beach;
            info.rivers = m_generator.rivers;
            info.created = m_generator.created;
            info.changed = m_generator.changed;
            info.saving = m_generator.saving;
            m_communicator.sendCommand(new MapInfoCommand(info));
        }

        private function sendPreview():void
        {
            if (m_generator.created)
            {
                m_canvas.clear();
                m_canvas.draw(m_generator);
                m_canvas.copyToByteArray(m_sharedByteArray);
                m_communicator.sendCommand(new UpdatePreviewCommand(m_generator.islandSeed));
            }
        }

        private function changedCallback():void
        {
            this.sendMapInfo();
            this.sendPreview();
        }

        private function progressCallback(id:String, value:uint, total:uint, label:String):void
        {
            m_communicator.sendCommand(m_progress.update(id, value, total, label));
        }

        private function settingsCallback(settings:MapShapeGenSettings):void
        {
            if (!settings)
            {
                throw new NullArgumentError("settings");
            }

            m_settings = settings;
        }

        private function createShapeCallback(name:String, width:uint, height:uint):void
        {
            if (isNullOrEmpty(name))
            {
                throw new NullOrEmptyArgumentError("name");
            }

            var seed:String = Generator.generateSeed();
            m_generator.create(name + "_" + seed,
                               width,
                               height,
                               seed,
                               m_settings.islandType,
                               m_settings.pointType,
                               m_settings.showBeach,
                               m_settings.showRivers);
        }

        private function openShapeCallback(file:File):void
        {
            m_generator.load(file);
        }

        private function updateShapeCallback(islandType:String, pointType:String, beach:Boolean, rivers:Boolean):void
        {
            if (isNullOrEmpty(islandType))
            {
                throw new NullOrEmptyArgumentError("islandType");
            }

            if (isNullOrEmpty(pointType))
            {
                throw new NullOrEmptyArgumentError("pointType");
            }

            m_generator.create(m_generator.name,
                               m_generator.width,
                               m_generator.height,
                               m_generator.islandSeed,
                               islandType,
                               pointType,
                               beach,
                               rivers);
        }

        private function saveMapCallback():void
        {
            m_generator.save(m_settings.ouputDirectory,
                             m_settings.waterItem,
                             m_settings.sandItem,
                             m_settings.grassItem,
                             m_settings.savePNG,
                             m_settings.version);
        }
    }
}
