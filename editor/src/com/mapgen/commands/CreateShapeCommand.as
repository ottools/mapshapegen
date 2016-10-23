// Author: nailsonnego@gmail.com
// License: MIT

package com.mapgen.commands
{
    import com.mignari.workers.WorkerCommand;

    public class CreateShapeCommand extends WorkerCommand
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function CreateShapeCommand(name:String, width:uint, height:uint)
        {
            super(name, width, height);
        }
    }
}
