# Easily build boost on Visual Studio 2017
Notice mpi support is added, that requires pre-installation of Windows MPI pbak (https://msdn.microsoft.com/en-us/library/bb524831(v=vs.85).aspx), then configure the `mpi.jam` file. There is an example of `mpi.jam` under this directory. Also add `using mpi ;` to the end of project configuration file `project-config.jam`.

### Description
Windows batch script to build the boost library.
Builds boost with all runtime link types for both 32 and 64 bit architectures. MPI support is added.

### Versions
- Tested with 1.64.0 (build_boost_1_64_0_vs2017_win32_x64.bat)

### Instructions
1. Notice in the batch file, `--prefix` is set to be `--prefix=C:\Program Files\boost\boost_1_64_0`, change it accordingly.

2. MPI configuration example is under `E:\Softwares\boost_build\mpi.jam` on my computer, change it accordingly.

3. Copy the .bat file and mpi.jam file inside boost's directory (eg C:\boost_1_64_0).

4. **Using Visual Studio 2017's Developer Command Prompt** (found in "Windows' Start"\All Programs\Visual Studio 2017\Visual Studio Tools), go to the boost root directory (eg. C:\boost_1_64_0) and call-execute to bat provided in this repo build_boost_1_64_0_vs2017_win32_x64.bat.

Note: Go for 2 Coffees... the process takes a long time.

### Next Steps - Linking Boost With Visual Studio 2017
1. Add headers
	- Go to Solution Explorer -> Properties -> C/C++ -> General
	- Pick & Set on "Additional Include Directories" = BOOST_ROOT (eg. `C:\Program Files\boost\boost_1_64_0\include`)

	- Properties -> C/C++ -> General -> Precompiled Header
	- Pick & Set on "Precompiled Header" to option Not Using Precompiled Headers

2. Add compiled libraries
	- Go to Solution Explorer -> Properties -> Linker -> General
	- Pick & Set on "Additional Library Directories" = BOOST_ROOT\lib (eg. `C:\Program Files\boost\boost_1_64_0\lib`)
