require 'windows/process'

module RAutomation
  class Application

    attr_reader :pid
    
    has_many :windows
  
    def initialize(options={})
      path = options[:path]
      args = options[:args]
      @adapter = options[:adapter] || ENV["RAUTOMATION_ADAPTER"] && ENV["RAUTOMATION_ADAPTER"].to_sym || default_adapter
    
      command_line = path
      
      if args != nil and args.length > 0
        command_line += " " + args.join(" ")
      end
      
      process = Process.create(
        :command_line => command,
        :close_handles => false,
        :creation_flags => Process::DETACHED_PROCESS
      )
      
      @pid = process.pid
      
      WaitForInputIdle(process, 60000)
      
      CloseHandle(process.process_handle)
      CloseHandle(process.thread_handle)
    end
    
    def windows
      return Windows.new(nil, :pid=> @pid, :adapter => @adapter)
    end
    
    def main_window
      return windows[0]
    end
    
    def menu_bar
      return main_window.menu_bar
    end
    
    def children
      children = windows
      children.push(menu_bar)
      
      return children
    end
    
    def focused_ui_element
      # TODO: Implement this
    end
    
    def raise!
      main_window.activate
    end
    
    def frontmost?
      return main_window.active?
    end
    
    def hide
      # TODO: Can't hide apps on Windows. Throw exception?
    end
    
    def show
      # TODO: Can't hide apps on Windows. Throw exception?
    end
    
    def hidden?
      return false
    end

    def normalize adapter
      adapter.to_s.split("_").map {|word| word.capitalize}.join
    end
    
  end
end