// Author: nailsonnego@gmail.com
// License: MIT

package com.mapgen.commands
{
    import com.mignari.workers.WorkerCommand;

    public class UpdateShapeComamnd extends WorkerCommand
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function UpdateShapeComamnd(islandType:String, pointType:String, beach:Boolean, rivers:Boolean)
        {
            super(islandType, pointType, beach, rivers);
        }
    }
}
