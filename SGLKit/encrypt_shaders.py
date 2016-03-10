#
# encrypt_shaders
#
# usage: encrypt_shaders password [encryption_program] [shader_directory]
#

import sys, os

#
# Encrypt a particular file.
#

def encrypt(password, encryptor, source_file, target_file):
    
    command = "%s %s %s %s" % (encryptor, source_file, target_file, password)
    
    exit_code = os.system(command)
    
    if exit_code:
        sys.exit("Encrypting file %s: ERROR %d" % (source_file, exit_code))

#
# Main
#

if __name__ == "__main__":
    
    argc = len(sys.argv)
    
    if argc < 2:
        sys.exit("Usage: encrypt_shaders password [encryption_program] [shader_directory]")
    
    # Grab some xcode build environment variables.
    
    buildDir = os.environ['TARGET_BUILD_DIR']
    resourcesDir = os.environ['UNLOCALIZED_RESOURCES_FOLDER_PATH']

    # Get the supplied arguments, or use sensible defaults.
    
    password  = sys.argv[1]

    if argc > 2:
        encryptor = sys.argv[2]
    else:
        encryptor = os.path.join(buildDir, "EncryptFile")

    if argc > 3:
        directory = sys.argv[3]
    else:
        directory = os.path.join(buildDir, resourcesDir)

    # Iterate over all the files in the directory.
    
    print "Encrypting shaders in:", directory

    for file in os.listdir(directory):
        
        name, extension = os.path.splitext(file)
        
        # If the files have a shader extension, encrypt them.
        
        if extension in [".glsl", ".vert", ".frag"]:
            
            print "Encrypting:", file
            
            source_file = os.path.join(directory, file)
            target_file = source_file + "data"
        
            encrypt(password, encryptor, source_file, target_file)
            os.remove(source_file)
