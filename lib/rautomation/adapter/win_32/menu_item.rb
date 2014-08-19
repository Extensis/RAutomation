module RAutomation
  module Adapter
    module Win32
      class MenuItem
      
        attr_accessor :title, :id, :rect, :index, :keyboard_index
      
        def initialize(window, hmenu, index, keyboard_index)
          @window = window
          @hmenu = hmenu
          @index = index
		  @keyboard_index = keyboard_index
          
          if @hmenu != nil
            parse_title(Functions::get_menu_string(@hmenu, index))
          end
        end
        
        def parse_title(title)
          if title != nil
            components = title.split("\u0008")
            
            if components.length > 0
              title = components[0]
            end
        
            if title != nil
              shortcut_regex = /[^&]{1}[&]{1}(.)/
              shortcut_match = shortcut_regex.match(title)
              
              if shortcut_match != nil && shortcut_match.length > 1
                @shortcut_char = shortcut_match[1]
              end
            
              title.gsub!("&&", "<escaped_ampersand>")
              title.gsub!("&", "")
              title.gsub!("<escaped_ampersand>", "&")
              title.rstrip!
          
              @title = title
            end
          end
        end
        
        def id
          if @hmenu != nil
            Functions.get_menu_item_id(@hmenu, @index)
          end
        end
        
        def rect
          Functions::get_menu_item_rect(@window.hwnd, @hmenu, @index)
        end
        
        def click
          if @window != nil && @window.exists? && @shortcut_char != nil
            if !is_submenu?
              @window.send_key(Keys.alt)
            end
            
            @window.send_key(Keys.encode_str(@shortcut_char)[0])
          end
        end
        
        def is_submenu?
          return @window != nil && @window.exists? && @window.window_class == "#32768"
        end
        
        def submenu_hmenu
          Functions::get_sub_menu(@hmenu, @index)
        end 
        
        def submenu
          if @submenu == nil
              @submenu = Menu.new(nil, submenu_hmenu)
          end
          
          @submenu
        end
        
        def exist?
          @hwindow != nil && @hmenu != nil
        end
        
      end
    end
  end
end