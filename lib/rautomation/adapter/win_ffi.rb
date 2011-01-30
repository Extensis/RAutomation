begin
  gem "ffi"
rescue Gem::LoadError
  raise Gem::LoadError, "Unable to load FFI gem. Install it with:\n\tgem install ffi"
end
require "ffi"
require File.dirname(__FILE__) + "/win_ffi/constants"
require File.dirname(__FILE__) + "/win_ffi/functions"
require File.dirname(__FILE__) + "/win_ffi/locators"
require File.dirname(__FILE__) + "/win_ffi/window"
require File.dirname(__FILE__) + "/win_ffi/button_helper"
require File.dirname(__FILE__) + "/win_ffi/control"
require File.dirname(__FILE__) + "/win_ffi/button"
require File.dirname(__FILE__) + "/win_ffi/checkbox"
require File.dirname(__FILE__) + "/win_ffi/radiobutton"
require File.dirname(__FILE__) + "/win_ffi/text_field"
require File.dirname(__FILE__) + "/win_ffi/select_list"
require File.dirname(__FILE__) + "/win_ffi/table"