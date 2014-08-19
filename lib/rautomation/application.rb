require 'set'
require 'windows/process'
require 'windows/handle'
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
      
	  pids = Set.new([])
	  RAutomation::Window.windows.each { | window | pids.add(window.pid) }
	  
	  sleep(2)
	  if (pids.include? process.process_id)
	    # The PID still exists, so it was the PID that launched the process.
		@pid = process.process_id
	  else
	    # The PID no longer exists, meaning the application was already running
		# when we tried to launch it.
        hwnd = RAutomation::Adapter::Win32::Functions.get_foreground_window
        @pid = RAutomation::Adapter::Win32::Functions.window_pid(hwnd)
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