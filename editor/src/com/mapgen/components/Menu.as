/*
*  Copyright (c) 2016 Nailson S. <nailsonnego@gmail.com>
* 
*  Permission is hereby granted, free of charge, to any person obtaining a copy
*  of this software and associated documentation files (the "Software"), to deal
*  in the Software without restriction, including without limitation the rights
*  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*  copies of the Software, and to permit persons to whom the Software is
*  furnished to do so, subject to the following conditions:
* 
*  The above copyright notice and this permission notice shall be included in
*  all copies or substantial portions of the Software.
* 
*  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
*  THE SOFTWARE.
*/

package com.mapgen.components
{
    import com.mapgen.core.IMapShapeGen;
    import com.mignari.menu.MenuItem;
    import com.mignari.menu.NativeMenu;
    import com.mignari.utils.DescriptorUtil;

    import mx.core.FlexGlobals;
    import mx.events.FlexEvent;

    [ResourceBundle("mapgen_strings")]

    public class Menu extends NativeMenu
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------

        private var m_application:IMapShapeGen;

        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------

        public function Menu()
        {
            super();
            
            m_application = IMapShapeGen(FlexGlobals.topLevelApplication);
            m_application.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
        }

        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------

        //--------------------------------------
        // Private
        //--------------------------------------

        private function create():void
        {
            // root menu
            var menu:MenuItem = new MenuItem();
            var macMenu:MenuItem;

            // separator
            var separator:MenuItem = new MenuItem();

            if (this.isMacOS)
            {
                macMenu = new MenuItem();
                macMenu.label = DescriptorUtil.getName();
                menu.addMenuItem(macMenu);
            }

            // File
            var fileMenu:MenuItem = new MenuItem();
            fileMenu.label = resourceManager.getString("mapgen_strings", "MENU_FILE");
            menu.addMenuItem(fileMenu);

            // File > New
            var fileNewMenu:MenuItem = new MenuItem();
            fileNewMenu.label = resourceManager.getString("mapgen_strings", "MENU_FILE_NEW");
            fileNewMenu.data = FILE_NEW;
            fileNewMenu.keyEquivalent = "N";
            fileNewMenu.controlKey = true;
            fileMenu.addMenuItem(fileNewMenu);

            // File > Open
            var fileOpenMenu:MenuItem = new MenuItem();
            fileOpenMenu.label = resourceManager.getString("mapgen_strings", "MENU_FILE_OPEN");
            fileOpenMenu.data = FILE_OPEN;
            fileOpenMenu.keyEquivalent = "O";
            fileOpenMenu.controlKey = true;
            fileMenu.addMenuItem(fileOpenMenu);

            // File > Generate
            var fileGenerateMenu:MenuItem = new MenuItem();
            fileGenerateMenu.label = resourceManager.getString("mapgen_strings", "MENU_FILE_GENERATE");
            fileGenerateMenu.data = FILE_GENERATE;
            fileGenerateMenu.keyEquivalent = "G";
            fileGenerateMenu.controlKey = true;
            fileMenu.addMenuItem(fileGenerateMenu);

            // File > Save
            var fileSaveMenu:MenuItem = new MenuItem();
            fileSaveMenu.label = resourceManager.getString("mapgen_strings", "MENU_FILE_SAVE");
            fileSaveMenu.data = FILE_SAVE;
            fileSaveMenu.keyEquivalent = "S";
            fileSaveMenu.controlKey = true;
            fileMenu.addMenuItem(fileSaveMenu);

            fileMenu.addMenuItem(separator);

            // File > Preferences
            var filePreferencesMenu:MenuItem = new MenuItem();
            filePreferencesMenu.label = resourceManager.getString("mapgen_strings", "MENU_FILE_PREFERENCES");
            filePreferencesMenu.data = FILE_PREFERENCES;
            filePreferencesMenu.keyEquivalent = "P";
            filePreferencesMenu.controlKey = true;
            fileMenu.addMenuItem(filePreferencesMenu);

            // File > Exit
            var fileExitMenu:MenuItem = new MenuItem();
            fileExitMenu.label = resourceManager.getString("mapgen_strings", "MENU_FILE_EXIT");
            fileExitMenu.data = FILE_EXIT;
            fileExitMenu.keyEquivalent = "Q";
            fileExitMenu.controlKey = true;

            // Help
            var helpMenu:MenuItem = new MenuItem();
            helpMenu.label = resourceManager.getString("mapgen_strings", "MENU_HELP");
            menu.addMenuItem(helpMenu);

            // Help > About
            var aboutMenu:MenuItem = new MenuItem();
            aboutMenu.label = resourceManager.getString("mapgen_strings", "MENU_HELP_ABOUT") + " " + DescriptorUtil.getName();
            aboutMenu.data = HELP_ABOUT;

            if (this.isMacOS)
            {
                macMenu.addMenuItem(aboutMenu);
                macMenu.addMenuItem(separator);
                macMenu.addMenuItem(fileExitMenu);
            }
            else
            {
                fileMenu.addMenuItem(separator);
                fileMenu.addMenuItem(fileExitMenu);
                helpMenu.addMenuItem(aboutMenu);
            }

            this.dataProvider = menu.serialize();
        }

        //--------------------------------------
        // Event Handlers
        //--------------------------------------

        protected function creationCompleteHandler(event:FlexEvent):void
        {
            m_application.removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
            create();
        }

        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------

        static public const FILE_NEW:String = "FILE_NEW";
        static public const FILE_OPEN:String = "FILE_OPEN";
        static public const FILE_GENERATE:String = "FILE_GENERATE";
        static public const FILE_SAVE:String = "FILE_SAVE";
        static public const FILE_PREFERENCES:String = "FILE_PREFERENCES";
        static public const FILE_EXIT:String = "FILE_EXIT";
        static public const HELP_ABOUT:String = "HELP_ABOUT";
    }
}
