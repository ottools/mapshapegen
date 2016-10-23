// Author: nailsonnego@gmail.com
// License: MIT

package com.mapgen.commands
{
    import com.mignari.workers.WorkerCommand;

    import flash.filesystem.File;

    public class OpenShapeCommand extends WorkerCommand
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function OpenShapeCommand(file:File)
        {
            super(file);
        }
    }
}
