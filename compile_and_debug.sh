#!/bin/bash

tools_path="/Users/christian/projects/code/c64/tools"
exomizer_exec="${tools_path}/exomizer/exomizer-3.1.1/exomizer"
kickass_jar="${tools_path}/kickassembler/kickassembler_5.24/KickAss.jar"
vice_exec="x64sc"
#debug_exec="${tools_path}/C64\ 65XE\ NES\ Debugger/C64\ 65XE\ NES\ Debugger\ v0.64.58.6/C64\ Debugger.app/Contents/MacOS/C64\ Debugger"
debug_exec="${tools_path}/C64 65XE NES Debugger/C64 65XE NES Debugger v0.64.58.6/C64 Debugger.app/Contents/MacOS/C64 Debugger"
cc1541_exec="${tools_path}/cc1541/cc1541_bin-4.0/cc1541_mac"

assemblerFile=$1

projectFileDir=$2
projectFileDir="${projectFileDir:-.}"

runMode=$3
runMode="${runMode:-run}"

echo "Project file dir: $projectFileDir"
echo "Run mode: $runMode"

# Get absolute path for supplied project path (no relative path)
cd $projectFileDir
projectFileDir=$(pwd)
cd -

assemblerFileWithExtension=$(basename -- "$assemblerFile")
extension="${assemblerFileWithExtension##*.}"
filename="${assemblerFileWithExtension%.*}"

target_path="${projectFileDir}/target"
assemblerAbsoluteFile="${projectFileDir}/${assemblerFile}"
originalProgramFile="${target_path}/${filename}.original.prg"
finalProgramFile="${target_path}/${filename}.prg"
viceMonitorCommandsFile="${target_path}/${filename}.vs"
c64_disc_file="${target_path}/${filename}.d64"

echo
echo "Cleaning previous builds"
echo "Recreating path: ${target_path}"
echo "--------------------------------------------------"
rm -rf "${target_path}"
mkdir "${target_path}"

echo
echo "Compiling file"
echo "Input file:  ${assemblerAbsoluteFile}"
echo "Output file: ${originalProgramFile}"
echo "--------------------------------------------------"
java -jar $kickass_jar -symbolfile -vicesymbols -odir "${target_path}" -o "${originalProgramFile}" "${assemblerAbsoluteFile}"

echo
echo "Crunching file"
echo "Input file:  ${originalProgramFile}"
echo "Output file: ${finalProgramFile}"
echo "--------------------------------------------------"
$exomizer_exec sfx systrim "${originalProgramFile}" -o "${finalProgramFile}"

#"${debug_exec}" --help
#echo "Debugger path: ${debug_exec}"

echo
echo "Creating C64 disc file"
echo "Input file:  ${finalProgramFile}"
echo "Output file: ${c64_disc_file}"
echo "--------------------------------------------------"
"${cc1541_exec}" -n "${filename}" -f "${filename}" -w "${finalProgramFile}" "${c64_disc_file}"

echo
echo "--------------------------------------------------"
echo "Project dir:          ${projectFileDir}/"
echo "Compiling file:       ${assemblerFile}"
echo "Final program file:   ${finalProgramFile}"
echo "C64 disc file:        ${c64_disc_file}"
echo "--------------------------------------------------"

if [[ $runMode == "run" ]]
then
  $vice_exec -moncommands "$viceMonitorCommandsFile" -autostartprgmode 1 "$finalProgramFile"
else
  #"${debug_exec}" -prg "${finalProgramFile}" -wait 9000 -autojmp
  "${debug_exec}" -prg "${finalProgramFile}" -wait 5000 -autojmp
fi
