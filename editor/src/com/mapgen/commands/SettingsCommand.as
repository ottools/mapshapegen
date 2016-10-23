// Author: nailsonnego@gmail.com
// License: MIT

package com.mapgen.commands
{
    import com.mapgen.settings.MapShapeGenSettings;
    import com.mignari.workers.WorkerCommand;

    public class SettingsCommand extends WorkerCommand
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function SettingsCommand(settings:MapShapeGenSettings)
        {
            super(settings);
        }
    }
}
