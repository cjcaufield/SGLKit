import sys, os

PROJECTS_DIR = "/Users/colin/Work/"
SHADER_DIR = PROJECTS_DIR + "SGLKit/Shaders/"

def encrypt(source_file, target_file):
    
    encryptor = PROJECTS_DIR + "EncryptFile/build/Release/EncryptFile"
    
    command = "%s %s %s %s" % (encryptor, source_file, target_file, "Interlace")
    
    exit_code = os.system(command)
    
    if exit_code:
        print "Encrypting file %s: ERROR %d" % (source_file, exit_code)
        sys.exit(2)

if __name__ == "__main__":
    
    TARGET_DIR = sys.argv[1]
    
    print "Building SGLKit shaders"
    print "Target: ", TARGET_DIR
    
    include_names = ["Platform", "Utilities", "Vertex", "Fragment"]
    shader_names = ["Basic", "BasicTexture", "Color", "Combine", "Copy",  "CopyPixels", "CopyTexture", "Gaussian"]
    
    for name in include_names:
        
        #print "Encrypting From",    SHADER_DIR + name + ".glsl"
        #print "Encrypting To",      SHADER_DIR + name + ".glsldata"
        #print "Copying From",       SHADER_DIR + name + ".glsldata"
        #print "Copying To",         TARGET_DIR + name + ".glsldata"
        #print "Removing",           SHADER_DIR + name + ".glsldata"
        
        encrypt(SHADER_DIR + name + ".glsl", SHADER_DIR + name + ".glsldata")
        os.system("cp %s %s" % (SHADER_DIR + name + ".glsldata", TARGET_DIR + name + ".glsldata"))
        os.system("rm " + SHADER_DIR + name + ".glsldata")
        
    for name in shader_names:
        
        #print "Encrypting From",    SHADER_DIR + name + ".vert"
        #print "Encrypting To",      SHADER_DIR + name + ".vertdata"
        #print "Copying From",       SHADER_DIR + name + ".vertdata"
        #print "Copying To",         TARGET_DIR + name + ".vertdata"
        #print "Removing",           SHADER_DIR + name + ".vertdata"
        
        encrypt(SHADER_DIR + name + ".vert", SHADER_DIR + name + ".vertdata")
        os.system("cp %s %s" % (SHADER_DIR + name + ".vertdata", TARGET_DIR + name + ".vertdata"))
        os.system("rm " + SHADER_DIR + name + ".vertdata")
        
        #print "Encrypting From",    SHADER_DIR + name + ".frag"
        #print "Encrypting To",      SHADER_DIR + name + ".fragdata"
        #print "Copying From",       SHADER_DIR + name + ".fragdata"
        #print "Copying To",         TARGET_DIR + name + ".fragdata"
        #print "Removing",           SHADER_DIR + name + ".fragdata"
        
        encrypt(SHADER_DIR + name + ".frag", SHADER_DIR + name + ".fragdata")
        os.system("cp %s %s" % (SHADER_DIR + name + ".fragdata", TARGET_DIR + name + ".fragdata"))
        os.system("rm " + SHADER_DIR + name + ".fragdata")
