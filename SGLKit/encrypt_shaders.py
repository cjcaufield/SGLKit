#
# encrypt_shaders
#
# usage: encrypt_shaders DIRECTORY PASSWORD
#

import sys, os

#
# The encryption program to use.
#

#encryptor = "EncryptFile"
encryptor = "/Users/colin/Work/EncryptFile/build/Release/EncryptFile" # TEMP

#
# Encrypt a particular file.
#

def encrypt(source_file, target_file, password):
    
    command = "%s %s %s %s" % (encryptor, source_file, target_file, password)
    
    exit_code = os.system(command)
    
    if exit_code:
        sys.exit("Encrypting file %s: ERROR %d" % (source_file, exit_code))

#
# Gather all the shader files in the given directory and encrypt them.
#

if __name__ == "__main__":
    
    if len(sys.argv) < 3:
        sys.exit("Usage: encrypt_shaders DIRECTORY PASSWORD")
    
    directory = sys.argv[1]
    password = sys.argv[2]
    
    print "Encrypting shaders in:", directory

    for file in os.listdir(directory):
        
        print "File:", file
        
        name, extension = os.path.splitext(file)
        
        print "Name:", name, "extension:", extension
        
        if extension in [".glsl", ".vert", ".frag"]:
            
            print "Encrypting file: ", file
            
            source_file = os.path.join(directory, file)
            target_file = source_file + "data"
        
            encrypt(source_file, target_file, password)
            os.remove(source_file)
