# set this if you have the Xcode Command Line Tools installed
var clang_libraries_path="/Library/Developer/CommandLineTools/usr/lib/clang/8.1.0/lib/darwin"

# this is to say use this search path for libraries to link against
--passL:"-L/Library/Developer/CommandLineTools/usr/lib/clang/8.1.0/lib/darwin"
# this is to say include the @rpath in the resulting binary to specify where to look for the clang libraries
--passL:"-Wl,-rpath,/Library/Developer/CommandLineTools/usr/lib/clang/8.1.0/lib/darwin"

# link against the ASAN dynamic library to take advantage of runtime checks
--passL:"-lclang_rt.asan_osx_dynamic"
# pass the flag to the C compiler to tell it to utilize the ASAN instrumentation
--passC:"-fsanitize=address"

--threads:on
--passL:"/Users/zachcarter/projects/frag-spine/spine-runtimes/spine-c/.build/libspine-c.a"