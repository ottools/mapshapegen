// Author: nailsonnego@gmail.com
// License: MIT

package com.mapgen.core
{
    import flash.events.IEventDispatcher;

    import mx.core.IWindow;

    public interface IMapShapeGen extends IEventDispatcher, IWindow
    {
        function get mapCreated():Boolean;
        function get mapSaving():Boolean;
    }
}
