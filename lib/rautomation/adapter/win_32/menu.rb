module RAutomation
  module Adapter
    module Win32

      class Menu
      
        def initialize(window)
          @window = window
          @hmenu = Functions.get_menu(window.hwnd)
        end
        
        def count
          Functions.get_menu_item_count(@hmenu)
        end
        
        def title(index)
          Functions.get_menu_string(hmenu, index)
        end
      
      end

    end
  end
end