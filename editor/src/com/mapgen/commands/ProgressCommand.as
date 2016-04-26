/*
* Copyright (c) 2015 Nailson Santos <nailsonnego@gmail.com>
* 
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
* 
*      http://www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
* either express or implied. See the License for the specific language
* governing permissions and limitations under the License.
*/

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
