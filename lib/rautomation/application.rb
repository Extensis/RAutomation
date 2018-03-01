require 'set'
require 'windows/process'
require 'windows/handle'
require 'win32/api'
require 'win32/process'

include Windows::Process
include Windows::Handle

module RAutomation
  class Application

    include Adapter::Helper
    extend ElementCollections
  
    attr_reader :pid
  
    def initialize(options={})
      path = options[:path]
      args = options[:args]
      @adapter = options[:adapter] || ENV["RAUTOMATION_ADAPTER"] && ENV["RAUTOMATION_ADAPTER"].to_sym || default_adapter
    
	  path.gsub!("/", "\\")
      command_line = path
      
      if args != nil and args.length > 0
        command_line += " " + args.join(" ")
      end
	
      process = Process.create(
        :command_line => command_line,
        :close_handles => false,
        :creation_flags => Process::DETACHED_PROCESS
      )
      
      WaitForInputIdle(process.process_handle, 60000)
      
      CloseHandle(process.process_handle)
      CloseHandle(process.thread_handle)
      
	  sleep(1)
	  
	  get_module_file_name_ex = Win32::API.new('GetModuleFileNameEx', 'LLPL', 'L', 'psapi')
	  
	  @pid = nil
	  while pid == nil
		RAutomation::Window.windows.each {| window |
			candidate = '0' * 1024
			handle = RAutomation::Adapter::Win32::Functions::open_process(0x0410, false, window.pid)
			len = get_module_file_name_ex.call(handle, 0, candidate, candidate.length)
			if len > 0
				candidate = candidate.slice(0, len)
				if candidate == path
					@pid = window.pid
					break
				end
			end
			CloseHandle(handle)
		}
	  end
	end
    
    def windows
      return Windows.new(nil, :adapter => @adapter).select { | window | window.pid == @pid }
    end
    
    def main_window
	  candidates = windows.select { | window | window.active? }
	  
	  if candidates.length > 0
		return windows[0]
	  else
	    return nil
	  end
    end
    
    def menu_bar
      return main_window.menu_bar
    end
    
    def children
      children = windows
      children.push(menu_bar)
      
      return children
    end
    
    def raise!
      main_window.activate
    end
    
    def frontmost?
      return main_window.active?
    end
    
    def hidden?
      return false
    end

    def normalize adapter
      adapter.to_s.split("_").map {|word| word.capitalize}.join
    end
    
  end
end