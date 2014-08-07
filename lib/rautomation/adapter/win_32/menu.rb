module RAutomation
  module Adapter
    module Win32

      class Menu
      
        attr_accessor :hmenu
      
        def initialize(window, hmenu)
          if window != nil
            @window = window
            
            if hmenu != nil
              @hmenu = hmenu
            else
              @hmenu = Functions.get_menu(@window.hwnd)
            end
            
          else
            @window = RAutomation::Window.new(:class => "#32768", :adapter => :win_32)
            
            if hmenu != nil
              @hmenu = hmenu
            elsif @window.exists?
              @hmenu = Functions.get_hmenu(@window.hwnd)
            end
          end
          
          if exists?
            @children = []
            numChildren = count
            for childNum in 0...numChildren
              @children.push(MenuItem.new(@window, @hmenu, childNum))
            end
          end
          
        end
        
        def exist?
          return @hmenu != nil
        end
        
        alias_method :exists?, :exist?
        
        def count
          Functions.get_menu_item_count(@hmenu)
        end
        
        def menu_item(locator)
          title = locator[:title]
          title.force_encoding("ASCII-8BIT")
          
          for child in @children
            if child.title == title
              return child
            end
          end
          
          MenuItem.new(nil, nil, 0)
        end
      
      end

    end
  end
end