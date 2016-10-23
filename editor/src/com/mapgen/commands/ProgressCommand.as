// Author: nailsonnego@gmail.com
// License: MIT

package com.mapgen.commands
{
    import com.mignari.workers.WorkerCommand;

    public class ProgressCommand extends WorkerCommand
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function ProgressCommand(id:String = null, value:uint = 0, total:uint = 0, label:String = null)
        {
            super(id, value, total, label);
        }

        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------

        //--------------------------------------
        // Public
        //--------------------------------------

        public function update(id:String, value:uint, total:uint, label:String):ProgressCommand
        {
            m_args[0] = id;
            m_args[1] = value;
            m_args[2] = total;
            m_args[3] = label;
            return this;
        }
    }
}
