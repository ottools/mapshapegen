// Author: nailsonnego@gmail.com
// License: MIT

package com.mapgen.commands
{
    import com.mapgen.utils.MapInfo;
    import com.mignari.workers.WorkerCommand;

    public class MapInfoCommand extends WorkerCommand
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function MapInfoCommand(info:MapInfo)
        {
            super(info);
        }
    }
}
