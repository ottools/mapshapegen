// Author: nailsonnego@gmail.com
// License: MIT

package com.mapgen.commands
{
    import com.mignari.workers.WorkerCommand;

    public class UpdatePreviewCommand extends WorkerCommand
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function UpdatePreviewCommand(islandSeed:String)
        {
            super(islandSeed);
        }
    }
}
